#include "acclistmodel_base.h"


	idPagedQmlModel_base::idPagedQmlModel_base(QObject *parent)
: idQmlModel_base(parent),
	m_pn(1),
	m_hasMore(true),
	m_connected(false)
{
	setObjectName("idPagedQmlModel_base");
}

idPagedQmlModel_base::~idPagedQmlModel_base()
{
	//ID_QOBJECT_DESTROY_DBG
}

void idPagedQmlModel_base::SetPn(int pn)
{
	m_pn = pn < 1 ? 1 : pn;
}

void idPagedQmlModel_base::SetHasNext(bool b)
{
	m_hasMore = b;
}

void idPagedQmlModel_base::clearData()
{
	removeAllItemList();
}

bool idPagedQmlModel_base::hasData() const
{
	return rowCount() > 0;
}

void idPagedQmlModel_base::connectModel()
{
	m_connected = true;
}

void idPagedQmlModel_base::disConnectModel()
{
	m_connected = false;
}

