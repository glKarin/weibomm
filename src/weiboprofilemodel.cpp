#include "weiboprofilemodel.h"

#include <QDebug>

#include "id_std.h"
#include "api.h"

	id_WeiboProfileModel::id_WeiboProfileModel(QObject *parent)
	: id_profile(parent),
	m_isFollowing(false),
	m_isFollowMe(false)
{
	setObjectName("id_WeiboProfileModel");
}

id_WeiboProfileModel::~id_WeiboProfileModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_WeiboProfileModel::destroyAttentionShip(const QString &userId, const QString &userName)
{
	int ret;
	QByteArray data;
	QByteArray tmp;
	QVariantMap result;
	QVariantMap params;

	//emit createOrDestroyAttention(idAPI::ErrCode_Loading);
	qDebug() << "[Debug]: Unfollow user -> " + userName;
	params.insert("uid", userId);

	result = idAPI::Unfollow(params, &ret);
	if(ret != 0)
		goto __Error;

	if(result["ok"].toInt())
	{
		SetIsFollowing(false);
		goto __Success;
	}
	else
		goto __Error;

__Success:
	emit createOrDestroyAttention(idAPI::ErrCode_Success);
	return;

__Error:
	emit createOrDestroyAttention(idAPI::ErrCode_Error);
	return;
}

void id_WeiboProfileModel::createAttentionShip(const QString &userId, const QString &userName)
{
	int ret;
	QByteArray data;
	QByteArray tmp;
	QVariantMap result;
	QVariantMap params;

	//emit createOrDestroyAttention(idAPI::ErrCode_Loading);
	qDebug() << "[Debug]: Follow user -> " + userName;
	params.insert("uid", userId);

	result = idAPI::Follow(params, &ret);
	if(ret != 0)
		goto __Error;

	if(result["ok"].toInt())
	{
		SetIsFollowing(true);
		goto __Success;
	}
	else
		goto __Error;

__Success:
	emit createOrDestroyAttention(idAPI::ErrCode_Success);
	return;

__Error:
	emit createOrDestroyAttention(idAPI::ErrCode_Error);
	return;
}

void id_WeiboProfileModel::getAttention(const QString &userId, const QString &name)
{
	int ret;
	QByteArray data;
	QByteArray tmp;
	QVariantMap result;
	QVariantMap params;

	SetUserId(userId);
	SetNick(name);

	//emit readyFinishAttention(idAPI::ErrCode_Loading);
	params.insert("uid", userId);

	result = idAPI::UserProfile(params, &ret);
	if(ret != 0)
		goto __Error;

	if(result["ok"].toInt())
	{
		result = result["data"].toMap()["user"].toMap();
		SetIsFollowing(result["following"].toBool());
		SetIsFollowMe(result["following"].toBool());
		goto __Success;
	}
	else
		goto __Error;

__Success:
	emit readyFinishAttention(idAPI::ErrCode_Success, m_isFollowing, m_isFollowMe);
	return;

__Error:
	SetIsFollowing(false);
	SetIsFollowMe(false);
	emit readyFinishAttention(idAPI::ErrCode_Error, m_isFollowing, m_isFollowMe);
	return;
}

void id_WeiboProfileModel::SetIsFollowing(bool value)
{
	if(m_isFollowing != value)
	{
		m_isFollowing = value;
		emit isFollowingChanged(m_isFollowing);
	}
}

void id_WeiboProfileModel::SetIsFollowMe(bool value)
{
	if(m_isFollowMe != value)
	{
		m_isFollowMe = value;
		emit isFollowMeChanged(m_isFollowMe);
	}
}

bool id_WeiboProfileModel::IsFollowing() const
{
	return m_isFollowing;
}

bool id_WeiboProfileModel::IsFollowMe() const
{
	return m_isFollowMe;
}
