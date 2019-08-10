#include "friendlistmodel.h"

#include <QDebug>

#include "api.h"
#include "accountmodel.h"
#include "helper.h"

	id_FriendListModel::id_FriendListModel(QObject *parent)
	: idPagedQmlModel_base(parent)
{
	setObjectName("id_FriendListModel");
	InitRoleMap();
}

id_FriendListModel::~id_FriendListModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_FriendListModel::getFriendInfo(int type, const QString &userId, int pageNum)
{
	Q_UNUSED(pageNum);

	if(id_accountModel::Instance()->CurrentUserId() == userId)
		GetMyFriends(type);
	else
		GetUserFriends(userId, type);
}

QString id_FriendListModel::getFriendNamebyIndex(int index) const
{
	return GetValue(index, "senderName").toString();
}

QString id_FriendListModel::getFriendIdbyIndex(int index) const
{
	return GetValue(index, "userId").toString();
}

QString id_FriendListModel::getFriendImagebyIndex(int index) const
{
	return GetValue(index, "imageAddress").toString();
}

bool id_FriendListModel::getFriendVipbyIndex(int index) const
{
	return GetValue(index, "isVip").toBool();
}

void id_FriendListModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_FriendListModel, senderName);
	ID_QMLMODEL_INSERT_ROLE(id_FriendListModel, isVip);
	ID_QMLMODEL_INSERT_ROLE(id_FriendListModel, blogText);
	ID_QMLMODEL_INSERT_ROLE(id_FriendListModel, imageAddress);
	setRoleNames(m_roles);
}

void id_FriendListModel::GetMyFriends(int type)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	int pn;
	QVariantMap data;
	QVariantMap page;
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
	emit getFriendFinished(idAPI::ErrCode_Loading);
	params.insert("page", pn);
	params.insert("containerid", "231093_-_selffollowed");
	params.insert("openApp", 0);
	result = idAPI::Index(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}
	if(result["ok"].toInt())
	{
		data = result["data"].toMap();
		list = data["cards"].toList();
		page = data["cardlistInfo"].toMap();
		if(page["page"].isNull())
			SetHasNext(false);
		else
			SetPn(page["page"].toInt());
		if(list.isEmpty())
		{
			qDebug() << result["msg"].toString();
			goto __Success;
		}

		ID_CONST_FOREACH(QVariantList, list)
		{
			QVariantMap item = itor->toMap();
			if(item["card_type"].toInt() != 11)
				continue;
			QVariantList card_group = item["card_group"].toList();
			ID_CONST_FOREACH2(QVariantList, card_group, 2)
			{
				item = itor_2->toMap();
				if(item["card_type"].toInt() != 10)
					continue;
				QVariantMap map;
				QVariantMap user = item["user"].toMap();
				map.insert("isVip", user["verified"].toBool());
				map.insert("senderName", user["screen_name"].toString());
				map.insert("imageAddress", user["profile_image_url"].toString());
				map.insert("blogText", item["desc1"].toString());

				map.insert("userId", user["id"].toString());
				Push_back(map);
				c++;
			}
		}
		SetReflashCount(c);
		SetReflashTime();
	}
	else
	{
		qDebug() << result["msg"].toString();
		goto __Error;
	}

__Success:
	emit getFriendFinished(idAPI::ErrCode_Success);
	return;

__Error:
	emit getFriendFinished(idAPI::ErrCode_Error);
	return;
}

void id_FriendListModel::GetUserFriends(const QString &userId, int type)
{
#warning unimplement id_FriendListModel::GetUserFriends()
	Q_UNUSED(type);

	qWarning() << "[Warning]: get user friends list is unimplement: " << userId;
	idHelper::ShowBanner("不支持获取用户关注列表.");
	SetReflashCount(0);
	SetReflashTime();
	emit getFriendFinished(idAPI::ErrCode_Success);
}
