#include "searchusermodel.h"

#include <QDebug>
#include <QUrl>

#include "api.h"

	id_searchUserModel::id_searchUserModel(QObject *parent)
	: idPagedQmlModel_base(parent)
{
	setObjectName("id_searchUserModel");
	InitRoleMap();
}

id_searchUserModel::~id_searchUserModel()
{
	ID_QOBJECT_DESTROY_DBG
}

QString id_searchUserModel::getUserId(int index) const
{
	return GetValue(index, "userId").toString();
}

QString id_searchUserModel::getUserName(int index) const
{
	return GetValue(index, "userNickName").toString();
}

bool id_searchUserModel::getUserIsVip(int index) const
{
	return GetValue(index, "isVip").toBool();
}

QString id_searchUserModel::getUserImage(int index) const
{
	return GetValue(index, "image").toString();
}

void id_searchUserModel::searchUserFromModel(int type, const QString &name)
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
	emit searchUserResult(idAPI::ErrCode_Loading);
	params.insert("page", pn);
	params.insert("containerid", QUrl::toPercentEncoding("100103type=3&q=" + name + "&t=0"));
	params.insert("openApp", 0);
	params.insert("page_type", "searchall");
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
				map.insert("userNickName", user["screen_name"].toString());
				map.insert("image", user["profile_image_url"].toString());
				map.insert("followNum", user["followers_count"].toString());

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
	emit searchUserResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit searchUserResult(idAPI::ErrCode_Error);
	return;
}

void id_searchUserModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_searchUserModel, userNickName);
	ID_QMLMODEL_INSERT_ROLE(id_searchUserModel, isVip);
	ID_QMLMODEL_INSERT_ROLE(id_searchUserModel, followNum);
	ID_QMLMODEL_INSERT_ROLE(id_searchUserModel, image);
	setRoleNames(m_roles);
}

ID_SINGLE_INSTANCE_DECL(id_searchUserModel)
