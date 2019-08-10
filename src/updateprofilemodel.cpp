#include "updateprofilemodel.h"

#include <QDebug>

#include "profile.h"
#include "api.h"

	id_updateProfileModel::id_updateProfileModel(QObject *parent)
	: QObject(parent)
{
	setObjectName("id_updateProfileModel");
}

id_updateProfileModel::~id_updateProfileModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_updateProfileModel::updateProfile(const QString &uname, const QString &gender)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;

	if(!gender.isEmpty())
		params.insert("gender", gender);
#warning update user nickname is umimplement.
	if(params.isEmpty())
		return;
	emit getUpdateResult(idAPI::ErrCode_Loading);
	params.insert("uid", id_profile::Instance()->UserId());
	result = idAPI::UpdateProfile(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}

	if(result["ok"].toInt())
	{
		qDebug() << result["msg"].toString();
		goto __Success;
	}
	else
	{
		goto __Error;
	}

__Success:
	emit getUpdateResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getUpdateResult(idAPI::ErrCode_Error);
	return;
}

ID_SINGLE_INSTANCE_DECL(id_updateProfileModel)
