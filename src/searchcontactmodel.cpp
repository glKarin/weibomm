#include "searchcontactmodel.h"

#include <QDateTime>
#include <QUrl>
#include <QDebug>

#include "database.h"
#include "api.h"

	id_searchContactModel::id_searchContactModel(QObject *parent)
: idSelectQmlModel_base(parent)
{
	setObjectName("id_searchContactModel");
	InitRoleMap();

	InitDBTable();
}

id_searchContactModel::~id_searchContactModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_searchContactModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_searchContactModel, name);
	setRoleNames(m_roles);
}

void id_searchContactModel::InitDBTable()
{
}

QString id_searchContactModel::getContactByIndex(int index) const
{
	QVariant v = GetValue(index, "name");
	if(v.isNull())
		return "无结果";
	else
		return v.toString();
}

void id_searchContactModel::searchContactFromModel(const QString &searchContact, int contactsType, const QString &defaultReturn)
{
	if(contactsType == 0)
	{
		if(!searchContact.isEmpty())
			SearchUser(searchContact);
	}
	else
	{
		if(searchContact.isEmpty())
			AllFriend();
		else
			SearchFriend(searchContact);
	}

	FillListFooter(contactsType);
}

void id_searchContactModel::selectContactItemFinished()
{
	emit selectContactItem();
}

QString id_searchContactModel::getContactIDByIndex(int index) const
{
	return GetValue(index, "user_id").toString();
}

int id_searchContactModel::getCount() const
{
	return rowCount();
}

QString id_searchContactModel::getContactGroupByIndex(int index) const
{
	return "@";
}

void id_searchContactModel::AllFriend()
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	QVariantMap data;
	int c;

	c = 0;
	removeAllItemList();
	params.insert("page", 1);
	result = idAPI::Contact(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}
	if(result["ok"].toInt())
	{
		data = result["data"].toMap();
		list = data["users"].toList();
		if(data["page"].isNull())
			qDebug() << "[Debug]: friend list is no more.";

		if(list.isEmpty())
		{
			goto __Success;
		}

		ID_CONST_FOREACH(QVariantList, list)
		{
			QVariantMap item = itor->toMap();
			QVariantMap map;
			map.insert("name", item["screen_name"].toString());

			map.insert("userId", item["id"].toString());
			Push_back(map);
			c++;
		}
		SetReflashCount(c);
		SetReflashTime();
	}
	else
	{
		goto __Error;
	}

__Success:
	return;

__Error:
	return;
}

void id_searchContactModel::SearchUser(const QString &name)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	QVariantMap data;
	int c;

	c = 0;
	removeAllItemList();
	params.insert("page", 1);
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
				map.insert("name", user["screen_name"].toString());

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
	return;

__Error:
	return;
}

void id_searchContactModel::SearchFriend(const QString &name)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	QVariantMap data;
	int c;

	c = 0;
	removeAllItemList();
	params.insert("page", 1);
	params.insert("keyword", name);
	result = idAPI::SearchContact(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}
	if(result["ok"].toInt())
	{
		data = result["data"].toMap();
		list = data["users"].toList();
		if(data["page"].isNull())
			qDebug() << "[Debug]: friend list is no more.";

		if(list.isEmpty())
		{
			goto __Success;
		}

		ID_CONST_FOREACH(QVariantList, list)
		{
			QVariantMap item = itor->toMap();
			QVariantMap map;
			map.insert("name", item["screen_name"].toString());

			map.insert("userId", item["id"].toString());
			Push_back(map);
			c++;
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
	return;

__Error:
	return;
}

void id_searchContactModel::FillListFooter()
{
	QVariantMap map;
	map.insert("user_id", QString());
	map.insert("name", "搜索网络用户或浏览我的好友");
	Push_back(map);
	SetReflashCount(m_reflashCount + 1);
}

void id_searchContactModel::FillListFooter(int type)
{
	QVariantMap map;
	map.insert("user_id", QString());
	map.insert("name", type == 0 ? "搜索网络用户" : "浏览我的好友");
	Push_back(map);
	SetReflashCount(m_reflashCount + 1);
}

ID_SINGLE_INSTANCE_DECL(id_searchContactModel)
