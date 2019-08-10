#ifndef _KARIN_EMOTIONLIST_H
#define _KARIN_EMOTIONLIST_H

#include "qmlmodel_base.h"
#include "id_std.h"

class id_emotionlist : public idQmlModel_base
{
	Q_OBJECT

	public:
		virtual ~id_emotionlist();
		ID_SINGLE_INSTANCE_DEF(id_emotionlist)

			public Q_SLOTS:
			QString getPath() const;
		int getPageCount(int ps) const;
		QString getIconPath(int pn, int index, int ps) const; // pn is since 0

	protected:
		virtual void InitRoleMap(){}

	private:
		QString m_path;

	private:
		explicit id_emotionlist(QObject *parent = 0);
		void Init();
};

#endif
