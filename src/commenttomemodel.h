#ifndef _KARIN_COMMENTTOMEMODEL_H
#define _KARIN_COMMENTTOMEMODEL_H

#include "acclistmodel_base.h"
#include "id_std.h"

class id_commentToMeModel : public id_accListModel_base
{
	Q_OBJECT

	public:
		virtual ~id_commentToMeModel();
		ID_SINGLE_INSTANCE_DEF(id_commentToMeModel)

		public Q_SLOTS:
			void deleteItemByStatusId(const QString  &statusID);
		void getSinaCommentToMeFromModel(int type = 0);
		QString getCommentOriginalId(int index) const;
		QString getCommentUserId(int index) const;
		QString getCommentId(int index) const;
		QString getCommentRetweetedId(int index) const;
		QString getCommentUserName(int index) const;

Q_SIGNALS:
		void getCommentToMeResult(int errCode);

	protected:
		virtual bool MakeModelData(QVariantMap &map, const QVariantMap &item);

	private:
		explicit id_commentToMeModel(QObject *parent = 0);
};

#endif
