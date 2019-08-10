#include "profile.h"

#include <QByteArray>
#include <QDebug>

#include "api.h"

	id_profile::id_profile(QObject *parent)
	: QObject(parent),
	m_topic(0),
	m_isVip(false),
	m_attention(0),
	m_weibo(0),
	m_funs(0),
	m_connected(false),
	m_result(false)
{
	setObjectName("id_Profile");
}

id_profile::~id_profile()
{
	ID_QOBJECT_DESTROY_DBG
}

int id_profile::Topic() const
{
	return m_topic;
}

bool id_profile::IsVip() const
{
	return m_isVip;
}

QString id_profile::UserIcon() const
{
	return m_userIcon;
}

QString id_profile::Nick() const
{
	return m_nick;
}

QString id_profile::Address() const
{
	return m_address;
}

QString id_profile::Account() const
{
	return m_account;
}

int id_profile::Attention() const
{
	return m_attention;
}

int id_profile::Weibo() const
{
	return m_weibo;
}

int id_profile::Funs() const
{
	return m_funs;
}

QString id_profile::Gender() const
{
	return m_gender;
}

QString id_profile::UserId() const
{
	return m_userId;
}

void id_profile::SetTopic(int value)
{
	if(m_topic != value)
	{
		m_topic = value;
		emit topicChanged(m_topic);
	}
}

void id_profile::SetUserIcon(const QString &value)
{
	if(m_userIcon != value)
	{
		m_userIcon = value;
		emit userIconChanged(m_userIcon);
	}
}

void id_profile::SetNick(const QString &value)
{
	if(m_nick != value)
	{
		m_nick = value;
		emit nickChanged(m_nick);
	}
}

void id_profile::SetAddress(const QString &value)
{
	if(m_address != value)
	{
		m_address = value;
		emit addressChanged(m_address);
	}
}

void id_profile::SetAccount(const QString &value)
{
	if(m_account != value)
	{
		m_account = value;
		emit accountChanged(m_account);
	}
}

void id_profile::SetGender(const QString &value)
{
	if(m_gender != value)
	{
		m_gender = value;
		emit genderChanged(m_gender);
	}
}

void id_profile::SetUserId(const QString &value)
{
	if(m_userId != value)
	{
		m_userId = value;
		emit userIdChanged(m_userId);
	}
}

void id_profile::SetIsVip(bool value)
{
	if(m_isVip != value)
	{
		m_isVip = value;
		emit isVipChanged(m_isVip);
	}
}

void id_profile::SetAttention(int value)
{
	if(m_attention != value)
	{
		m_attention = value;
		emit attentionChanged(m_attention);
	}
}

void id_profile::SetWeibo(int value)
{
	if(m_weibo != value)
	{
		m_weibo = value;
		emit weiboChanged(m_weibo);
	}
}

void id_profile::SetFuns(int value)
{
	if(m_funs != value)
	{
		m_funs = value;
		emit funsChanged(m_funs);
	}
}

void id_profile::connectModel()
{
	m_connected = true;
}

void id_profile::disConnectModel()
{
	m_connected = false;
}

void id_profile::initializeData()
{
	SetTopic(0);
	SetUserIcon("");
	SetAddress("");
	SetAccount("");
	SetIsVip(false);
	SetAttention(0);
	SetWeibo(0);
	SetFuns(0);
	SetUserId("");

	SetResult(false);
}

void id_profile::getSinaWeiboProfile(const QString &userId, const QString &name)
{
	int ret;
	QByteArray data;
	QByteArray tmp;
	QVariantMap result;
	QVariantMap params;

	SetUserId(userId);
	SetNick(name);

	if(m_connected)
		emit readyFinishProfile(idAPI::ErrCode_Loading);

	if(userId.isEmpty() && !name.isEmpty())
	{
		params.insert("name", name);
		result = idAPI::UserId(params, &ret);
		if(ret != 0)
			goto __Error;
		QString url = result["url"].toString();
		int slash = url.lastIndexOf("/");
		SetUserId(slash != -1 ? url.mid(slash + 1) : url);
		params.clear();
	}

	params.insert("uid", m_userId);
	result = idAPI::UserProfile(params, &ret);
	if(ret != 0)
		goto __Error;

	if(result["ok"].toInt())
	{
		result = result["data"].toMap()["user"].toMap();
		SetUserIcon(result["profile_image_url"].toString());
		SetFuns(result["followers_count"].toInt());
		SetAttention(result["follow_count"].toInt());
		SetNick(result["screen_name"].toString());
		SetGender(result["gender"].toString());
		SetAccount(result["description"].toString());
		SetWeibo(result["statuses_count"].toInt());
		SetIsVip(result["verified"].toBool());

		SetTopic(0);
		SetAddress("不支持获取地址");
		goto __Success;
	}
	else
		goto __Error;

__Success:
	SetResult(true);
	emit readyFinishProfile(idAPI::ErrCode_Success);
	return;

__Error:
	SetResult(false);
	emit readyFinishProfile(idAPI::ErrCode_Error);
	return;
}

bool id_profile::Result() const
{
	return m_result;
}

void id_profile::SetResult(bool value)
{
	if(m_result != value)
		m_result = value;
}

ID_SINGLE_INSTANCE_DECL(id_profile)
