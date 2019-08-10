#ifndef _KARIN_CONTENTCOMMENTMODEL_H
#define _KARIN_CONTENTCOMMENTMODEL_H

#include "acclistmodel_base.h"
#include "id_std.h"

class id_contentCommentModel : public id_accListModel_base
{
	Q_OBJECT
	public:
		virtual ~id_contentCommentModel();
		ID_SINGLE_INSTANCE_DEF(id_contentCommentModel)

			public Q_SLOTS:
		void getContentCommentFromModel(const QString &statusId, int type = 0);

Q_SIGNALS:
		void getContentCommentResult(int errCode);

	protected:
		bool MakeModelData(QVariantMap &map, const QVariantMap &item);

	private:
		explicit id_contentCommentModel(QObject *parent = 0);
		void SetMaxId(const QString &max = QString());

	private:
		QString m_maxId;
};

#endif

