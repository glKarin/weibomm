#include "deletemodel.h"

#include <QDebug>

#include "api.h"
#include "id_std.h"

	id_DeleteModel::id_DeleteModel(QObject *parent)
: QObject(parent),
	m_connected(false)
{
	setObjectName("id_DeleteModel");
}

id_DeleteModel::~id_DeleteModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_DeleteModel::connectModel()
{
	m_connected = true;
}

void id_DeleteModel::disConnectModel()
{
	m_connected = false;
}

void id_DeleteModel::deleteStatus(const QString &statusID)
{
	int ret;
	QVariantMap result;
	QVariantMap params;

	if(m_connected)
		emit getDeleteResult(idAPI::ErrCode_Loading);
	params.insert("mid", statusID);
	result = idAPI::DelStatus(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}

	if(result["ok"].toInt())
	{
		goto __Success;
	}
	else
	{
		goto __Error;
	}

__Success:
	emit getDeleteResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getDeleteResult(idAPI::ErrCode_Error);
	return;
}
