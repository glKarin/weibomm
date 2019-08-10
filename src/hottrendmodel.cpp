#include "hottrendmodel.h"

#include <QDebug>

#include "api.h"

	id_hotTrendModel::id_hotTrendModel(QObject *parent)
	: idPagedQmlModel_base(parent)
{
	setObjectName("id_hotTrendModel");
	InitRoleMap();
}

id_hotTrendModel::~id_hotTrendModel()
{
	ID_QOBJECT_DESTROY_DBG
}

QString id_hotTrendModel::getTrendName(int index) const
{
	QString name = GetValue(index, "trendName").toString();

	if(1)
	{
		if(name.startsWith('#'))
			name.remove(0, 1);
		if(name.endsWith('#'))
			name.remove(name.length() - 1, 1);
	}

	return name;
}

void id_hotTrendModel::selectTopicItemFinished()
{
	emit selectTopicItem();
}

void id_hotTrendModel::getSinaHotTrendFromModel(int type)
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
	emit getHotTrendResult(idAPI::ErrCode_Loading);
	params.insert("page", pn);
	params.insert("containerid", "231583");
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
				if(item["card_type"].toInt() != 101)
					continue;
				QVariantMap map;
				QVariantMap user = item["user"].toMap();
				map.insert("trendName", item["title"].toString());
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
	emit getHotTrendResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getHotTrendResult(idAPI::ErrCode_Error);
	return;
}

void id_hotTrendModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_hotTrendModel, trendName);
	setRoleNames(m_roles);
}

ID_SINGLE_INSTANCE_DECL(id_hotTrendModel)
