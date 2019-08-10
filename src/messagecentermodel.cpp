#include "messagecentermodel.h"

#include <QDebug>

#include "api.h"
#include "helper.h"

	id_messageCenterModel::id_messageCenterModel(QObject *parent)
: idPagedQmlModel_base(parent)
{
	setObjectName("id_messageCenterModel");
	InitRoleMap();
}

id_messageCenterModel::~id_messageCenterModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_messageCenterModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_messageCenterModel, imageAddress);
	ID_QMLMODEL_INSERT_ROLE(id_messageCenterModel, isVip);
	ID_QMLMODEL_INSERT_ROLE(id_messageCenterModel, senderId);
	ID_QMLMODEL_INSERT_ROLE(id_messageCenterModel, dateInfo);
	ID_QMLMODEL_INSERT_ROLE(id_messageCenterModel, shortText);
	setRoleNames(m_roles);
}

void id_messageCenterModel::deleteTheMessage(int index)
{
#warning unimplement id_messageCenterModel::deleteTheMessage()
	qWarning() << "[Warning]: delete message is unimplement: " << index;
	idHelper::ShowBanner("不支持删除消息.");
	if(0)
	{
		Remove(index);
		emit deleteMessageFinished(idAPI::ErrCode_Success);
	}
}

QString id_messageCenterModel::getSenderNamebyIndex(int index) const
{
	return GetValue(index, "senderId").toString();
}

QString id_messageCenterModel::getSenderIdbyIndex(int index) const
{
	return GetValue(index, "senderUserId").toString();
}

QString id_messageCenterModel::getSenderImagebyIndex(int index) const
{
	return GetValue(index, "imageAddress").toString();
}

bool id_messageCenterModel::getVipbyIndex(int index) const
{
	return GetValue(index, "isVip").toBool();
}

QString id_messageCenterModel::getSendTimebyIndex(int index) const
{
	return GetValue(index, "dateInfo").toString();
}

QString id_messageCenterModel::getContentbyIndex(int index)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	QString uid;

	uid = GetValue(index, "senderUserId").toString();
	params.insert("uid", uid);
	params.insert("count", 1); // only get newest in list
	params.insert("unfollowing", 0);
	result = idAPI::MessageList(params, &ret);
	if(ret != 0)
	{
		if(result["ok"].toInt())
		{
			list = result["data"].toMap()["msgs"].toList();
			if(!list.isEmpty())
			{
				QVariantMap first = list[0].toMap();
				SetValue(index, "content", first["text"].toString());
			}
		}
	}

	return GetValue(index, "content").toString();
}

void id_messageCenterModel::getMessageInfo(int type)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	int pn;
	int c;

	c = 0;
	if(type == idAPI::Type_Next)
	{
		if(!m_hasMore)
			return;
		pn = m_pn + 1;
	}
	else
	{
		removeAllItemList();
		pn = 1;
		SetHasNext(true);
	}
	emit getMessageFinished(idAPI::ErrCode_Loading);
	params.insert("page", pn);
	result = idAPI::MyMessage(params, &ret);
	if(ret != 0)
		goto __Error;
	if(result["ok"].toInt())
	{
		list = result["data"].toList();
		if(list.isEmpty())
		{
			qDebug() << result["msg"].toString();
			SetHasNext(false);
			goto __Success;
		}

		ID_CONST_FOREACH(QVariantList, list)
		{
			QVariantMap map;
			QVariantMap item = itor->toMap();
			QVariantMap user = item["user"].toMap();
			map.insert("imageAddress", user["avatar_large"].toString());
			map.insert("isVip", user["verified"].toBool());
			map.insert("senderId", user["screen_name"].toString());
			map.insert("dateInfo", item["created_at"].toString());
			map.insert("shortText", item["text"].toString());

			map.insert("senderUserId", user["id"].toString());
			map.insert("content", item["text"].toString());
			Push_back(map);
			c++;
		}
		SetPn(pn);
		SetReflashCount(c);
		SetReflashTime();
	}
	else
	{
		qDebug() << result["msg"].toString();
		goto __Error;
	}

__Success:
	emit getMessageFinished(idAPI::ErrCode_Success);
	return;

__Error:
	emit getMessageFinished(idAPI::ErrCode_Error);
	return;
}

void id_messageCenterModel::sendMessageContent(const QString &userId, const QString &content)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;

	emit sendMessageFinished(idAPI::ErrCode_Loading);
	params.insert("uid", userId);
	params.insert("content", content);
	result = idAPI::SendMsg(params, &ret);
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
	emit sendMessageFinished(idAPI::ErrCode_Success);
	return;

__Error:
	emit sendMessageFinished(idAPI::ErrCode_Error);
	return;
}

ID_SINGLE_INSTANCE_DECL(id_messageCenterModel)
