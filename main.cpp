#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QLocale>
#include <QTranslator>
#include <QTextCodec>
#include <QDebug>
#include "qmlapplicationviewer.h"

#include "id_std.h"
#include "utility.h"
#include "pipeline.h"
#include "networkconnector.h"
#include "networkmanager.h"
#include "qt_funcview.h"
#include "settingmodel.h"
#include "newmsgnotification.h"
#include "accountmodel.h"
#include "loginmodel.h"
#include "commenttomemodel.h"
#include "messagecentermodel.h"
#include "atmemodel.h"
#include "profile.h"
#include "microblog.h"
#include "inserttopicmodel.h"
#include "hottrendmodel.h"
#include "trendblogmodel.h"
#include "contentcommentmodel.h"
#include "weiboprofilemodel.h"
#include "database.h"
#include "firstpagemodel.h"
#include "searchblogmodel.h"
#include "searchusermodel.h"
#include "searchcontactmodel.h"
#include "searchtopicmodel.h"
#include "suibiankanmodel.h"
#include "favoritesmodel.h"
#include "fanlistmodel.h"
#include "friendlistmodel.h"
#include "trendtopicmodel.h"
#include "myweibolistmodel.h"
#include "updateprofilemodel.h"
#include "emotionlist.h"
#include "detailmodel.h"
#include "deletemodel.h"
#include "frequentcontactmodel.h"
#include "qtm/qdeclarativewebview.h"
#ifdef _KARIN_MM_EXTENSIONS
#include "qtm/qdeclarativevideo_p.h"
#endif


#define QML_MODULE_NAME "SinaWeiboTypeLib"
#define QML_MODULE_MAJOR 1
#define QML_MODULE_MINOR 0

idPipeline *pipeline = 0;

static idUtility *ut = 0;
static idNetworkConnector *connector = 0;
static id_qt_funcView *qt_funcView = 0;
static id_settingModel *settingModel = 0;
static id_newMsgNotification *newMsgNotification = 0;
static id_accountModel *accountModel = 0;
static id_loginModel *loginModel = 0;
static id_profile *profile = 0;
static id_commentToMeModel *commentToMeModel = 0;
static id_messageCenterModel *messageCenterModel = 0;
static id_atMeModel *atMeModel = 0;
static id_updateProfileModel *updateProfileModel = 0;
static id_emotionlist *emotionlist = 0;
static id_firstPageModel *firstPageModel = 0;
static id_searchBlogModel *searchBlogModel = 0;
static id_searchUserModel *searchUserModel = 0;
static id_searchContactModel *searchContactModel = 0;
static id_searchTopicModel *searchTopicModel = 0;
static id_suiBianKanModel *suiBianKanModel = 0;
static id_microBlog *microBlog = 0;
static id_insertTopicModel *insertTopicModel = 0;
static id_hotTrendModel *hotTrendModel = 0;
static id_contentCommentModel *contentCommentModel = 0;
static id_frequentContactModel *frequentContactModel = 0;
idDeclarativeNetworkAccessManagerFactory factory;

namespace id
{
	class QmlApplicationViewer;
}

QmlApplicationViewer *qml_viewer;
bool lock = false;
bool inited = false;

namespace id
{
	class QmlApplicationViewer : public ::QmlApplicationViewer
	{
		virtual void closeEvent(QCloseEvent *event)
		{
			if(false)
			{
				hide();
				event->ignore();
			}
			else
				::QmlApplicationViewer::closeEvent(event);
		}
	};

	void create_qml_viewer()
	{
		QDeclarativeEngine *engine;
		QDeclarativeContext *context;

		if(!inited)
			return;
		if(lock)
			return;
		if(qml_viewer)
			return;

		lock = true;
		qml_viewer = new id::QmlApplicationViewer;
		qml_viewer->setAttribute(Qt::WA_DeleteOnClose, true);
		engine = qml_viewer->engine();
		context = engine->rootContext();
		engine->setNetworkAccessManagerFactory(&factory);
		connector->SetEngine(engine);
		ut->SetEngine(engine);

		context->setContextProperty("_UT", ut);
		context->setContextProperty("_CONNECTOR", connector);
		context->setContextProperty("_PIPELINE", pipeline);
		context->setContextProperty("qt_funcView", qt_funcView);
		context->setContextProperty("settingModel", settingModel);
		context->setContextProperty("newMsgNotification", newMsgNotification);
		context->setContextProperty("accountModel", accountModel);
		context->setContextProperty("loginModel", loginModel);
		context->setContextProperty("profile", profile);
		context->setContextProperty("commentToMeModel", commentToMeModel);
		context->setContextProperty("messageCenterModel", messageCenterModel);
		context->setContextProperty("atMeModel", atMeModel);
		context->setContextProperty("updateProfileModel", updateProfileModel);
		context->setContextProperty("emotionlist", emotionlist);
		context->setContextProperty("firstPageModel", firstPageModel);
		context->setContextProperty("searchBlogModel", searchBlogModel);
		context->setContextProperty("searchUserModel", searchUserModel);
		context->setContextProperty("searchContactModel", searchContactModel);
		context->setContextProperty("searchTopicModel", searchTopicModel);
		context->setContextProperty("suiBianKanModel", suiBianKanModel);
		context->setContextProperty("microBlog", microBlog);
		context->setContextProperty("insertTopicModel", insertTopicModel);
		context->setContextProperty("hotTrendModel", hotTrendModel);
		context->setContextProperty("contentCommentModel", contentCommentModel);
		context->setContextProperty("frequentContactModel", frequentContactModel);

		qml_viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
		qml_viewer->setMainQmlFile(QLatin1String("qml/" ID_QML_DIR "/SinaWeiboFuncContainer.qml"));
		qml_viewer->showExpanded();
		lock = false;
	}

