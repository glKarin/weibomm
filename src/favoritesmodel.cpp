#include "favoritesmodel.h"

#include <QDebug>

#include "api.h"

	id_FavoritesModel::id_FavoritesModel(QObject *parent)
	: id_accListModel_base(parent)
{
	setObjectName("id_FavoritesModel");
}

id_FavoritesModel::~id_FavoritesModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_FavoritesModel::getMyFavoritesFromModel(int type)
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
		emit getUserTimelineItemResult(idAPI::ErrCode_Loading);
	params.insert("page", pn);
	params.insert("containerid", "230259");
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
			QVariantMap map;
			QVariantMap item = itor->toMap();
			if(id_accListModel_base::MakeModelData(map, item))
			{
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
	emit getUserTimelineItemResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getUserTimelineItemResult(idAPI::ErrCode_Error);
	return;
}

QString id_FavoritesModel::getMyFavoritesStudusId(int index) const
{
	return GetStatusId(index);
}

void id_FavoritesModel::clearMyFavorites()
{
	removeAllItemList();
}

