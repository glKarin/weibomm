#ifndef _KARIN_FANLISTMODEL_H
#define _KARIN_FANLISTMODEL_H

#include "pagedqmlmodel_base.h"

class id_FanListModel : public idPagedQmlModel_base
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
		explicit id_FanListModel(QObject *parent = 0);
		virtual ~id_FanListModel();

			public Q_SLOTS:
		QString getFanIdbyIndex(int index) const;
		QString getFanNamebyIndex(int index) const;
		void getFanInfo(int type, const QString &userId, int pn = 1); // 0, 1, 2
		void setCursorBack();
	
Q_SIGNALS:
		void getFanFinished(int errCode);

	protected:
		virtual void InitRoleMap();

	private:
		void GetMyFans(int type = 0);
		void GetUserFans(const QString &userId, int type = 0);
};

#endif
