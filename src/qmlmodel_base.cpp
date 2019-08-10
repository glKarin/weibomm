#include "qmlmodel_base.h"

#include <QDateTime>
#include <QDebug>

#include "database.h"

namespace id
{
	extern idDatabase * database_instance();
}

	idQmlModel_base::idQmlModel_base(QObject *parent)
: QAbstractListModel(parent),
	m_db(id::database_instance()),
	m_reflashCount(0),
	m_isReadingDB(false)
{
	setObjectName("idQmlModel_base");
}

idQmlModel_base::~idQmlModel_base()
{
	//ID_QOBJECT_DESTROY_DBG
}

int idQmlModel_base::rowCount(const QModelIndex &index) const
{
	Q_UNUSED(index)
		return m_list.size();
}

QVariant idQmlModel_base::data(const QModelIndex &index, int role) const
{
	//qDebug()<<role<<m_list[index.row()][m_roles[role]];
	if(m_roles.contains(role))
		return m_list[index.row()][m_roles[role]];
	return QVariant();
}

QString idQmlModel_base::ReflashTime() const
{
	return m_reflashTime;
}

int idQmlModel_base::ReflashCount() const
{
	return m_reflashCount;
}

void idQmlModel_base::SetReflashTime(const QString &t)
{
	QString ct;
	if(t.isEmpty())
	{
		ct = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
	}
	else
		ct = t;
	if(m_reflashTime != ct)
	{
		m_reflashTime = ct;
	}
	emit reflashTimeChanged(m_reflashTime); // emit every call
}

void idQmlModel_base::SetReflashCount(int c)
{
	if(m_reflashCount != c)
	{
		m_reflashCount = c;
	}
	emit reflashCountChanged(m_reflashCount); // emit every call
}

QVariant idQmlModel_base::GetValue(int index, const QString &name) const
{
	if(index < 0 || index >= m_list.size())
	{
		qWarning() << "[Warning]: " << objectName() << "index is over" << "(" << index << " < " << m_list.size() << ")";
		return QVariant();
	}
	const QVariantMap &m = m_list[index];
	if(m.contains(name))
	{
		//qDebug()<<name<<m[name];
		return m[name];
	}
	return QVariant();
}

QVariant idQmlModel_base::SetValue(int index, const QString &name, const QVariant &data)
{
	QVariant old;

	if(index < 0 || index >= m_list.size())
	{
		qWarning() << "[Warning]: " << objectName() << "index is over" << "(" << index << " < " << m_list.size() << ")";
		return QVariant();
	}
	QVariantMap &m = m_list[index];
	if(m.contains(name))
	{
		old = m[name];
		m[name] = data;
		return old;
	}
	return QVariant();
}

void idQmlModel_base::removeAllItemList()
{
	beginRemoveRows(QModelIndex(), 0, rowCount());
	m_list.clear();
	endRemoveRows();
}

void idQmlModel_base::SetTableName(const QString &name)
{
	m_tableName = ID_TABLE_PREFIX "_" + name;
}

idQmlModel_base & idQmlModel_base::operator<<(const QVariantMap &data)
{
	m_list.push_back(data);
	return *this;
}

idQmlModel_base & idQmlModel_base::Push_back(const QVariantMap &data)
{
	beginInsertRows(QModelIndex(), rowCount(), rowCount());
	m_list.push_back(data);
	endInsertRows();
	return *this;
}

void idQmlModel_base::operator=(const idQmlModelData_t &data)
{
	m_list = data;
	emit dataChanged(index(0), index(rowCount()));
}

idQmlModel_base::operator idQmlModelData_t &()
{
	return m_list;
}

void idQmlModel_base::SetIsReadingDB(bool b)
{
	if(m_isReadingDB != b)
	{
		m_isReadingDB = b;
		emit isReadingDBChanged(m_isReadingDB);
	}
}

void idQmlModel_base::Update()
{
	emit dataChanged(index(0), index(rowCount()));
}

bool idQmlModel_base::IsReadingDB() const
{
	return m_isReadingDB;
}

QVariantMap idQmlModel_base::Get(int index) const
{
	if(index < 0 || index >= m_list.size())
	{
		qWarning() << "[Warning]: " << objectName() << "index is over" << "(" << index << " < " << m_list.size() << ")";
		return QVariantMap();
	}
	return m_list[index];
}

idQmlModel_base & idQmlModel_base::Remove(int start, int count)
{
	beginRemoveRows(QModelIndex(), start, start + count);
	for(int i = 0; i < count; i++)
		m_list.removeAt(start + i);
	endRemoveRows();
	return *this;
}
