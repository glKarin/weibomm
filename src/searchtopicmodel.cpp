#include "searchtopicmodel.h"

#include <QDateTime>
#include <QUrl>
#include <QDebug>

#include "database.h"
#include "api.h"

	id_searchTopicModel::id_searchTopicModel(QObject *parent)
: idSelectQmlModel_base(parent)
{
	setObjectName("id_searchTopicModel");
	InitRoleMap();

	InitDBTable();
}

id_searchTopicModel::~id_searchTopicModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_searchTopicModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_searchTopicModel, name);
	setRoleNames(m_roles);
}

void id_searchTopicModel::InitDBTable()
{
}

int id_searchTopicModel::getCount() const
{
	return rowCount();
}

QString id_searchTopicModel::getTopicByIndex(int index) const
{
	QString name(GetValue(index, "name").toString());

	if(0)
	{
		if(!name.startsWith('#'))
			name.push_front('#');
		if(!name.endsWith('#'))
			name.push_back('#');
	}

	return name;
}

void id_searchTopicModel::selectTopicItemFinished()
{
	emit selectTopicItem();
}

void id_searchTopicModel::searchTopicFromModel(const QString &text)
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
	params.insert("containerid", QUrl::toPercentEncoding("100103type=38&q=" + text + "&t=0"));
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
				if(item["card_type"].toInt() != 8)
					continue;
				QVariantMap map;
				QString name(item["title_sub"].toString());
				if(name.startsWith('#'))
					name.remove(0, 1);
				if(name.endsWith('#'))
					name.remove(name.length() - 1, 1);
				map.insert("name", name);

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

	FillListFooter();

__Success:
	return;

__Error:
	return;
}

void id_searchTopicModel::FillListFooter()
{
	QVariantMap map;
	map.insert("name", "更多热门话题");
	Push_back(map);
	SetReflashCount(m_reflashCount + 1);
}

ID_SINGLE_INSTANCE_DECL(id_searchTopicModel)
