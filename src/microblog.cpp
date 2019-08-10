#include "microblog.h"

#include <QFileInfo>
#include <QDebug>
#include <QGeoPlace>
#include <QGeoCoordinate>
#include <QGeoAddress>

#include "api.h"
#include "utility.h"

QTM_USE_NAMESPACE

	id_microBlog::id_microBlog(QObject *parent)
: QObject(parent)
{
	setObjectName("id_microBlog");
}

id_microBlog::~id_microBlog()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_microBlog::reqGeoAddress(qreal latitude, qreal longitude)
{
	if(m_reply)
		    return;
	QGeoCoordinate coordinate(latitude, longitude);
	m_reply = m_engine->reverseGeocode(coordinate, 0);
	connect(m_reply, SIGNAL(finished()), this, SLOT(replyFinished_Slot()));
	emit readyFinishGeoAddress(idAPI::ErrCode_Loading);
}

void id_microBlog::handleTimeout()
{
	if(!m_reply)
		return;
	if(!m_reply->isFinished())
		m_reply->abort();
}

void id_microBlog::addLocation(qreal latitude, qreal longitude)
{
	// comment in qml, implement by Qml
	Q_UNUSED(latitude);
	Q_UNUSED(longitude);
}

QString id_microBlog::getGeoAddress()
{
	return m_address;
}

void id_microBlog::removeLocation()
{
#warning unimplement id_microBlog::removeLocation()
	qWarning() << QString("[Warning]: remove location is unimplement -> %1::%2()").arg(objectName()).arg(__func__);
	//idUtility::Instance()->ShowBanner("移除位置未实现!");
}

void id_microBlog::replyFinished_Slot()
{
	QObject * obj;
	QGeoSearchReply * reply;
	QList<QGeoPlace> places;
	QGeoAddress address;

	obj = sender();
	reply = qobject_cast < QGeoSearchReply *>(obj);
	if(reply != m_reply)
	{
		reply->deleteLater();
		return;
	}
	if(!m_reply)
		return;
	if(!m_reply->isFinished())
		goto __Exit;

	if(m_reply->error() != QGeoSearchReply::NoError)
		goto __Error;

	places = m_reply->places();
	if(places.isEmpty())
		goto __Error;

	address = places[0].address();
	m_address = address.country() + " " + address.district() + " " + address.county();
	qDebug() << m_address;

__Success:
	emit readyFinishGeoAddress(idAPI::ErrCode_Success);
	goto __Exit;

__Error:
	emit readyFinishGeoAddress(idAPI::ErrCode_Error);
	goto __Exit;

__Exit:
	m_reply->deleteLater();
	m_reply = 0;
}

void id_microBlog::sendNewMicroBlog(const QString &content, const QString &selectImageSrc)
{
	QStringList pics;
	if(!selectImageSrc.isEmpty())
		pics.push_back(selectImageSrc);
	SendNewMicroBlog(content, pics);
}

void id_microBlog::SendNewMicroBlog(const QString &content, const QStringList &pics)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QStringList pic_id;

	emit readyFinishNew(idAPI::ErrCode_Loading);
	if(!pics.isEmpty()) // upload pic
	{
		for(int i = 0; i < pics.size(); i++)
		{
			if(pics[i].isEmpty())
				continue;

			QString f(pics[i]);
			if(f.startsWith("file://"))
				f = f.mid(7);
			QFileInfo info(f);
			if(!info.exists())
			{
				qDebug() << QString("[Debug]: Upload picture is not exists -> %1(%2))").arg(i).arg(f);
				goto __Error;
			}
			QByteArray picBytes = id::file_get_contents(info.absoluteFilePath());
			params.insert("type", "json");
			params.insert("filename", info.fileName());
			params.insert("filetype", "image/" + info.suffix()); // not use completeSuffix()
			params.insert("filedata", picBytes);
			result = idAPI::UploadPic(params, &ret);
			if(ret != 0)
			{
				qDebug() << QString("[Debug]: Upload picture error -> %1(%2))").arg(i).arg(f);
				goto __Error;
			}
			pic_id.push_back(result["pic_id"].toString());
			params.clear();
		}
	}

	params.insert("content", content);
	if(!pic_id.isEmpty())
		params.insert("picId", pic_id.join(","));
	result = idAPI::UpdateStatus(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}

	if(result["ok"].toInt())
	{
		goto __Success;
	}
	else
	{
		goto __Error;
	}

__Success:
	emit readyFinishNew(idAPI::ErrCode_Success);
	return;

__Error:
	emit readyFinishNew(idAPI::ErrCode_Error);
	return;
}

void id_microBlog::sendCommentMicroBlog(const QString &statusId, const QString &content, bool checked)
{
	int ret;
	QVariantMap result;
	QVariantMap params;

	emit readyFinishComment(idAPI::ErrCode_Loading);
	params.insert("content", content);
	params.insert("mid", statusId);
	if(checked)
		params.insert("dualPost", 1);
	result = idAPI::SendCmt(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}

	if(result["ok"].toInt())
	{
		goto __Success;
	}
	else
	{
		goto __Error;
	}

__Success:
	emit readyFinishComment(idAPI::ErrCode_Success);
	return;

__Error:
	emit readyFinishComment(idAPI::ErrCode_Error);
	return;
}

void id_microBlog::sendCommentReply(const QString &commentStatusID, const QString &content, const QString &replyRetweetedId)
{
	int ret;
	QVariantMap result;
	QVariantMap params;

	emit readyFinishCommentReply(idAPI::ErrCode_Loading);
	params.insert("content", content);
	params.insert("mid", replyRetweetedId);
	params.insert("cid", commentStatusID);
	params.insert("withReply", 1);
	result = idAPI::Reply(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}

	if(result["ok"].toInt())
	{
		goto __Success;
	}
	else
	{
		goto __Error;
	}

__Success:
	emit readyFinishCommentReply(idAPI::ErrCode_Success);
	return;

__Error:
	emit readyFinishCommentReply(idAPI::ErrCode_Error);
	return;
}

void id_microBlog::sendForwordMicroBlog(const QString &content, const QString &statusId, bool checked)
{
	int ret;
	QVariantMap result;
	QVariantMap params;

	emit readyFinishForword(idAPI::ErrCode_Loading);
	params.insert("content", content);
	params.insert("mid", statusId);
	if(checked)
		params.insert("dualPost", 1);
	result = idAPI::Repost(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}

	if(result["ok"].toInt())
	{
		goto __Success;
	}
	else
	{
		goto __Error;
	}

__Success:
	emit readyFinishForword(idAPI::ErrCode_Success);
	return;

__Error:
	emit readyFinishForword(idAPI::ErrCode_Error);
	return;
}

ID_SINGLE_INSTANCE_DECL(id_microBlog)
