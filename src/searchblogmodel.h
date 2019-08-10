#ifndef _KARIN_SEARCHBLOGMODEL_H
#define _KARIN_SEARCHBLOGMODEL_H

#include "acclistmodel_base.h"
#include "id_std.h"

class id_searchBlogModel : public id_accListModel_base
{
	Q_OBJECT

	public:
		virtual ~id_searchBlogModel();
		ID_SINGLE_INSTANCE_DEF(id_searchBlogModel)

		public Q_SLOTS:
		void searchBlogFromModel(int type, const QString &keyword);
		QString getStudusId(int index) const;

Q_SIGNALS:
		void searchBlogResult(int errCode);

	private:
		explicit id_searchBlogModel(QObject *parent = 0);
};
#endif
