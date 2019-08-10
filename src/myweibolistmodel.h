#ifndef _KARIN_MYWEIBOLISTMODEL_H
#define _KARIN_MYWEIBOLISTMODEL_H

#include "acclistmodel_base.h"

class id_MyWeiboListModel : public id_accListModel_base
{
	Q_OBJECT
	public:
		explicit id_MyWeiboListModel(QObject *parent = 0);
		virtual ~id_MyWeiboListModel();

			public Q_SLOTS:
		void deleteItemByStatusId(const QString &statusID);
		void setUser(const QString &userId, const QString &nickName);
		void setPageNum(int pn);
		void createDBTable();
		void getMyWeiBoFromModel(int type = 0);
		QString getMyWeiBoStudusId(int index) const;
		void clearMyWeiBoModel();
	
Q_SIGNALS:
		void getUserTimelineItemResult(int errCode);

	private:
		void MyWeibo(int type);
		void UserWeibo(int type);
		void SetSinceId(const QString &id = QString());
		
	private:
		QString m_userId;
		QString m_nickName;
		QString m_containerId;
		QString m_sinceId;
};

#endif
