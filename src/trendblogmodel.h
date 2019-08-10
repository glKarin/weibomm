#ifndef _KARIN_TRENDBLOGMODELMODEL_H
#define _KARIN_TRENDBLOGMODELMODEL_H

#include "acclistmodel_base.h"

class id_TrendBlogModel : public id_accListModel_base
{
	Q_OBJECT

	public:
		explicit id_TrendBlogModel(QObject *parent = 0);
		virtual ~id_TrendBlogModel();

		public Q_SLOTS:
		void getSinaTrendBlogFromModel(const QString &topicName, int type = 0);
		QString getStudusId(int index) const;

Q_SIGNALS:
		void getTrendBlogResult(int errCode);
};

#endif
