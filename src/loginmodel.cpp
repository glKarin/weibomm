#include "loginmodel.h"

#include <QRegExp>
#include <QStringList>
#include <QUrl>
#include <QDateTime>
#include <QDebug>
#include "qjson/parser.h"

#include "networkconnector.h"
#include "networkmanager.h"
#include "crypt.h"
#include "qmlapplicationviewer.h"
#include "api.h"
#include "utility.h"
#include "accountmodel.h"
#include "weiboprofilemodel.h"

#define TEST_USERNAME ""
#define TEST_PASSWORD ""

#define ID_HTTP

#define PRELOGIN_URL "https://login.sina.com.cn/sso/prelogin.php"
#define PIN_URL "http://login.sina.com.cn/cgi/pin.php"
#define LOGIN_URL ID_HTTP "http://login.sina.com.cn/sso/login.php?client=ssologin.js(v1.4.19)"
#define PAGEREFER_URL "http://login.sina.com.cn/sso/logout.php?entry=miniblog&r=http%3A%2F%2Fweibo.com%2Flogout.php%3Fbackurl%3D%252F"
#define LOGIN_PARAMS_URL "https://www.weibo.com/ajaxlogin.php?framelogin=1&callback=parent.sinaSSOController.feedBackUrlCallBack"
#define SSOLOGIN_URL "https://i.sso.sina.com.cn/js/ssologin.js"
#define LOGIN_PARAMS_SUDAREF_URL LOGIN_PARAMS_URL "&sudaref=www.weibo.com"
#define PASSPORT_URL "http://passport.weibo.com/wbsso/login"

id_loginModel::id_loginModel(QObject *parent)
	: QObject(parent),
    m_loginName(TEST_USERNAME),
    m_loginPassword(TEST_PASSWORD),
	m_needToSave(true),
	m_timeout(60),
	m_preloginTime(0),
	m_state(id_loginModel::LoginState_Ready)
{
	setObjectName("id_loginModel");
}

id_loginModel::~id_loginModel()
{
	ID_QOBJECT_DESTROY_DBG
}

QString id_loginModel::UserID() const
{
	return m_userID;
}

void id_loginModel::SetUserID(const QString &str)
{
	if(m_userID != str)
	{
		m_userID = str;
		emit userIDChanged(m_userID);
	}
}

QString id_loginModel::LoginName() const
{
	return m_loginName;
}

void id_loginModel::SetLoginName(const QString &str)
{
	if(m_loginName != str)
	{
		m_loginName = str;
		emit loginNameChanged(m_loginName);
	}
}

QString id_loginModel::LoginPassword() const
{
	return m_loginPassword;
}

void id_loginModel::SetLoginPassword(const QString &str)
{
	if(m_loginPassword != str)
	{
		m_loginPassword = str;
		emit loginPasswordChanged(m_loginPassword);
	}
}

bool id_loginModel::NeedToSave() const
{
	return m_needToSave;
}

void id_loginModel::SetNeedToSave(bool b)
{
	if(m_needToSave != b)
	{
		m_needToSave = b;
		emit needToSaveChanged(m_needToSave);
	}
}

QString id_loginModel::ProfileImageUrl() const
{
	return m_profileImageUrl;
}

void id_loginModel::SetProfileImageUrl(const QString &str)
{
	if(m_profileImageUrl != str)
	{
		m_profileImageUrl = str;
		emit profileImageUrlChanged(m_profileImageUrl);
	}
}

QString id_loginModel::NickName() const
{
	return m_nickName;
}

void id_loginModel::SetNickName(const QString &str)
{
	if(m_nickName != str)
	{
		m_nickName = str;
		emit nickNameChanged(m_nickName);
	}
}

void id_loginModel::clearData()
{
	SetUserID("");
    SetLoginName(TEST_USERNAME);
    SetLoginPassword(TEST_PASSWORD);
	SetNeedToSave(true);
	SetProfileImageUrl("");
	SetNickName("");

	m_preloginTime = 0;
	m_preloginResult.clear();
	m_loginData.clear();
	SetData(QVariant());
	SetState(id_loginModel::LoginState_Ready);
}

