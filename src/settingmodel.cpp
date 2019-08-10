#include "settingmodel.h"

#include <QSettings>
#include <QDateTime>
#include <QDebug>

#include "database.h"

namespace id
{
	extern idDatabase * database_instance();
}

const QString id_settingModel::TableName = "id_recent_topic";

	id_settingModel::id_settingModel(QObject *parent)
	: QObject(parent),
	m_settings(new QSettings(this)),
	m_db(id::database_instance()),
	m_readMode(0),
	m_audioMode(true)
{
	QVariantMap map;

	setObjectName("id_settingModel");
	m_readMode = GetSettingv<int>("read_mode");
	m_audioMode = GetSettingv<bool>("audio_mode");

	map.insert("tid", "INTEGER PRIMARY KEY AUTOINCREMENT");
	map.insert("user_id", "TEXT NOT NULL");
	map.insert("name", "TEXT NOT NULL");
	map.insert("alphabet", "TEXT DEFAULT ''");
	map.insert("ts", "INTEGER DEFAULT 0");
	m_db->Create(TableName, map);
}

id_settingModel::~id_settingModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_settingModel::SetReadMode(int m)
{
	if(m_readMode != m)
	{
		saveReadMode(m);
	}
}

int id_settingModel::ReadMode() const
{
	return m_readMode;
}

bool id_settingModel::readAudioMode() const
{
	return m_audioMode;
}

void id_settingModel::saveAudioMode(bool on)
{
	if(m_audioMode != on)
	{
		m_audioMode = on;
		SetSettingv<bool>("audio_mode", m_audioMode);
	}
}

void id_settingModel::saveReadMode(int m)
{
	m_readMode = m;
	SetSettingv<int>("read_mode", m_readMode);
	emit readModeChanged(m_readMode);
}

QVariantList id_settingModel::loadRecentTopic(const QString &userID)
{
	QVariantList ret;
	QStringList order;

	order << "alphabet"
		<< "name"
		<< "ts DESC"
		;
	idSqlResultList_t list = m_db->Table(TableName).And("user_id", userID, "=", 1).Orders(order).Select();

	ID_CONST_FOREACH(idSqlResultList_t, list)
	{
		ret.push_back(*itor);
	}
	return ret;
}

void id_settingModel::SetSetting(const QString &name, const QVariant &value)
{
	m_settings->setValue(name, value);
}

QVariant id_settingModel::GetSetting(const QString &name)
{
	return m_settings->value(name);
}

void id_settingModel::saveRecentTopic(const QString &userID, const QString &topic)
{
	QVariant ret;
	QVariantMap data;

	if(topic.isEmpty())
		return;

	idSqlResult_t res = m_db->Table(TableName).And("user_id", userID, "=", 1).And("name", topic, "=", 1).AddField("tid").One();
	data.insert("ts", QDateTime::currentMSecsSinceEpoch());
	if(res.isNull())
	{
		data.insert("alphabet", ID_SQL_QUOTE_VALUE(id::get_alphabet(topic[0])));
		data.insert("name", ID_SQL_QUOTE_VALUE(topic));
		data.insert("user_id", ID_SQL_QUOTE_VALUE(userID));
		ret = m_db->Table(TableName).Insert(data);
	}
	else
	{
		ret = m_db->Table(TableName).And("tid", res.toInt()).Update(data);
	}
}

ID_SINGLE_INSTANCE_DECL(id_settingModel)
