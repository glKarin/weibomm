#ifndef _KARIN_SELECTQMLMODEL_BASE_H
#define _KARIN_SELECTQMLMODEL_BASE_H

#include "qmlmodel_base.h"

class idSelectQmlModel_base : public idQmlModel_base
{
	Q_OBJECT
		Q_PROPERTY(QString listHeaderText READ ListHeaderText WRITE setListHeaderText NOTIFY listHeaderTextChanged)
		Q_PROPERTY(QString listTailText READ ListTailText WRITE setListTailText NOTIFY listTailTextChanged)

	public:
		virtual ~idSelectQmlModel_base();
		QString ListHeaderText() const;
		QString ListTailText() const;

		public Q_SLOTS:
		void setListHeaderText(const QString &header);
		void setListTailText(const QString &tail);

Q_SIGNALS:
		void listHeaderTextChanged(const QString &listHeaderText);
		void listTailTextChanged(const QString &listTailText);

	protected:
		explicit idSelectQmlModel_base(QObject *parent = 0);
		virtual void InitRoleMap() = 0;
		virtual void FillListFooter() = 0;

	protected:
		QString m_listHeaderText;
		QString m_listTailText;
};

#endif