void id_loginModel::SetState(idLoginState_e state)
{
	if(m_state != state)
	{
		m_state = state;
		emit loginStateChanged(m_state);
	}
}

void id_loginModel::SetData(const QVariant &data)
{
	if(m_data != data)
	{
		m_data = data;
		emit loginDataChanged(m_data);
	}
}

QVariant id_loginModel::LoginData() const
{
	return m_data;
}

int id_loginModel::LoginState() const
{
	return m_state;
}

QByteArray id_loginModel::EncodeUserName() const
{
	return QByteArray().append(m_loginName).toBase64();
}

QByteArray id_loginModel::EncryptPassword(qint64 servertime, const QString &nonce, const QString &pubkey)
{
#define __PK_E "10001" // hex
	QString secret = QString("%1\t%2\n%3").arg(servertime).arg(nonce).arg(m_loginPassword);
	return idCrypt::Encrypt(secret, pubkey, __PK_E);

#undef __PK_E
}

int id_loginModel::JSONP(QByteArray &r, const QByteArray &data)
{
	bool ok;
	QString str(data);
	QRegExp p("\\S+\\((.*)\\)");

	ok = p.exactMatch(str);
	if(p.captureCount() > 0)
	{
		r = QByteArray().append(p.capturedTexts()[1]);
		return 0;
	}
	return -1;
}

