#ifndef _KARIN_ACCLISTMODEL_BASE_H
#define _KARIN_ACCLISTMODEL_BASE_H

#include "pagedqmlmodel_base.h"

class id_accListModel_base : public idPagedQmlModel_base
{
	Q_OBJECT

	public:
		enum idDataRole_e
		{
			Role_userNickName = Qt::UserRole + 1,
			Role_isVip,
			Role_untilTime,
			Role_hasPic,
			Role_forwardcontent,
			Role_forwardThumbnailPic,
			Role_fromPlat,
			Role_commentCount,
			Role_forwardCount,
			Role_statusThumbnailPic,
			Role_hasMap,
			Role_image,
			Role_weibocontent,

			Role_userId,
		};

	public:
		virtual ~id_accListModel_base();

		public Q_SLOTS:
			virtual QString getImageAddress(int type, int index) const;
		virtual QString GetStatusId(int index) const;

	protected:
		virtual void InitRoleMap();
		virtual bool MakeModelData(QVariantMap &map, const QVariantMap &item);
		explicit id_accListModel_base(QObject *parent = 0);
};

#endif
