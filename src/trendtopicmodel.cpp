#include "trendtopicmodel.h"

#include <QDateTime>
#include <QDebug>

#include "database.h"
#include "accountmodel.h"
#include "api.h"
#include "id_std.h"

#define TREND_TOPIC_TABLE_NAME "trend_topic"

namespace id
{
	extern idDatabase * database_instance();
}

	id_TrendTopicModel::id_TrendTopicModel(QObject *parent)
: idPagedQmlModel_base(parent)
{
	QVariantMap map;
	setObjectName("id_TrendTopicModel");
	InitRoleMap();

	SetTableName(TREND_TOPIC_TABLE_NAME);

	map.insert("tid", "INTEGER PRIMARY KEY AUTOINCREMENT");
	map.insert("topic_name", "TEXT NOT NULL");
	map.insert("user_id", "TEXT NOT NULL");
	map.insert("ts", "INTEGER DEFAULT 0");
	m_db->Create(m_tableName, map);
}

id_TrendTopicModel::~id_TrendTopicModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_TrendTopicModel::getSinaMyTrendTopicFromModel(int type, const QString &userId, int pageNum)
{
	Q_UNUSED(pageNum);
	const int _PageSize = 20;
	int pn;
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
		emit getMyTrendTopicResult(idAPI::ErrCode_Loading);
	idSqlResultList_t list = m_db->Table(m_tableName).AddField("topic_name").And("user_id", userId, "=", 1).AddOrder("ts", "DESC").Page(pn, _PageSize).Select();

	if(list.isEmpty())
		SetHasNext(false);
	else
		SetPn(pn);

	if(list.isEmpty())
	{
		goto __Success;
	}

	ID_CONST_FOREACH(idSqlResultList_t, list)
	{
		QVariantMap map;
		map.insert("topicName", itor->operator[]("topic_name").toString());
		Push_back(map);
		c++;
	}
	SetReflashCount(c);
	SetReflashTime();

__Success:
	emit getMyTrendTopicResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getMyTrendTopicResult(idAPI::ErrCode_Error);
	return;
}

void id_TrendTopicModel::deleteTableRecord(int pn)
{
#if 0
	int ret;
	ret = m_db->Table(m_tableName).And("topic_name", GetValue(pn, "topicName").toString(), "=", 1).And("user_id", id_accountModel::Instance()->CurrentUserId(), "=", 1).Delete();
#else
	Q_UNUSED(pn);
	qDebug() << "[Debug]: Do not remove my trend topic data table.";
#endif
}

QString id_TrendTopicModel::getTrendName(int index) const
{
	return GetValue(index, "topicName").toString();
}

void id_TrendTopicModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_TrendTopicModel, topicName);
	setRoleNames(m_roles);
}

id_TrendTopicModel & id_TrendTopicModel::operator<<(const QString &name)
{

	QVariant ret;
	QVariantMap data;
	QString userID;

	if(name.isEmpty())
		return *this;

	userID = id_accountModel::Instance()->CurrentUserId();
	idSqlResult_t res = m_db->Table(m_tableName).And("user_id", userID, "=", 1).And("topic_name", name, "=", 1).AddField("tid").One();
	data.insert("ts", QDateTime::currentMSecsSinceEpoch());
	if(res.isNull())
	{
		data.insert("topic_name", ID_SQL_QUOTE_VALUE(name));
		data.insert("user_id", ID_SQL_QUOTE_VALUE(userID));
		ret = m_db->Table(m_tableName).Insert(data);
	}
	else
	{
		ret = m_db->Table(m_tableName).And("tid", res.toInt()).Update(data);
	}
	return *this;
}

int id_TrendTopicModel::TotalCount() const
{
	return m_db->Table(m_tableName).Count();
}