void id_loginModel::login_desktop(const QString &uname, const QString &psw, const QString &pin)
{
	extern QmlApplicationViewer *qml_viewer;
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QByteArray tmp;
	QUrl url;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QByteArray encrypted_pwd;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap headers;
	QByteArray un;

	ret = -1;
	if(!qml_viewer)
		goto __Error;

	if(m_loginName != uname || m_loginPassword != psw)
	{
		SetLoginName(uname);
		SetLoginPassword(psw);
		SetState(id_loginModel::LoginState_Ready);
	}

	emit getloginResult(-1);
	connector.SetEngine(qml_viewer->engine());
	un = EncodeUserName();
	headers.insert("Content-Type", "application/x-www-form-urlencoded");

	if(!pin.isEmpty())
		goto __Pin;
	else
		goto __Prelogin;

__Prelogin:
	querys << qMakePair<QByteArray, QByteArray>("_", QByteArray::number(QDateTime::currentMSecsSinceEpoch()))
		<< qMakePair<QByteArray, QByteArray>("callback", "sinaSSOController.preloginCallBack")
		<< qMakePair<QByteArray, QByteArray>("checkpin", QByteArray::number(1))
		<< qMakePair<QByteArray, QByteArray>("client", "ssologin.js(v1.4.19)")
		<< qMakePair<QByteArray, QByteArray>("entry", "weibo")
		<< qMakePair<QByteArray, QByteArray>("rsakt", "mod")
		<< qMakePair<QByteArray, QByteArray>("su", un);
	m_preloginTime = QDateTime::currentMSecsSinceEpoch();
	ret = connector.SyncRequest(PRELOGIN_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, QVariant(), &data);
	ID_REQ_ERR("prelogin")
	JSONP(tmp, data);
	json = parser.parse(tmp, &ok);
	ID_JSON_ERR("prelogin")
	m_preloginResult = json.toMap();

	m_preloginTime = QDateTime::currentMSecsSinceEpoch() - m_preloginTime - (m_preloginResult.contains("exectime") ? m_preloginResult["exectime"].toInt() : 0);
	encrypted_pwd = EncryptPassword(m_preloginResult["servertime"].toLongLong(), m_preloginResult["nonce"].toByteArray(), m_preloginResult["pubkey"].toByteArray());

	m_loginData.clear();
	m_loginData.insert("encoding", "UTF-8");
	m_loginData.insert("entry", "weibo");
	m_loginData.insert("from", "");
	m_loginData.insert("gateway", 1);
	m_loginData.insert("pagerefer", PAGEREFER_URL);
	m_loginData.insert("prelt", m_preloginTime);
	m_loginData.insert("pwencode", "rsa2");
	m_loginData.insert("qrcode_flag", "false");
	m_loginData.insert("returntype", "TEXT");
	m_loginData.insert("savestate", 7);
	m_loginData.insert("service", "miniblog");
	m_loginData.insert("sr", "1280*720");
	m_loginData.insert("su", un);
	m_loginData.insert("url", LOGIN_PARAMS_URL);
	m_loginData.insert("useticket", 1);
	m_loginData.insert("vsnf", 1);
	m_loginData.insert("nonce", m_preloginResult["nonce"]);
	m_loginData.insert("rsakv", m_preloginResult["rsakv"]);
	m_loginData.insert("servertime", m_preloginResult["servertime"]);
	m_loginData.insert("sp", encrypted_pwd);

	if(m_preloginResult["showpin"].toInt() == 1)
	{
		querys.clear();
		querys << qMakePair<QByteArray, QByteArray>("p", m_preloginResult["pcid"].toByteArray())
			<< qMakePair<QByteArray, QByteArray>("r", QByteArray::number(rand() % (100000 - 10000) + 10000))
			<< qMakePair<QByteArray, QByteArray>("s", "0");
		QUrl url(PIN_URL);
		url.setEncodedQueryItems(querys);
		qDebug() << "Need to input captcha" << url;

		SetData(QVariant::fromValue(url));
		SetState(id_loginModel::LoginState_Pin);
		emit getloginResult(id_loginModel::LoginState_Pin);
		goto __Exit;
	}
	else
		goto __Login;

__Pin:
	m_loginData.insert("door", pin);
	m_loginData.insert("cduit", 2);
	m_loginData.insert("pcid", m_preloginResult["pcid"]);
	m_loginData.insert("prelt", m_preloginTime);

__Login:
	ret = connector.SyncRequest(LOGIN_URL, QList<QPair<QByteArray, QByteArray> >(), idNetworkConnector::MakePostData(m_loginData), idNetworkConnector::Connect_Post, headers, &data);
	ID_REQ_ERR("login")
	json = parser.parse(data, &ok);
	ID_JSON_ERR("login")
	m_loginResult = json.toMap();

	if(m_loginResult["retcode"].toString() == "0")
	{
		ret = connector.SyncRequest(SSOLOGIN_URL, QList<QPair<QByteArray, QByteArray> >(), QByteArray(), idNetworkConnector::Connect_Get);
		querys.clear();
		querys << qMakePair<QByteArray, QByteArray>("callback", "sinaSSOController.doCrossDomainCallback")
			<< qMakePair<QByteArray, QByteArray>("client", "ssologin.js(v1.4.19)")
			<< qMakePair<QByteArray, QByteArray>("display", "0")
			<< qMakePair<QByteArray, QByteArray>("ticket", m_loginResult["ticket"].toByteArray())
			<< qMakePair<QByteArray, QByteArray>("retcode", "0")
			<< qMakePair<QByteArray, QByteArray>("ssosavestate", "7")
			<< qMakePair<QByteArray, QByteArray>("url", LOGIN_PARAMS_SUDAREF_URL);

		ret = connector.SyncRequest(PASSPORT_URL, querys, QByteArray(), idNetworkConnector::Connect_Get);
		ID_REQ_ERR("passport")
		ret = connector.SyncRequest(LOGIN_PARAMS_SUDAREF_URL, QList<QPair<QByteArray, QByteArray> >(), QByteArray(), idNetworkConnector::Connect_Get);
		ID_REQ_ERR("get_cookie")

		SetUserID(m_loginResult["uid"].toString());
		SetNickName(m_loginResult["nick"].toString());
		goto __Success;
	}
	else
	{
		SetState(id_loginModel::LoginState_Fail);
		SetData(m_loginResult["reason"]);

		querys.clear();
		querys << qMakePair<QByteArray, QByteArray>("p", m_preloginResult["pcid"].toByteArray())
			<< qMakePair<QByteArray, QByteArray>("r", QByteArray::number(rand() % (100000 - 10000) + 10000))
			<< qMakePair<QByteArray, QByteArray>("s", "0");
		QUrl url(PIN_URL);
		url.setEncodedQueryItems(querys);

		SetData(QVariant::fromValue(url));
		emit getloginResult(m_loginResult["retcode"].toInt());
		goto __Exit;
	}

__Error:
	SetData(ret);
	SetState(id_loginModel::LoginState_Fail);
	emit getloginResult(id_loginModel::LoginState_Fail);
	return;

__Success:
	SetData(m_nickName);
	SetState(id_loginModel::LoginState_Success);
	emit getloginResult(id_loginModel::LoginState_Success);
	return;

__Exit:
	return;
}

