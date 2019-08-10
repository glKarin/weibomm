#include "firstpagemodel.h"

#include <QDebug>

#include "api.h"

	id_firstPageModel::id_firstPageModel(QObject *parent)
	: id_accListModel_base(parent)
{
	setObjectName("id_firstPageModel");
}

id_firstPageModel::~id_firstPageModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_firstPageModel::getSinaContentFromModel(int type)
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
	emit getFriendsTimeLineResult(idAPI::ErrCode_Loading);
	params.insert("since_id", pn - 1);
	params.insert("containerid", "102803");
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
		if(page["since_id"].isNull())
			SetHasNext(false);
		else
			SetPn(page["since_id"].toInt());
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
	emit getFriendsTimeLineResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getFriendsTimeLineResult(idAPI::ErrCode_Error);
	return;
}

QString id_firstPageModel::getSinaStudusId(int index) const
{
	return GetStatusId(index);
}

void id_firstPageModel::deleteItemByStatusId(const QString &statusId)
{
	int i;
	int len;

	len = m_list.size();
	for(i = 0; i < len; i++)
	{
		if(GetStatusId(i) == statusId)
		{
			Remove(i);
			return;
		}
	}
}

ID_SINGLE_INSTANCE_DECL(id_firstPageModel)
