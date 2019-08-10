#include "newmsgnotification.h"

#include <QThread>
#include <QDebug>

#include "api.h"
#include "id_std.h"
#include "pipeline.h"
#include "qmlapplicationviewer.h"

#define SYNC_TIME_INTERVAL 20000
#define SYNC_TIME_INTERVAL_IDLE 300000

extern QmlApplicationViewer *qml_viewer;
extern idPipeline *pipeline;

class idSyncUnreadThread : public QThread
{
	//Q_OBJECT

	public:
		explicit idSyncUnreadThread(id_newMsgNotification *parent)
			: QThread(parent),
			m_notification(parent),
			m_interval(SYNC_TIME_INTERVAL),
			m_interval_idle(SYNC_TIME_INTERVAL_IDLE)
		{
			setObjectName("idSyncUnreadThread");
		}

		virtual ~idSyncUnreadThread()
		{
			ID_QOBJECT_DESTROY_DBG
		}

		virtual void run()
		{
			while(1)
			{
				m_notification->Begin();
				if(Handle()) Response();
				QThread::msleep(qml_viewer->isActiveWindow() ? m_interval : m_interval_idle);
			}
		}

public Q_SLOTS:
    void start(Priority priority = IdlePriority)
		{
			QThread::start(priority);
		}

	private:
		bool Handle()
		{
			int ret;
			if(!id::network_online())
			{
				qDebug() << "[Debug]: network is offline.";
				return false;
			}

			m_result = idAPI::Unread(QVariantMap(), &ret);
			if(ret != 0)
			{
				return false;
			}
			if(m_result["ok"].toInt())
			{
				m_result = m_result["data"].toMap();
				return true;
			}
			else
			{
				return false;
			}
		}

		//"{"ok":1,"data":{"cmt":0,"status":0,"follower":0,"dm":4,"mention_cmt":0,"mention_status":0,"attitude":0,"unreadmblog":0,"uid":"6973631565","bi":0,"newfans":0,"unreadmsg":{"1":0,"3":4,"4":0,"8":0},"group":null,"notice":0,"photo":0,"msgbox":0}}"
		void Response()
		{
			if(!m_notification)
				return;

			m_notification->SetFollowCount(m_result["follower"].toInt());
			m_notification->SetPrivateMsgCount(m_result["dm"].toInt());
			m_notification->SetMentionCount(m_result["mention_cmt"].toInt());
			m_notification->SetCommentCount(m_result["cmt"].toInt());
			m_notification->SetNewStatus(m_result["status"].toInt());
			// mention_status 被转发
		}

	private:
		id_newMsgNotification *m_notification;
		int m_interval;
		int m_interval_idle;
		QVariantMap m_result;
		bool m_notify;

		friend class id_newMsgNotification;
};

	id_newMsgNotification::id_newMsgNotification(QObject *parent)
: QObject(parent),
	m_thread(0),
	m_followCount(0),
	m_commentCount(0),
	m_mentionCount(0),
	m_privateMsgCount(0),
	m_newStatus(0),
	m_isNewStatus(false),
	m_notify(false)
{
	setObjectName("id_newMsgNotification");
}

id_newMsgNotification::~id_newMsgNotification()
{
	ID_QOBJECT_DESTROY_DBG
		if(m_thread)
		{
			m_thread->terminate();
		}
}

void id_newMsgNotification::reset()
{
	stop();
	start();
}

void id_newMsgNotification::stop()
{
	if(m_thread)
		m_thread->quit();
	End();
}

void id_newMsgNotification::start()
{
	if(!m_thread)
		m_thread = new idSyncUnreadThread(this);
	m_thread->start();
}

void id_newMsgNotification::Notify(const QString &msg)
{
	if(m_notify)
		return;
	pipeline->ShowNotification(ID_NAME " 提醒", msg);
	m_notify = true;
}

int id_newMsgNotification::FollowCount() const
{
	return m_followCount;
}

void id_newMsgNotification::SetFollowCount(int c)
{
	if(m_followCount != c)
	{
		if(c - m_followCount)
			Notify(QString("您有%1位新粉丝.").arg(c - m_followCount));
		m_followCount = c;
		emit followCountChanged(m_followCount);
	}
}

int id_newMsgNotification::CommentCount() const
{
	return m_commentCount;
}

void id_newMsgNotification::SetCommentCount(int c)
{
	if(m_commentCount != c)
	{
		if(c > m_commentCount)
			Notify(QString("您有%1条新的未读评论.").arg(c - m_commentCount));
		m_commentCount = c;
		emit commentChanged(m_commentCount);
	}
}

int id_newMsgNotification::MentionCount() const
{
	return m_mentionCount;
}

void id_newMsgNotification::SetMentionCount(int c)
{
	if(m_mentionCount != c)
	{
		if(c > m_mentionCount)
			Notify(QString("您被%1次新的at到.").arg(c - m_mentionCount));
		m_mentionCount = c;
		emit mentionChanged(m_mentionCount);
	}
}

int id_newMsgNotification::PrivateMsgCount() const
{
	return m_privateMsgCount;
}

void id_newMsgNotification::SetPrivateMsgCount(int c)
{
	if(m_privateMsgCount != c)
	{
		if(c > m_privateMsgCount)
		{
			Notify(QString("您有%1条新的未读私信.").arg(c - m_privateMsgCount));
			emit newMsgCome();
		}
		m_privateMsgCount = c;
		emit privateMsgChanged(m_privateMsgCount);
	}
}

bool id_newMsgNotification::IsNewStatus() const
{
	return m_isNewStatus;
}

void id_newMsgNotification::SetNewStatus(int c)
{
	if(m_newStatus != c)
	{
		SetIsNewStatus(c - m_newStatus);
		m_newStatus = c;
	}
}

void id_newMsgNotification::SetIsNewStatus(bool b)
{
	if(m_isNewStatus != b)
	{
		m_isNewStatus = b;
		emit newStatusChanged(m_isNewStatus);
	}
}

void id_newMsgNotification::End()
{
	SetFollowCount(0);
	SetCommentCount(0);
	SetMentionCount(0);
	SetPrivateMsgCount(0);
	SetNewStatus(0);
	SetIsNewStatus(false);
	m_notify = false;
}

void id_newMsgNotification::Begin()
{
	m_notify = false;
}

ID_SINGLE_INSTANCE_DECL(id_newMsgNotification)