void id_loginModel::login_mobile(const QString &uname, const QString &psw)
{
	int ret;
	QVariantMap params;

	emit getloginResult(-1);
	SetLoginName(uname);
	SetLoginPassword(psw);
	SetState(id_loginModel::LoginState_Ready);

	params.insert("username", m_loginName);
	params.insert("password", m_loginPassword);
	params.insert("savestate", m_needToSave || 1 ? 1 : 0);
	m_loginData = idAPI::Login(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}

	ret = m_loginData["retcode"].toInt();
	if(ret != 20000000)
		goto __Error;
	else
	{
		SetUserID(m_loginData["data"].toMap()["uid"].toString());
		id_WeiboProfileModel profile;
		profile.getSinaWeiboProfile(m_userID);
		SetNickName(profile.Nick());
		SetProfileImageUrl(profile.UserIcon());
		goto __Success;
	}

__Error:
	SetData(ret);
	SetState(id_loginModel::LoginState_Fail);
	emit getloginResult(id_loginModel::LoginState_Fail);
	return;

__Success:
	SetData(m_userID);
	SetState(id_loginModel::LoginState_Success);
	emit getloginResult(id_loginModel::LoginState_Success);
	return;

__Exit:
	return;
}

void id_loginModel::login(const QString &uname, const QString &psw, const QString &pin)
{
	if(0)
		login_desktop(uname, psw, pin);
	else
        login_mobile(uname, psw);

    if(m_state == id_loginModel::LoginState_Success)
        id_accountModel::Instance()->UpdateAccountFromLoginModel(this);
}

void id_loginModel::Restore(const QVariantMap &data)
{
	QByteArray cookie = data["cookie"].toByteArray();
	QString name = data["login_name"].toString();
	QString psw = data["login_password"].toString();

	clearData();

	if(cookie.isEmpty())
	{
        login(name, psw);
        /*
        if(m_state == id_loginModel::LoginState_Success)
            id_accountModel::Instance()->UpdateAccountFromLoginModel(this);
            */
	}
	else
	{
		SetUserID(data["user_id"].toString());
		SetLoginName(data["login_name"].toString());
		SetLoginPassword(data["login_password"].toString());
		SetNickName(data["nick_name"].toString());
		SetProfileImageUrl(data["profile_image_url"].toString());
		idNetworkCookieJar::Instance()->SetAllCookies(QNetworkCookie::parseCookies(data["cookie"].toByteArray()));

		if(1) // update user nickname, avatar, cookie
		{
			id_WeiboProfileModel profile;
			profile.getSinaWeiboProfile(m_userID);
			if(profile.Result())
			{
				SetNickName(profile.Nick());
				SetProfileImageUrl(profile.UserIcon());
			}
		}
		SetState(id_loginModel::LoginState_Success);
		id_accountModel::Instance()->UpdateAccountFromLoginModel(this);
	}
}

ID_SINGLE_INSTANCE_DECL(id_loginModel)
