#ifndef _KARIN_QMLMODEL_BASE_H
#define _KARIN_QMLMODEL_BASE_H

#include <QAbstractListModel>
#include <QList>

#define ID_QMLMODEL_INSERT_ROLE(clazz, role) m_roles.insert(clazz::Role_##role, #role);
#define ID_TABLE_PREFIX "id"

class idDatabase;

class idQmlModel_base : public QAbstractListModel
{
	Q_OBJECT
		Q_PROPERTY(QString reflashTime READ ReflashTime NOTIFY reflashTimeChanged)
		Q_PROPERTY(int reflashCount READ ReflashCount NOTIFY reflashCountChanged)
		Q_PROPERTY(bool isReadingDB READ IsReadingDB NOTIFY isReadingDBChanged)

	public:
		virtual ~idQmlModel_base();
		virtual int rowCount(const QModelIndex &index = QModelIndex()) const;
		virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
		QString ReflashTime() const;
		int ReflashCount() const;
		void SetTableName(const QString &name);
		bool IsReadingDB() const;

		public Q_SLOTS:
		virtual void removeAllItemList();

Q_SIGNALS:
		void reflashTimeChanged(const QString &reflashTime);
		void reflashCountChanged(int reflashCount);
		void isReadingDBChanged(bool isReadingDB);

	protected:
		typedef QList<QVariantMap> idQmlModelData_t;
		void SetIsReadingDB(bool b);
		virtual void SetReflashTime(const QString &t = QString());
		virtual void SetReflashCount(int c = 0);
		virtual void InitRoleMap() = 0;
		virtual QVariant GetValue(int index, const QString &name) const;
		virtual QVariantMap Get(int index) const;
		virtual QVariant SetValue(int index, const QString &name, const QVariant &data);
		virtual idQmlModel_base & operator<<(const QVariantMap &data);
		virtual idQmlModel_base & Push_back(const QVariantMap &data);
		virtual void operator=(const idQmlModelData_t &data);
		operator idQmlModelData_t &();
		void Update();
		virtual idQmlModel_base & Remove(int start, int count = 1);

	protected:
			idDatabase *m_db;
		idQmlModelData_t m_list;
		QHash<int, QByteArray> m_roles;
		QString m_reflashTime;
		int m_reflashCount;
		QString m_tableName;
		bool m_isReadingDB;

		explicit idQmlModel_base(QObject *parent = 0);

	private:
		Q_DISABLE_COPY(idQmlModel_base)
};

#endif
