#include "fanlistmodel.h"

#include <QDebug>

#include "api.h"
#include "id_std.h"
#include "accountmodel.h"
#include "helper.h"

	id_FanListModel::id_FanListModel(QObject *parent)
	: idPagedQmlModel_base(parent)
{
	setObjectName("id_FanListModel");
	InitRoleMap();
}

id_FanListModel::~id_FanListModel()
{
	ID_QOBJECT_DESTROY_DBG
}

QString id_FanListModel::getFanIdbyIndex(int index) const
{
	return GetValue(index, "userId").toString();
}

QString id_FanListModel::getFanNamebyIndex(int index) const
{
	return GetValue(index, "senderName").toString();
}

void id_FanListModel::getFanInfo(int type, const QString &userId, int pageNum) // 0, 1, 
{
	Q_UNUSED(pageNum);

	if(id_accountModel::Instance()->CurrentUserId() == userId)
		GetMyFans(type);
	else
		GetUserFans(userId, type);
}

void id_FanListModel::setCursorBack()
{
	// comment it in qml
}

void id_FanListModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_FanListModel, senderName);
	ID_QMLMODEL_INSERT_ROLE(id_FanListModel, isVip);
	ID_QMLMODEL_INSERT_ROLE(id_FanListModel, blogText);
	ID_QMLMODEL_INSERT_ROLE(id_FanListModel, imageAddress);
	setRoleNames(m_roles);
}

void id_FanListModel::GetMyFans(int type)
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
	if(m_connected)
		emit getFanFinished(idAPI::ErrCode_Loading);
	params.insert("since_id", pn - 1);
	params.insert("containerid", "231016_-_selffans");
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
			if(item["title"].toString() != "全部粉丝")
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
	emit getFanFinished(idAPI::ErrCode_Success);
	return;

__Error:
	emit getFanFinished(idAPI::ErrCode_Error);
	return;
}

void id_FanListModel::GetUserFans(const QString &userId, int type)
{
#warning unimplement id_FanListModel::GetUserFans()
	Q_UNUSED(type);

	qWarning() << "[Warning]: get user fans list is unimplement: " << userId;
	idHelper::ShowBanner("不支持获取用户粉丝列表.");
	SetReflashCount(0);
	SetReflashTime();
	emit getFanFinished(idAPI::ErrCode_Success);
}
