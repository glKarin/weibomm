#include "myweibolistmodel.h"

#include <QDebug>

#include "id_std.h"
#include "api.h"
#include "accountmodel.h"

	id_MyWeiboListModel::id_MyWeiboListModel(QObject *parent)
	: id_accListModel_base(parent)
{
	setObjectName("id_MyWeiboListModel");
}

id_MyWeiboListModel::~id_MyWeiboListModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_MyWeiboListModel::deleteItemByStatusId(const QString &statusID)
{
	int i;
	int len;
	int ret;
	QVariantMap params;
	QVariantMap result;

	params.insert("mid", statusID);
	idAPI::DelStatus(params, &ret);
	if(ret != 0 && result["ok"].toInt() == 0)
	{
		qDebug() << result["msg"].toString();
	}

	len = m_list.size();
	for(i = 0; i < len; i++)
	{
		if(GetStatusId(i) == statusID)
		{
			Remove(i);
			return;
		}
	}
}

void id_MyWeiboListModel::setUser(const QString &userId, const QString &nickName)
{
	m_userId = userId;
	m_nickName = nickName;
	m_containerId = "230413" + m_userId + "_-_WEIBO_SECOND_PROFILE_WEIBO";
	return;

	if(id_accountModel::Instance()->CurrentUserId() != m_userId)
	{
		int ret;
		QVariantMap result;
		QVariantMap params;
		QVariantList list;

		params.insert("type", "uid");
		params.insert("uid", m_userId);
		params.insert("value", m_userId);
		result = idAPI::Index(params, &ret);
		if(ret != 0)
		{
			m_containerId.clear();
			return;
		}
		if(result["ok"].toInt())
		{
			list = result["data"].toMap()["tabsInfo"].toMap()["tabs"].toList();
			ID_CONST_FOREACH(QVariantList, list)
			{
				QVariantMap item = itor->toMap();
				if(item["tabKey"].toString() == "weibo")
				{
					m_containerId = item["containerid"].toString();
					break;
				}
			}
		}
		else
		{
			m_containerId.clear();
			qDebug() << result["msg"].toString();
		}
	}
	else
	{
		m_containerId = "230413" + id_accountModel::Instance()->CurrentUserId() + "_-_WEIBO_SECOND_PROFILE_WEIBO";
	}
}

void id_MyWeiboListModel::setPageNum(int pn)
{
	SetPn(pn);
}

void id_MyWeiboListModel::createDBTable()
{
}

void id_MyWeiboListModel::getMyWeiBoFromModel(int type)
{
	if(m_containerId.isEmpty())
		return;
	MyWeibo(type);
	return;

	if(id_accountModel::Instance()->CurrentUserId() == m_userId)
		MyWeibo(type);
	else
		UserWeibo(type);
}

QString id_MyWeiboListModel::getMyWeiBoStudusId(int index) const
{
	return GetStatusId(index);
}

void id_MyWeiboListModel::clearMyWeiBoModel()
{
	removeAllItemList();
}

void id_MyWeiboListModel::MyWeibo(int type)
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
	params.insert("containerid", m_containerId);
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

void id_MyWeiboListModel::UserWeibo(int type)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	QString pn;
	QVariantMap data;
	QVariantMap page;
	int c;

	c = 0;
	if(type == idAPI::Type_Next)
	{
		if(!m_hasMore)
			return;
		pn = m_sinceId;
	}
	else
	{
		removeAllItemList();
		pn.clear();
		SetHasNext(true);
	}
	emit getUserTimelineItemResult(idAPI::ErrCode_Loading);
	params.insert("type", "uid");
	params.insert("uid", m_userId);
	params.insert("value", m_userId);
	params.insert("containerid", m_containerId);
	params.insert("openApp", 0);
	if(!pn.isEmpty())
		params.insert("since_id", pn);
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
			SetSinceId(page["since_id"].toString());
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

void id_MyWeiboListModel::SetSinceId(const QString &id)
{
	if(m_sinceId != id)
		m_sinceId = id;
}
