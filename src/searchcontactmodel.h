#ifndef _KARIN_SEARCHCONTACTMODEL_H
#define _KARIN_SEARCHCONTACTMODEL_H

#include "selectqmlmodel_base.h"
#include "id_std.h"

class id_searchContactModel : public idSelectQmlModel_base
{
	Q_OBJECT

	public:
		enum idDataRole_e
		{
			Role_name = Qt::UserRole + 1,
		};

	public:
		virtual ~id_searchContactModel();
		ID_SINGLE_INSTANCE_DEF(id_searchContactModel)

		public Q_SLOTS:
		QString getContactByIndex(int index) const; // "无结果"
		void searchContactFromModel(const QString &searchContact, int contactsType, const QString &defaultReturn = "无结果"); // 0 network, 1 - friend
		void selectContactItemFinished();
		QString getContactIDByIndex(int index) const;
		int getCount() const;
		QString getContactGroupByIndex(int index) const; //"@"

Q_SIGNALS:
		void selectContactItem();

	protected:
		virtual void InitRoleMap();
		virtual void InitDBTable();
		virtual void FillListFooter();
		virtual void FillListFooter(int type);

	private:
		explicit id_searchContactModel(QObject *parent = 0);
		void AllFriend();
		void SearchUser(const QString &name);
		void SearchFriend(const QString &name);
};

#endif
