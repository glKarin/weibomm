#ifndef _KARIN_FIRSTPAGEMODEL_H
#define _KARIN_FIRSTPAGEMODEL_H

#include "acclistmodel_base.h"
#include "id_std.h"

class id_firstPageModel : public id_accListModel_base
{
	Q_OBJECT

	public:
		virtual ~id_firstPageModel();
		ID_SINGLE_INSTANCE_DEF(id_firstPageModel)

		public Q_SLOTS:
		void getSinaContentFromModel(int type = 0);
		QString getSinaStudusId(int index) const;
		void deleteItemByStatusId(const QString &statusId);

Q_SIGNALS:
		void getFriendsTimeLineResult(int errCode);

	private:
		explicit id_firstPageModel(QObject *parent = 0);
};

#endif
