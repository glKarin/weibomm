#ifndef _KARIN_ATMEMODEL_H
#define _KARIN_ATMEMODEL_H

#include "acclistmodel_base.h"
#include "id_std.h"

class id_atMeModel : public id_accListModel_base
{
	Q_OBJECT

	public:
		virtual ~id_atMeModel();
		ID_SINGLE_INSTANCE_DEF(id_atMeModel)

			public Q_SLOTS:
			void getAtMeFromModel(int type = 0);
			QString getAtMeId(int index) const;

Q_SIGNALS:
			void getAtMeResult(int errCode);

	protected:
			bool MakeModelData(QVariantMap &map, const QVariantMap &item);

	private:
		explicit id_atMeModel(QObject *parent = 0);
};

#endif