	idDatabase * database_instance()
	{
		static idDatabase _db;
		if(!_db.IsConnected())
			_db.Connect(ID_PKG, ID_DEV, ID_CODE);
		return &_db;
	}

}

Q_DECL_EXPORT int main(int argc, char *argv[])
{
	QApplication *a;
	const QString RegisterUncreatableTypeMsg(QString("[ERROR]: %1 -> %2").arg("Can not create a single-instance object"));

	a = createApplication(argc, argv);

	QScopedPointer<QApplication> app(a);
	a->setApplicationName(ID_PKG);
	a->setApplicationVersion(ID_VER);
	a->setOrganizationName(ID_DEV);
	QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));

	qmlRegisterType<QDeclarativeWebView>(ID_QML_URI, ID_QML_MAJOR_VER, ID_QML_MINOR_VER, ID_DEVELOPER "WebView");
	qmlRegisterType<QDeclarativeWebSettings>();
#ifdef _KARIN_MM_EXTENSIONS
	qmlRegisterType<QDeclarativeVideo>(ID_QML_URI, ID_QML_MAJOR_VER, ID_QML_MINOR_VER, ID_DEVELOPER "Video");
#endif
	qmlRegisterUncreatableType<idNetworkConnector>(ID_QML_URI, ID_QML_MAJOR_VER, ID_QML_MINOR_VER, ID_DEVELOPER "NetworkConnector", RegisterUncreatableTypeMsg.arg("idNetworkConnector"));

	// sina weibo
	qmlRegisterType<id_FavoritesModel>(QML_MODULE_NAME, QML_MODULE_MAJOR, QML_MODULE_MINOR, "FavoritesModel");
	qmlRegisterType<id_FanListModel>(QML_MODULE_NAME, QML_MODULE_MAJOR, QML_MODULE_MINOR, "FanListModel");
	qmlRegisterType<id_FriendListModel>(QML_MODULE_NAME, QML_MODULE_MAJOR, QML_MODULE_MINOR, "FriendListModel");
	qmlRegisterType<id_MyWeiboListModel>(QML_MODULE_NAME, QML_MODULE_MAJOR, QML_MODULE_MINOR, "MyWeiboListModel");
	qmlRegisterType<id_TrendTopicModel>(QML_MODULE_NAME, QML_MODULE_MAJOR, QML_MODULE_MINOR, "TrendTopicModel");
	qmlRegisterType<id_WeiboProfileModel>(QML_MODULE_NAME, QML_MODULE_MAJOR, QML_MODULE_MINOR, "WeiboProfileModel");
	qmlRegisterType<id_DetailModel>(QML_MODULE_NAME, QML_MODULE_MAJOR, QML_MODULE_MINOR, "DetailModel");
	qmlRegisterType<id_DeleteModel>(QML_MODULE_NAME, QML_MODULE_MAJOR, QML_MODULE_MINOR, "DeleteModel");
	qmlRegisterType<id_TrendBlogModel>(QML_MODULE_NAME, QML_MODULE_MAJOR, QML_MODULE_MINOR, "TrendBlogModel");

	ut = idUtility::Instance();
	connector = idNetworkConnector::Instance();
	qt_funcView = id_qt_funcView::Instance();
	settingModel = id_settingModel::Instance();
	newMsgNotification = id_newMsgNotification::Instance();
	accountModel = id_accountModel::Instance();
	loginModel = id_loginModel::Instance();
	profile = id_profile::Instance();
	commentToMeModel = id_commentToMeModel::Instance();
	messageCenterModel = id_messageCenterModel::Instance();
	atMeModel = id_atMeModel::Instance();
	updateProfileModel = id_updateProfileModel::Instance();
	emotionlist = id_emotionlist::Instance();
	firstPageModel = id_firstPageModel::Instance();
	searchBlogModel = id_searchBlogModel::Instance();
	searchUserModel = id_searchUserModel::Instance();
	searchContactModel = id_searchContactModel::Instance();
	searchTopicModel = id_searchTopicModel::Instance();
	suiBianKanModel = id_suiBianKanModel::Instance();
	microBlog = id_microBlog::Instance();
	insertTopicModel = id_insertTopicModel::Instance();
	hotTrendModel = id_hotTrendModel::Instance();
	contentCommentModel = id_contentCommentModel::Instance();
	frequentContactModel = id_frequentContactModel::Instance();
	pipeline = idPipeline::Create(qApp);

	inited = true;

	id::create_qml_viewer();

	return app->exec();
}
