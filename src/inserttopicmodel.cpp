#include "inserttopicmodel.h"

#include <QDebug>

#include "database.h"
#include "settingmodel.h"
#include "accountmodel.h"
#include "api.h"

id_insertTopicModel::id_insertTopicModel(QObject *parent)
	: idSelectQmlModel_base(parent)
{
	QVariantMap map;

	setObjectName("id_insertTopicModel");

	InitRoleMap();
	InitDBTable();
}

id_insertTopicModel::~id_insertTopicModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_insertTopicModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_insertTopicModel, name);
	ID_QMLMODEL_INSERT_ROLE(id_insertTopicModel, alphabet);
	setRoleNames(m_roles);
}

int id_insertTopicModel::getRecentTopicCount() const
{
	return rowCount();
}

void id_insertTopicModel::getRecentTopicFromModel()
{
	removeAllItemList();
	QVariantList data = id_settingModel::Instance()->loadRecentTopic(id_accountModel::Instance()->CurrentUserId());
	ID_CONST_FOREACH(QVariantList, data)
	{
		Push_back(itor->toMap());
	}
	SetReflashCount(data.size());
	SetReflashTime();
}

QString id_insertTopicModel::getTopicByIndex(int index) const
{
	return GetValue(index, "name").toString();
}

void id_insertTopicModel::selectTopicItemFinished()
{
	emit selectTopicItem();
}

void id_insertTopicModel::setRecentTopic(const QVariantList &data)
{
	removeAllItemList();
	ID_CONST_FOREACH(QVariantList, data)
	{
		Push_back(itor->toMap());
	}
	SetReflashCount(data.size());
	SetReflashTime();
}

void id_insertTopicModel::setRecentTopicToModel(const QString &topic)
{
	QVariantMap data;
	data.insert("name", topic);
	data.insert("alphabet", id::get_alphabet(topic[0]));
	Push_back(data);
}

void id_insertTopicModel::InitDBTable()
{
}

void id_insertTopicModel::FillListFooter()
{
}

ID_SINGLE_INSTANCE_DECL(id_insertTopicModel)
