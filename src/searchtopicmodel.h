#ifndef _KARIN_SEARCHTOPICMODEL_H
#define _KARIN_SEARCHTOPICMODEL_H

#include "selectqmlmodel_base.h"
#include "id_std.h"

class id_searchTopicModel : public idSelectQmlModel_base
{
	Q_OBJECT

	public:
		enum idDataRole_e
		{
			Role_name = Qt::UserRole + 1,
		};

	public:
		virtual ~id_searchTopicModel();
		ID_SINGLE_INSTANCE_DEF(id_searchTopicModel)

		public Q_SLOTS:
		int getCount() const;
		void searchTopicFromModel(const QString &text);
		QString getTopicByIndex(int index) const;
		void selectTopicItemFinished();

Q_SIGNALS:
		void selectTopicItem();

	protected:
		virtual void InitRoleMap();
		virtual void InitDBTable();
		virtual void FillListFooter();

	private:
		explicit id_searchTopicModel(QObject *parent = 0);
};

#endif
