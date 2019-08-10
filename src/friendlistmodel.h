#ifndef _KARIN_FRIENDLISTMODEL_H
#define _KARIN_FRIENDLISTMODEL_H

#include "pagedqmlmodel_base.h"
#include "id_std.h"

class id_FriendListModel : public idPagedQmlModel_base
{
	Q_OBJECT
	public:
		enum idDataRole_e
		{
				Role_senderName = Qt::UserRole + 1,
				Role_isVip,
				Role_blogText,
				Role_imageAddress,
		};

	public:
		explicit id_FriendListModel(QObject *parent = 0);
		virtual ~id_FriendListModel();

			public Q_SLOTS:
		void getFriendInfo(int type, const QString &userId, int pn = 1);
		QString getFriendNamebyIndex(int index) const;
		QString getFriendIdbyIndex(int index) const;
		QString getFriendImagebyIndex(int index) const;
		bool getFriendVipbyIndex(int index) const;
	
Q_SIGNALS:
			void getFriendFinished(int errCode);

	protected:
		virtual void InitRoleMap();

	private:
		void GetMyFriends(int type = 0);
		void GetUserFriends(const QString &userId, int type = 0);
};

#endif
