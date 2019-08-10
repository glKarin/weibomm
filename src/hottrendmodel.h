#ifndef _KARIN_HOTTRENDMODEL_H
#define _KARIN_HOTTRENDMODEL_H

#include "pagedqmlmodel_base.h"

#include "id_std.h"

class id_hotTrendModel : public idPagedQmlModel_base
{
	Q_OBJECT
	public:
		enum idDataRole_e
		{
			Role_trendName = Qt::UserRole + 1,
		};

	public:
		virtual ~id_hotTrendModel();
		ID_SINGLE_INSTANCE_DEF(id_hotTrendModel);

		public Q_SLOTS:
		QString getTrendName(int index) const;
		void getSinaHotTrendFromModel(int type = 0);
		void selectTopicItemFinished();

Q_SIGNALS:
		void selectTopicItem();
		void getHotTrendResult(int errCode);

	protected:
		virtual void InitRoleMap();

	private:
		explicit id_hotTrendModel(QObject *parent = 0);
};

#endif
