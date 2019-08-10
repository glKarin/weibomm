#include "accountmodel.h"

#include <QNetworkCookieJar>
#include <QNetworkAccessManager>
#include <QDateTime>
#include <QDeclarativeEngine>
#include <QTimer>
#include <QDebug>

#include "database.h"
#include "utility.h"
#include "networkmanager.h"
#include "loginmodel.h"
#include "settingmodel.h"
#include "inserttopicmodel.h"
#include "frequentcontactmodel.h"
#include "firstpagemodel.h"
#include "api.h"
#include "api_defines.h"

id_accountModel::id_accountModel(QObject *parent)
	: idQmlModel_base(parent)
{
	QVariantMap map;

	setObjectName("id_accountModel");

	InitRoleMap();
	SetTableName("account");

	map.insert("tid", "INTEGER PRIMARY KEY AUTOINCREMENT");
	map.insert("user_id", "TEXT NOT NULL UNIQUE");
	map.insert("login_name", "TEXT NOT NULL UNIQUE");
	map.insert("login_password", "TEXT NOT NULL");
	map.insert("nick_name", "TEXT DEFAULT ''");
	map.insert("profile_image_url", "TEXT DEFAULT ''");
	map.insert("cookie", "TEXT NOT NULL DEFAULT ''");
	map.insert("ts", "INTEGER DEFAULT 0");
	m_db->Create(m_tableName, map);

	//m_currentUserId = id_settingModel::Instance()->GetSettingv<QString>("karin/current_userid");
	Init();
}

id_accountModel::~id_accountModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_accountModel::Init(bool l)
{
	getAccountList();
	if(l)
	{
		if(rowCount())
		{
			QString id = id_settingModel::Instance()->GetSettingv<QString>("karin/current_userid");
			login(id, "3");
		}
	}
}

QString id_accountModel::getAccountId(int index) const
{
	return GetValue(index, "user_id").toString();
}

void id_accountModel::login(const QString &token, const QString &secret)
{
	QString userId = token;
	int l = secret.toInt();
	bool login_first_account_if_id_not_exists = l & 1;
	bool not_emit_loginfinished_signal = l & 2;
	bool force_login_again = l & 4;
	id_loginModel *loginModel;

	if(rowCount() == 0)
		return;

	if(!userId.isEmpty() && m_currentUserId == userId && !force_login_again)
		return;
	qDebug() << QString("[Debug]: Login user 1 -> %1").arg(userId);
	if(!not_emit_loginfinished_signal)
		emit loginFinish(idAPI::ErrCode_Loading);
	loginModel = id_loginModel::Instance();
	if(!userId.isEmpty())
	{
		for(int i = 0; i < m_list.size(); i++)
		{
			const QVariantMap &itor = m_list[i];
			if(itor.value("user_id").toString() == userId)
			{
				loginModel->Restore(itor);
				if(!not_emit_loginfinished_signal)
				{
					//emit loginFinish(idAPI::ErrCode_Success);
					QTimer::singleShot(2000, this, SLOT(loginFinished_Slot()));
				}
				return;
			}
		}
	}
	if(login_first_account_if_id_not_exists)
	{
		if(!not_emit_loginfinished_signal)
			emit loginFinish(idAPI::ErrCode_Error);
		return;
	}

	QVariantMap cur;
	userId = id_settingModel::Instance()->GetSettingv<QString>("karin/current_userid");
	if(!userId.isEmpty())
	{
		cur = m_db->Table(m_tableName).And("user_id", userId, "=", 1).Row();
	}
	// login first
	if(cur.isEmpty())
		cur = Get(0);
	qDebug() << QString("[Debug]: Login user 2 -> %1: %2").arg(cur["user_id"].toString()).arg(cur["login_name"].toString());
	loginModel->Restore(cur);
	if(!not_emit_loginfinished_signal)
	{
		QTimer::singleShot(2000, this, SLOT(loginFinished_Slot()));
		//emit loginFinish(idAPI::ErrCode_Success);
	}
}

void id_accountModel::getAccountList()
{
	QList<QVariantMap> res = m_db->Table(m_tableName).Select();
	ID_FOREACH(QList<QVariantMap>, res)
	{
		itor->operator[]("userName") = itor->operator[]("nick_name");
	}
	idQmlModel_base::operator=(res);
	SetReflashCount(res.size());
	SetReflashTime();
}

void id_accountModel::deleteAccount(const QString &id)
{
	int i;
	int len;
	int ret;

	ret = m_db->Table(m_tableName).And("user_id", id, "=", 1).Delete();

	if(0) // only delete in database, qml will refresh model data
	{
		len = m_list.size();
		for(i = 0; i < len; i++)
		{
			if(m_list[i]["user_id"].toString() == id)
			{
				break;
			}
		}

		if(i < len)
			Remove(i);
	}
}

int id_accountModel::getAccountCount() const
{
	return rowCount();
}

bool id_accountModel::checkExist(const QString &account) const
{
	ID_CONST_FOREACH(idQmlModelData_t, m_list)
	{
		if((*itor)["login_name"] == account)
		{
			return true;
		}
	}
	return false;
}

