#ifndef _KARIN_FREQUENTCONTACTMODEL_H
#define _KARIN_FREQUENTCONTACTMODEL_H

#include "selectqmlmodel_base.h"
#include "id_std.h"

class id_frequentContactModel : public idSelectQmlModel_base
{
	Q_OBJECT

	public:
		enum idDataRole_e
		{
			Role_name = Qt::UserRole + 1,
			Role_isVip,
			Role_portrait,
		};

	public:
		virtual ~id_frequentContactModel();
		ID_SINGLE_INSTANCE_DEF(id_frequentContactModel)

		public Q_SLOTS:
			int getFrequentContactsCount() const;
		void setFrequentContactToModel(const QString &name, const QString &portrait, bool isVip, const QString &userId);
		void selectContactItemFinished();
		QString getContactByIndex(int index) const;
		QString getContactIDByIndex(int index) const;
		void getFrequentContactsFromModel();

Q_SIGNALS:
		void selectContactItem();

	protected:
		virtual void InitRoleMap();
		virtual void InitDBTable();
		virtual void FillListFooter();

	private:
		explicit id_frequentContactModel(QObject *parent = 0);
};

#endif
