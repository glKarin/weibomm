#ifndef _KARIN_PAGEDQMLMODEL_BASE_H
#define _KARIN_PAGEDQMLMODEL_BASE_H

#include "qmlmodel_base.h"

class idPagedQmlModel_base : public idQmlModel_base
{
	Q_OBJECT

	public:
		virtual ~idPagedQmlModel_base();

	public Q_SLOTS:
		virtual void connectModel();
	virtual void disConnectModel();
	virtual void clearData();
	virtual bool hasData() const;

	protected:
		explicit idPagedQmlModel_base(QObject *parent = 0);
		void SetPn(int pn = 0);
		void SetHasNext(bool b);

	protected:
		int m_pn;
		bool m_hasMore;
		bool m_connected;
};

#endif
