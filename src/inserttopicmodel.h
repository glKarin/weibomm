#ifndef _KARIN_INSERTTOPICMODEL_H
#define _KARIN_INSERTTOPICMODEL_H

#include "selectqmlmodel_base.h"
#include "id_std.h"

class id_insertTopicModel : public idSelectQmlModel_base
{
	Q_OBJECT

	public:
		enum idDataRole_e
		{
			Role_name = Qt::UserRole + 1,
			Role_alphabet,
		};

	public:
		virtual ~id_insertTopicModel();
		ID_SINGLE_INSTANCE_DEF(id_insertTopicModel)

			public Q_SLOTS:
			int getRecentTopicCount() const;
		void getRecentTopicFromModel();
		QString getTopicByIndex(int index) const;
		void selectTopicItemFinished();
		void setRecentTopic(const QVariantList &topic);
		void setRecentTopicToModel(const QString &topic);

Q_SIGNALS:
		void selectTopicItem();

	protected:
		virtual void InitRoleMap();
		virtual void InitDBTable();
		virtual void FillListFooter();

	private:
		explicit id_insertTopicModel(QObject *parent = 0);
};

#endif
