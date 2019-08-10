#include "trendblogmodel.h"

#include <QDebug>
#include <QUrl>

#include "api.h"
#include "id_std.h"
#include "trendtopicmodel.h"

	id_TrendBlogModel::id_TrendBlogModel(QObject *parent)
	: id_accListModel_base(parent)
{
	setObjectName("id_TrendBlogModel");
}

id_TrendBlogModel::~id_TrendBlogModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_TrendBlogModel::getSinaTrendBlogFromModel(const QString &topic, int type)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	int pn;
	QVariantMap data;
	QVariantMap page;
	QString t(topic);
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
		emit getTrendBlogResult(idAPI::ErrCode_Loading);
	if(!t.startsWith('#'))
		t.push_front('#');
	if(!t.endsWith('#'))
		t.push_back('#');

	id_TrendTopicModel() << t;
	params.insert("page", pn);
	params.insert("containerid", QUrl::toPercentEncoding("100103type=1&q=" + t));
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
				QVariantMap map;
				item = itor_2->toMap();
				if(item["card_type"].toInt() != 9)
					continue;
				if(id_accListModel_base::MakeModelData(map, item))
				{
					Push_back(map);
					c++;
				}
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
	emit getTrendBlogResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getTrendBlogResult(idAPI::ErrCode_Error);
	return;
}

QString id_TrendBlogModel::getStudusId(int index) const
{
	return GetStatusId(index);
}
