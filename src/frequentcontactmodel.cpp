#include "frequentcontactmodel.h"

#include <QDateTime>
#include <QDebug>

#include "database.h"
#include "accountmodel.h"

	id_frequentContactModel::id_frequentContactModel(QObject *parent)
: idSelectQmlModel_base(parent)
{
	setObjectName("id_frequentContactModel");
	InitRoleMap();

	InitDBTable();
}

id_frequentContactModel::~id_frequentContactModel()
{
	ID_QOBJECT_DESTROY_DBG
}

int id_frequentContactModel::getFrequentContactsCount() const
{
	return rowCount();
}

void id_frequentContactModel::setFrequentContactToModel(const QString &name, const QString &portrait, bool isVip, const QString &userId)
{
	QVariant ret;
	QVariantMap data;

	if(userId.isEmpty())
		return;

	idSqlResult_t res = m_db->Table(m_tableName).And("user_id", id_accountModel::Instance()->CurrentUserId(), "=", 1).And("contact_id", userId, "=", 1).AddField("tid").One();

	data.insert("name", ID_SQL_QUOTE_VALUE(name));
	data.insert("portrait", ID_SQL_QUOTE_VALUE(portrait));
	data.insert("isVip", isVip ? 1 : 0);
	data.insert("ts", QDateTime::currentMSecsSinceEpoch());

	if(res.isNull())
	{
		data.insert("user_id", ID_SQL_QUOTE_VALUE(id_accountModel::Instance()->CurrentUserId()));
		data.insert("contact_id", ID_SQL_QUOTE_VALUE(userId));
		ret = m_db->Table(m_tableName).Insert(data);
	}
	else
	{
		ret = m_db->Table(m_tableName).And("tid", res.toInt()).Update(data);
	}

	if(ret.toInt())
		getFrequentContactsFromModel();
	else
		qWarning() << "[Warning]: insert or replace new frequent contact error -> " << userId << name;
}

QString id_frequentContactModel::getContactByIndex(int index) const
{
	return GetValue(index, "name").toString();
}

QString id_frequentContactModel::getContactIDByIndex(int index) const
{
	return GetValue(index, "contact_id").toString();
}

void id_frequentContactModel::getFrequentContactsFromModel()
{
	removeAllItemList();
	idSqlResultList_t data = m_db->Table(m_tableName).And("user_id", id_accountModel::Instance()->CurrentUserId(), "=", 1).AddOrder("ts", "DESC").Select();
	idQmlModel_base::operator=(data);
	SetReflashCount(data.size());
	SetReflashTime();
}

void id_frequentContactModel::selectContactItemFinished()
{
	emit selectContactItem();
}

void id_frequentContactModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_frequentContactModel, name);
	ID_QMLMODEL_INSERT_ROLE(id_frequentContactModel, isVip);
	ID_QMLMODEL_INSERT_ROLE(id_frequentContactModel, portrait);
	setRoleNames(m_roles);
}

void id_frequentContactModel::InitDBTable()
{
	QVariantMap map;
	SetTableName("frequent_contact");

	map.insert("tid", "INTEGER PRIMARY KEY AUTOINCREMENT");
	map.insert("user_id", "TEXT NOT NULL");
	map.insert("name", "TEXT DEFAULT ''");
	map.insert("contact_id", "TEXT NOT NULL");
	map.insert("portrait", "TEXT DEFAULT ''");
	map.insert("isVip", "INTEGER DEFAULT 0");
	map.insert("ts", "INTEGER DEFAULT 0");
	m_db->Create(m_tableName, map);
}

void id_frequentContactModel::FillListFooter()
{
}

ID_SINGLE_INSTANCE_DECL(id_frequentContactModel)
