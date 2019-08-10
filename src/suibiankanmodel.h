#ifndef _KARIN_SUIBIANKANMODEL_H
#define _KARIN_SUIBIANKANMODEL_H

#include "acclistmodel_base.h"
#include "id_std.h"

class id_suiBianKanModel : public id_accListModel_base
{
	Q_OBJECT

	public:
		virtual ~id_suiBianKanModel();
		ID_SINGLE_INSTANCE_DEF(id_suiBianKanModel)

		public Q_SLOTS:
		void getSuiBianKanFromModel(int type = 0);
		QString getSuiBianKanStudusId(int index) const;

Q_SIGNALS:
		void getPublicTimelineItemResult(int errCode);

	private:
		explicit id_suiBianKanModel(QObject *parent = 0);
};

#endif
