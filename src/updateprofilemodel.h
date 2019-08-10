#ifndef _KARIN_UPDATEPROFILEMODEL_H
#define _KARIN_UPDATEPROFILEMODEL_H

#include <QObject>

#include "id_std.h"

class id_updateProfileModel : public QObject
{
	Q_OBJECT

	public:
		virtual ~id_updateProfileModel();
		ID_SINGLE_INSTANCE_DEF(id_updateProfileModel)

		public Q_SLOTS:
			void updateProfile(const QString &uname = QString(), const QString &gender = QString());
Q_SIGNALS:
		void getUpdateResult(int errCode);

	private:
		explicit id_updateProfileModel(QObject *parent = 0);
		Q_DISABLE_COPY(id_updateProfileModel)
};

#endif