void id_accountModel::addAccount(const QString &account, const QString &psw)
{
	QVariantMap map;
	QString iid;
	id_loginModel *loginModel;

	emit loginFinish_ForAddAccount(idAPI::ErrCode_Loading);
	loginModel = id_loginModel::Instance();
	map = m_db->Table(m_tableName).And("login_name", account, "=", 1).Row();
	if(map.isEmpty())
	{
		map.insert("login_name", account);
		map.insert("login_password", psw);
	}
	loginModel->Restore(map);
	if(loginModel->LoginState() == id_loginModel::LoginState_Success)
		emit loginFinish_ForAddAccount(idAPI::ErrCode_Success);
	else
		emit loginFinish_ForAddAccount(idAPI::ErrCode_Error);
}

void id_accountModel::updateAccountName(const QString &id, const QString &name)
{
	int ret;
	bool exists;

	exists = false;
	ID_FOREACH(idQmlModelData_t, m_list)
	{
		if((*itor)["user_id"] == id)
		{
			(*itor)["nick_name"] = name;
			(*itor)["userName"] = name;
			exists = true;
			break;
		}
	}

	QVariantMap map;
	map.insert("nick_name", ID_SQL_QUOTE_VALUE(name));
	ret = m_db->Table(m_tableName).And("user_id", id, "=", 1).Update(map);
	if(!exists && ret > 0)
		getAccountList();
}

void id_accountModel::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_accountModel, userName);
	setRoleNames(m_roles);
}

QString id_accountModel::getAccountToken(int index) const
{
	return GetValue(index, "user_id").toString();
}

QString id_accountModel::getAccountSecret(int index) const
{
	Q_UNUSED(index);
	return "1"; // UNUSED, m.weibo.cn using cookie
}

void id_accountModel::SetCurrentUserId(const QString &id)
{
	if(m_currentUserId != id)
	{
		m_currentUserId = id;
		id_settingModel::Instance()->SetSettingv<QString>("karin/current_userid", m_currentUserId);
		//HandleCurrentUserChanged();
		emit currentUserIdChanged(m_currentUserId);
	}
}

void id_accountModel::UpdateAccountFromLoginModel(const id_loginModel *login)
{
	QVariant ret;
	QByteArray cookies_str;
	QVariantMap map;
	QList<QNetworkCookie> cookies = idNetworkCookieJar::Instance()->cookiesForUrl(QUrl(M_HOST));
	id_loginModel *loginModel;

	loginModel = id_loginModel::Instance();
	ID_CONST_FOREACH(QList<QNetworkCookie>, cookies)
	{
		cookies_str.append(itor->toRawForm() + "\n");
	}

	map.insert("user_id", ID_SQL_QUOTE_VALUE(login->UserID()));
	map.insert("login_password", ID_SQL_QUOTE_VALUE(login->LoginPassword()));
	map.insert("nick_name", ID_SQL_QUOTE_VALUE(login->NickName()));
	map.insert("profile_image_url", ID_SQL_QUOTE_VALUE(login->ProfileImageUrl()));
	map.insert("cookie", ID_SQL_QUOTE_VALUE(cookies_str));
	map.insert("ts", QDateTime::currentMSecsSinceEpoch());

	ret = m_db->Table(m_tableName).And("login_name", login->LoginName(), "=", 1).AddField("tid").One();
	if(ret.isNull())
	{
		map.insert("login_name", ID_SQL_QUOTE_VALUE(login->LoginName()));
		ret = m_db->Table(m_tableName).Insert(map);
		if(!ret.isNull())
		{
            map.insert("userName", login->NickName());
            map.insert("tid", ret.toInt());
			Push_back(map);
		}
	}
	else
	{
		ret = m_db->Table(m_tableName).And("tid", ret.toInt()).Update(map);
		if(0)
		{
			if(ret.toInt())
			{
				for(int i = 0; i < m_list.size(); i++)
				{
					if(m_list[i]["login_name"].toString() == loginModel->LoginName())
					{
						SetValue(i, "nick_name", map["nick_name"]);
						SetValue(i, "profile_image_url", map["profile_image_url"]);
						SetValue(i, "cookie", map["cookie"]);
						SetValue(i, "ts", map["ts"]);
						break;
					}
				}
			}
		}
	}

	SetCurrentUserId(login->UserID());
	//getAccountList();
}

QString id_accountModel::CurrentUserId() const
{
	return m_currentUserId;
}

void id_accountModel::HandleCurrentUserChanged()
{
	id_insertTopicModel *insertTopicModel;
	id_frequentContactModel *frequentContactModel;
	id_firstPageModel *firstPageModel;

	insertTopicModel = id_insertTopicModel::Instance();
	frequentContactModel = id_frequentContactModel::Instance();
	firstPageModel = id_firstPageModel::Instance();

	if(m_currentUserId.isEmpty())
	{
		insertTopicModel->removeAllItemList();
		frequentContactModel->removeAllItemList();
		//firstPageModel->removeAllItemList();
	}
	else
	{
		insertTopicModel->getRecentTopicFromModel();
		frequentContactModel->getFrequentContactsFromModel();
		//firstPageModel->getSinaContentFromModel();
	}
}

void id_accountModel::loginFinished_Slot()
{
	HandleCurrentUserChanged();
	emit loginFinish(idAPI::ErrCode_Success);
}

ID_SINGLE_INSTANCE_DECL(id_accountModel)
