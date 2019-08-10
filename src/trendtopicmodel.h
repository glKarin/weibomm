#ifndef _KARIN_TRENDTOPICMODEL_H
#define _KARIN_TRENDTOPICMODEL_H

#include "pagedqmlmodel_base.h"

class id_TrendTopicModel : public idPagedQmlModel_base
{
	Q_OBJECT
	public:
		enum idDataRole_e
		{
				Role_topicName = Qt::UserRole + 1,
		};

	public:
		explicit id_TrendTopicModel(QObject *parent = 0);
		virtual ~id_TrendTopicModel();
		id_TrendTopicModel & operator<<(const QString &name);
		int TotalCount() const;

			public Q_SLOTS:
				void getSinaMyTrendTopicFromModel(int type, const QString &userId, int pn = 1);
			void deleteTableRecord(int pn);
			QString getTrendName(int index) const;
	
Q_SIGNALS:
			void getMyTrendTopicResult(int errCode);

	protected:
		virtual void InitRoleMap();

};

#endif
