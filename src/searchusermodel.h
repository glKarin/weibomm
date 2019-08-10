#ifndef _KARIN_SEARCHUSERMODEL_H
#define _KARIN_SEARCHUSERMODEL_H

#include "pagedqmlmodel_base.h"

#include "id_std.h"

class id_searchUserModel : public idPagedQmlModel_base
{
	Q_OBJECT
	public:
		enum idDataRole_e
		{
				Role_userNickName = Qt::UserRole + 1,
				Role_isVip,
				Role_followNum,
				Role_image,
		};

	public:
		virtual ~id_searchUserModel();
		ID_SINGLE_INSTANCE_DEF(id_searchUserModel);

			public Q_SLOTS:
		QString getUserId(int index) const;
		QString getUserName(int index) const;
		QString getUserImage(int index) const;
		bool getUserIsVip(int index) const;
		void searchUserFromModel(int type, const QString &name);
	
Q_SIGNALS:
		void searchUserResult(int errCode);

	protected:
		virtual void InitRoleMap();

	private:
		explicit id_searchUserModel(QObject *parent = 0);
};

#endif
