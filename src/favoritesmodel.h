#ifndef _KARIN_FAVORITESMODEL_H
#define _KARIN_FAVORITESMODEL_H

#include "acclistmodel_base.h"
#include "id_std.h"

class id_FavoritesModel : public id_accListModel_base
{
	Q_OBJECT

	public:
		explicit id_FavoritesModel(QObject *parent = 0);
		virtual ~id_FavoritesModel();

		public Q_SLOTS:
		void getMyFavoritesFromModel(int type = 0);
		QString getMyFavoritesStudusId(int index) const;
		void clearMyFavorites();

Q_SIGNALS:
		void getUserTimelineItemResult(int errCode);
};

#endif
