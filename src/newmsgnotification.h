#ifndef _KARIN_NEWMSGNOTIFICATION_H
#define _KARIN_NEWMSGNOTIFICATION_H

#include <QObject>

#include "id_std.h"

class QThread;
class idSyncUnreadThread;

class id_newMsgNotification : public QObject
{
	Q_OBJECT
		Q_PROPERTY(int followCount READ FollowCount NOTIFY followCountChanged)
		Q_PROPERTY(int commentCount READ CommentCount NOTIFY commentChanged)
		Q_PROPERTY(int mentionCount READ MentionCount NOTIFY mentionChanged)
		Q_PROPERTY(int privateMsgCount READ PrivateMsgCount NOTIFY privateMsgChanged)
		Q_PROPERTY(bool isNewStatus READ IsNewStatus NOTIFY newStatusChanged)

	public:
		virtual ~id_newMsgNotification();
		ID_SINGLE_INSTANCE_DEF(id_newMsgNotification)
			
			int FollowCount() const;
		int CommentCount() const;
		int MentionCount() const;
		int PrivateMsgCount() const;
		bool IsNewStatus() const;

			public Q_SLOTS:
			void reset();
		void stop();
		void start();

Q_SIGNALS:
		void newMsgCome();
		void newStatusChanged(bool IsNewStatus);
		void commentChanged(int commentCount);
		void mentionChanged(int mentionCount);
		void privateMsgChanged(int privateMsgCount);
		void followCountChanged(int followCount);

	private:
		void Notify(const QString &msg);
		void SetFollowCount(int c);
		void SetCommentCount(int c);
		void SetMentionCount(int c);
		void SetPrivateMsgCount(int c);
		void SetNewStatus(int c);
		void SetIsNewStatus(bool b);
		void Begin();
		void End();

	private:
		QThread *m_thread;
		int m_followCount;
		int m_commentCount;
		int m_mentionCount;
		int m_privateMsgCount;
		int m_newStatus;
		bool m_isNewStatus;
		bool m_notify;

		friend class idSyncUnreadThread;

		explicit id_newMsgNotification(QObject *parent = 0);
		Q_DISABLE_COPY(id_newMsgNotification)
};

#endif
