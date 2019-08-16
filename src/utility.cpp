#include "utility.h"

#include <QApplication>
#include <QClipboard>
#include <QDeclarativeEngine>
#include <QDeclarativeItem>
#include <QDeclarativeComponent>
#include <QDeclarativeContext>
#include <QDeclarativeExpression>
#include <QDeclarativeProperty>
#include <QProcess>
#include <QDateTime>
#include <QStringList>
#include <QDebug>
#include <QDir>
#include <QRegExp>
#include <QDesktopServices>
#include <QDesktopWidget>
#ifdef _MAEMO_MEEGOTOUCH_INTERFACES_DEV
#include <maemo-meegotouch-interfaces/videosuiteinterface.h>
#else
#define VIDEO_SUITE "/usr/bin/video-suite"
#endif
#include <cmath>
#include "qjson/parser.h"

#include "qmlapplicationviewer.h"
#include "networkmanager.h"
#include "networkconnector.h"
#include "id_std.h"

extern QmlApplicationViewer *qml_viewer;

idUtility::idUtility(QObject *parent) :
	QObject(parent),
	iDev(
#ifdef _DBG
			1
#else
			0
#endif
			)
{
	setObjectName("idUtility");
}

idUtility::~idUtility()
{
	ID_QOBJECT_DESTROY_DBG
}

idUtility * idUtility::Instance()
{
	static idUtility _ut;
	return &_ut;
}

int idUtility::Dev() const
{
	return iDev;
}

void idUtility::SetDev(int d)
{
	int nd = d;
	if(nd < 0)
		nd = 0;
	if(iDev != nd)
	{
		iDev = nd;
		emit devChanged(iDev);
	}
}

void idUtility::OpenPlayer(const QString &url, int t) const
{
#ifdef _HARMATTAN
#ifdef _MAEMO_MEEGOTOUCH_INTERFACES_DEV
	VideoSuiteInterface player;
	player.play(QStringList(url));
#else
	QProcess::startDetached(VIDEO_SUITE, QStringList(url));
#endif
#elif defined(_SYMBIAN)
	QString path = QDir::tempPath();
	QDir dir(path);
	if (!dir.exists()) dir.mkpath(path);
	QString ramPath = path+"/video.ram";
	QFile file(ramPath);
	if (file.exists()) file.remove();
	if (file.open(QIODevice::ReadWrite)){
		QTextStream out(&file);
		out << url;
		file.close();
		QDesktopServices::openUrl(QUrl("file:///"+ramPath));
	}
#else
	qDebug() << "[DEBUG]: Open player -> " << url << t;
#endif
}

void idUtility::CopyToClipboard(const QString &text) const
{
	QApplication::clipboard()->setText(text);
}

void idUtility::Print_r(const QVariant &v) const
{
	qDebug() << v;
}

void idUtility::SetRequestHeaders(const QVariant &v)
{
	QNetworkAccessManager *qmanager;
	idNetworkAccessManager *manager;

	if(!oEngine)
		return;

	qmanager = oEngine->networkAccessManager();
	manager = dynamic_cast<idNetworkAccessManager *>(qmanager);

	if(!manager)
		return;

	if(v.canConvert<QVariantList>())
		manager->SetRequestHeaders(v.toList());
	else if(v.canConvert<QVariantMap>())
		manager->SetRequestHeaders(v.toMap());
}

void idUtility::SetEngine(QDeclarativeEngine *e)
{
	oEngine = e;
}

QDeclarativeEngine * idUtility::Engine()
{
	return oEngine;
}

QString idUtility::Sign(const QVariantMap &args, const QString &suffix, const QVariantMap &sysArgs) const
{
#define MAKE_QUERY(k, v) k + "=" + QUrl::toPercentEncoding(v)
	typedef QMap<QString, QString> idStringMap_t;

	QString r;
	idStringMap_t map;
	idStringMap_t map2;
	QStringList list;

	ID_CONST_FOREACH(QVariantMap, args)
	{
		map.insert(itor.key(), itor.value().toString());
	}
	ID_CONST_FOREACH(QVariantMap, sysArgs)
	{
		QString key = itor.key();
		if(map.contains(key))
			map2.insert(key, itor.value().toString());
		else
			map.insert(key, itor.value().toString());
	}
	ID_CONST_FOREACH(idStringMap_t, map)
	{
		QString key = itor.key();
		if(map2.contains(key))
		{
			list.push_back(MAKE_QUERY(key, map2[key]));
		}
		list.push_back(MAKE_QUERY(key, itor.value()));
	}
	r = list.join("&") + suffix;
	//qDebug() << r;
	return id::md5(r);
#undef MAKE_QUERY
}

QVariant idUtility::Get(const QString &name) const
{
#define ID_QT qVersion()
#define ID_WHATISPLUSPLUS "致所有诺基亚N9/50的MeeGo用户"
#define ID_THEME_MUSIC "file://" + id::adjust_path("misc/theme_music.mp3")
//#define ID_THEME_MUSIC "qrc:/theme_music.mp3"
#ifdef _DBG
#define ID_CACHE_PATH QFileInfo(".").absoluteFilePath()
#else
#define ID_CACHE_PATH QDesktopServices::storageLocation(QDesktopServices::TempLocation)
#endif
	QVariant r;

	if(name.isEmpty())
	{
		QVariantMap map;
#define ID_M_I(x) map.insert(#x, ID_##x)
		ID_M_I(PATCH);
		ID_M_I(RELEASE);
		ID_M_I(DEV);
		ID_M_I(VER);
		ID_M_I(CODE);
		ID_M_I(STATE);
		ID_M_I(EMAIL);
		ID_M_I(GITHUB);
		ID_M_I(PAN);
		ID_M_I(OPENREPOS);
		ID_M_I(PKG);
		ID_M_I(APP);
		ID_M_I(TMO);
		ID_M_I(DESC);
		ID_M_I(WHATISPLUSPLUS);
		ID_M_I(PLATFORM);
		ID_M_I(QT);
		ID_M_I(NAME);
		ID_M_I(BUID);
		ID_M_I(APPID);
		ID_M_I(CACHE_PATH);
		ID_M_I(THEME_MUSIC);
#undef _NL_M_I
		r.setValue(map);
	}
	else
	{
		QString n = name.toUpper();
#define ID_I(x) if(n == #x) { r.setValue(QString(ID_##x)); }
		ID_I(PATCH)
			else ID_I(RELEASE)
			else ID_I(DEV)
			else ID_I(VER)
			else ID_I(CODE)
			else ID_I(STATE)
			else ID_I(EMAIL)
			else ID_I(GITHUB)
			else ID_I(PAN)
			else ID_I(OPENREPOS)
			else ID_I(PKG)
			else ID_I(APP)
			else ID_I(TMO)
			else ID_I(DESC)
			else ID_I(WHATISPLUSPLUS)
			else ID_I(PLATFORM)
			else ID_I(QT)
			else ID_I(NAME)
			else ID_I(BUID)
			else ID_I(APPID)
			else ID_I(CACHE_PATH)
			else ID_I(THEME_MUSIC)
			else r.setValue(QProcessEnvironment::systemEnvironment().value(name));
#undef _NL_I
	}
	return r;
#undef ID_QT
#undef ID_WHATISPLUSPLUS
#undef ID_THEME_MUSIC
#undef ID_CACHE_PATH
}

QVariant idUtility::Changelog(const QString &version) const
{
	QVariantMap m;
	QStringList list;

	if(version.isEmpty())
	{
		list 
			<< "初始的修复版本"
			<< "在OpenRepos.net检查版本更新."
			<< "播放微博内容里的视频."
			;
	}

	// read from changelog?
	m.insert("CHANGES", list);
	m.insert("PKG_NAME", ID_PKG);
	m.insert("RELEASE", ID_RELEASE);
	m.insert("DEVELOPER", ID_DEV);
	m.insert("EMAIL", ID_EMAIL);
	m.insert("URGENCY", QVariant());
	m.insert("STATE", ID_STATE);
	m.insert("VERSION", ID_VER);

	return QVariant::fromValue<QVariantMap>(m);
}

QString idUtility::Uncompress(const QString &src, int windowbits) const
{
	QByteArray b;

	if(id::iduncompress(&b, QByteArray::fromBase64(QByteArray().append(src)), windowbits) == 0)
		return b;
	return QString();
}

QVariant idUtility::XML_Parse(const QString &xml) const
{
	return id::qvariant_from_xml(xml);
}

QString idUtility::FormatUrl(const QString &u) const
{
	int dot, slash;
	QUrl url(u);

	if(url.isValid())
	{
		if(url.scheme().isEmpty())
		{
			if(url.isRelative())
			{
				if(u.at(0) == '.')
					return QString("file://") + QDir::cleanPath(QCoreApplication::applicationDirPath() + "/" + u);
				else if(u.at(0) == '/')
					return QString("file://") + u;
				else
				{
					dot = u.indexOf('.');
					slash = u.indexOf('/');
					if(dot != -1 || slash != -1)
					{
						if(slash == -1 || dot < slash - 1)
							return QString("http://") + u;
					}
					else if(u.indexOf("localhost") == 0)
						return QString("http://") + u;
				}
			}
			else
				return QString("http://") + u;
		}
		else
			return url.toString();
	}
	return QString();
}

qint64 idUtility::System(const QString &path, const QVariant &args, bool async) const
{
	qint64 pid;
	QStringList list;

	list = args.toStringList();

	if(async)
	{
		if(QProcess::startDetached(path, list, QString(), &pid))
			return pid;
		return -1;
	}
	else
		return QProcess::execute(path, list);
}

QVariant idUtility::ParseUrl(const QString &url, const QString &part) const
{
	typedef QPair<QString, QString> idStringPair_t;
	QUrl u(url);
	QString p = part.toUpper();

	if(u.isEmpty())
		return QVariant();

	if(p == "HOST")
		return u.host();
	else if(p == "PORT")
		return u.port();
	else if(p == "SCHEME")
		return u.scheme();
	else if(p == "PATH")
		return u.path();
	else if(p == "PARAMS")
	{
		QVariantMap r;
		QList<QPair<QString, QString> > querys = u.queryItems();
		ID_CONST_FOREACH(QList<idStringPair_t>, querys)
		{
			r.insert(itor->first, itor->second);
		}
		return r;
	}
	else if(p == "PARAM")
	{
		QStringList r;
		QList<QPair<QString, QString> > querys = u.queryItems();
		ID_CONST_FOREACH(QList<idStringPair_t>, querys)
		{
			r.push_back(itor->first + "=" + itor->second);
		}
		return r.join("&");
	}
	else
	{
		QVariantMap m;
		m.insert("HOST", u.host());
		m.insert("PORT", u.port());
		m.insert("SCHEME", u.scheme());
		m.insert("PATH", u.path());
		{
			QVariantMap r;
			QList<QPair<QString, QString> > querys = u.queryItems();
			ID_CONST_FOREACH(QList<idStringPair_t>, querys)
			{
				r.insert(itor->first, itor->second);
			}
			m.insert("PARAMS", r);
		}
		return m;
	}
}

QVariant idUtility::GetCookie(const QString &url, const QString &name) const
{
	QVariant r;
	QList<QNetworkCookie> cookies = idNetworkCookieJar::Instance()->cookiesForUrl(QUrl(url));
	if(cookies.count() > 0)
	{
		QVariantMap m;
		ID_CONST_FOREACH(QList<QNetworkCookie>, cookies)
		{
			 //qDebug() << itor->name() << itor->value() <<name;
			if(name.isEmpty())
				m.insert(itor->name(), itor->value());
			else
			{
				if(itor->name() == name)
				{
					r.setValue(itor->value());
					goto __Exit;
				}
			}
		}
		r.setValue(m);
	}

__Exit:
	return r;
}

QString idUtility::CacheFile(const QString &b64, const QString &name) const
{
	QString file(name.isEmpty() ? QString::number(QDateTime::currentMSecsSinceEpoch()) : name);
	QByteArray data = QByteArray::fromBase64(QByteArray().append(b64));
	QString cachePath = Get("CACHE_PATH").toString();
	file = cachePath + "/" + file;
	if(id::file_put_contents(file, data))
		return file;
	else
		return "";
}

void idUtility::SetRequestHeader(const QString &k, const QString &v)
{
	QNetworkAccessManager *qmanager;
	idNetworkAccessManager *manager;

	if(!oEngine)
		return;

	qmanager = oEngine->networkAccessManager();
	manager = dynamic_cast<idNetworkAccessManager *>(qmanager);

	if(!manager)
		return;

	manager->SetRequestHeader(k, v);
}

QObject * idUtility::PlayThemeMusic(QObject *p)
{
	if(!oEngine)
		return 0;

	QObject *obj;
	QDeclarativeItem *pitem;

	pitem = qobject_cast<QDeclarativeItem *>(p);
	if(!pitem)
		return 0;

	obj = CreateQmlObject(QString(
				"import QtQuick 1.1;"
				"import QtMultimediaKit 1.1;"
				"Audio{"
				"id: audio;"
				"property bool looping: true;"
				"property bool autoPlay: true;"
				"signal newloop();"
				"source: '%1';"
				"onStatusChanged: {"
				"if(looping) { if(audio.status === Audio.EndOfMedia) { audio.position = 0; audio.play(); audio.newloop(); } }"
				"}"
				"onSourceChanged: {"
				"if(autoPlay) { if(source != '') play(); }"
				"}"
				"onError: { console.log('[Error]: Audio error ' + error + ' -> ' + errorString); }"
				"Component.onDestruction: {"
				"stop();"
				"console.log('[Debug]: Qml -> ThemeMusicAudio is destroyed.');"
				"}"
				"}"
				)
				.arg(Get("THEME_MUSIC").toString())
				, p);

	return obj;
}

QObject * idUtility::ShowWhatIsPlusPlus(QObject *p)
{
	if(!oEngine)
		return 0;

	int len, w, h, y;
	QObject *obj;
	QDeclarativeItem *pitem;
	QString text = Get("WHATISPLUSPLUS").toString();

	pitem = qobject_cast<QDeclarativeItem *>(p);
	if(!pitem)
		return 0;

	QSize size = ScreenSize();
	w = size.width();
	h = size.height();
	len = int(sqrt(w * w + h * h));
	y = ((QDateTime::currentMSecsSinceEpoch() ^ qrand()) ^ 2014) % (qMin(w, h) / 3);
	obj = CreateQmlObject(QString(
				"import QtQuick 1.1;"
				"Text{"
				"id: egg;"
				"property int startPos: %2;"
				"x: startPos;"
				"y: %3;"
				"z: 1;"
				"text: \"%1\";"
				"color: '#9E1B29';"
				"font.pixelSize: 24;"
				"font.bold: true;"
				"transform: Rotation {"
				"id: egg_rotation;"
				"origin: Qt.vector3d(egg.width / 2, egg.height / 2, 0);"
				"axis: Qt.vector3d(1, 0, 0);"
				"angle: 0;"
				"}"
				"SequentialAnimation{"
				"id: egg_anim;"
				"property int _startDuration: 6000;"
				"property int _pauseDuration: 12000;"
				"property int _endDuration: 6000;"

				"ParallelAnimation{"
				"RotationAnimation{"
				"target: egg_rotation;"
				"property: 'angle';"
				"direction: RotationAnimation.Counterclockwise;"
				"duration: egg_anim._startDuration;"
				"from: 360;"
				"to: 0;"
				"}"
				"NumberAnimation{"
				"target: egg;"
				"property: 'x';"
				"from: egg.startPos;"
				"to: 0;"
				"duration: egg_anim._startDuration;"
				"}"
				"}"

				"PauseAnimation{"
				"duration: egg_anim._pauseDuration;"
				"}"

				"ParallelAnimation{"
				"RotationAnimation{"
				"target: egg_rotation;"
				"property: 'angle';"
				"direction: RotationAnimation.Counterclockwise;"
				"duration: egg_anim._endDuration;"
				"from: 0;"
				"to: -360;"
				"}"
				"NumberAnimation{"
				"target: egg;"
				"property: 'x';"
				"from: 0;"
				"to: -egg.width;"
				"duration: egg_anim._endDuration;"
				"}"
				"}"
				"onCompleted: {"
				"egg.destroy();"
				"}"
				"}"
				"Component.onDestruction: {"
				"console.log('[Debug]: Qml -> WhatIsPlusPlusBanner is destroyed.');"
				"}"
				"Component.onCompleted: {"
				"egg_anim.start();"
				"}"
				"}"
				)
				.arg(text)
				.arg(len)
				.arg(y)
				, p);

	return obj;
}

QObject * idUtility::RenderPatchInfo(QObject *p)
{
	if(!oEngine)
		return 0;

	QObject *obj;
	QDeclarativeItem *pitem;
	QStringList pan = Get("PAN").toString().split(" ");
	QString github = Get("GITHUB").toString();
	QString openrepos = Get("OPENREPOS").toString();
	QString email = Get("EMAIL").toString();
	QStringList texts;

	pitem = qobject_cast<QDeclarativeItem *>(p);
	if(!pitem)
		return 0;

	texts << Get("NAME").toString()
		<< "Dev: <a href='mailto:" + email + "'>" + Get("DEV").toString() + "</a>"
		<< "版本: " + Get("VER").toString()
		<< "发布: " + Get("RELEASE").toString()
		<< Get("DESC").toString()
		<< "下载: <a href='" + openrepos + "'>OpenRepos.net</a>&nbsp;"
		+ "<a href='" + pan[0] + "'>百度网盘(提取码" + pan[1] + ")</a>"
		<< "源码: <a href='" + github + "'>Github</a>"
		;

	obj = CreateQmlObject(QString(
				"import QtQuick 1.1;"
				"Text{"
				"anchors.fill: parent;"
				"z: 1;"
				"clip: true;"
				//"horizontalAlignment: Text.AlignRight;"
				"verticalAlignment: Text.AlignBottom;"
				"text: \"%1\";"
				"color: '#9E1B29';"
				"font.pixelSize: 24;"
				"elide: Text.ElideRight;"
				"wrapMode: Text.WrapAnywhere;"
				"textFormat: Text.RichText;"
				"onLinkActivated: {"
				"Qt.openUrlExternally(link);"
				"}"
				"Component.onDestruction: {"
				"console.log('[Debug]: Qml -> PatchInfoText is destroyed.');"
				"}"
				"\n"
				"function _HandleMouseClick(x, y){"
				"var Links = ["
				"{x: 55, y: 275, w: 55, h: 30, u: 'mailto:%2'},"
				"{x: 60, y: 115, w: 165, h: 30, u: '%3'},"
				"{x: 235, y: 115, w: 225, h: 30, u: '%4'},"
				"{x: 60, y: 85, w: 75, h: 30, u: '%5'},"
				"];"
				"for(var i in Links) { var link = Links[i]; /*console.log(x, y, link.x, link.y, link.w, link.h, link.u);*/ if((x >= link.x && x <= link.x + link.w) && (y >= link.y && y <= link.y + link.h)) { Qt.openUrlExternally(link.u); return; } }"
				"}"
				"}"
				)
				.arg(texts.join("<br/>"))
				.arg(email).arg(openrepos).arg(pan[0]).arg(github)
				, p);

	return obj;
}

QObject * idUtility::RenderWaterWare(QObject *p, QObject *item)
{
	if(!oEngine)
		return 0;

	QObject *obj;
	QDeclarativeItem *pitem;

	pitem = qobject_cast<QDeclarativeItem *>(p);
	if(!pitem)
		return 0;

	QVariantMap props;
	props.insert("item", qVariantFromValue(item ? item : p));
	obj = CreateQmlObject(QString(
				"import QtQuick 1.1;"
				"import Qt.labs.shaders 1.0;"
				"ShaderEffectItem{"
				"id: gl;"
				"property bool mouse: true;"
				"property Item item;"
				"property real waveFactory: 0.02;"
				"property variant center: width > height ? Qt.point(item.width / 2, item.height / 2) : Qt.point(item.height / 2, item.width / 2);"
				"property real waveRollSpeed: 0.2;"
				"property color waterColor: 'lightskyblue';"
				"property real radiusLimit: Math.sqrt(Math.pow(item.width, 2) + Math.pow(item.height, 2));"
				"property real waveSpeed: 10;"
				"property real waveWidth: 80;"
				"property real waterIdentity: 0.1;"
				"property int interval: 120;"
				"property variant texture0: ShaderEffectSource{ sourceItem: item; hideSource: gl.enabled; }"
				"property real radius: 0;"
				"property real placeRadius: 0;"
				"property real offset: 0.0;"
				"signal clicked(int x, int y);"
				"anchors.fill: gl.item;"
				"objectName: 'karinWaterWaveShader';"
				"enabled: Qt.application.active;"
				"visible: enabled;"
				//"vertexShader: '';"
				"fragmentShader: '"
				"#define M_PI 3.141592653589793"
				"\n"
				"precision mediump float;"
				"varying vec2 qt_TexCoord0;"
				"uniform sampler2D texture0;"
				"uniform float waveFactory;"
				"uniform vec2 center;"
				"uniform float radius;"
				"uniform float placeRadius;"
				"uniform float offset;"
				"uniform vec4 waterColor;"
				"uniform float waterIdentity;"
				"uniform float waveWidth;"
				"vec2 dir;"
				"float len;"
				"\n"
				"bool inEffect() { return(len < radius && len > placeRadius); }"
				"\n"
				"float effect() { float c = len / waveWidth; float per = sin(offset * M_PI + c * M_PI); return per / 2.0 + 0.5; }"
				"\n"
				"vec2 effectCoord(float per) { vec2 nor = normalize(dir); nor *= waveFactory * per; return clamp(qt_TexCoord0 + nor, 0.0, 1.0); }"
				"\n"
				"void main(){"
				"vec4 color = vec4(0.0); dir = gl_FragCoord.xy - center; len = sqrt(pow(dir.x, 2.0) + pow(dir.y, 2.0));"
				"if(inEffect()){ float per = effect(); color = mix(texture2D(texture0, effectCoord(per)), waterColor, per * waterIdentity); } else { color = texture2D(texture0, qt_TexCoord0); }"
				"gl_FragColor = color;"
				"}"
				"';"
				"\n"
				"Timer{"
				"id: gl_timer;"
				"running: true;"
				"repeat: true;"
				"interval: gl.interval;"
				"onTriggered: {"
				"gl.offset -= gl.waveRollSpeed;"
				"if(gl.offset <= -2.0) { gl.offset += 2.0; }"
				"if(gl.radius > gl.radiusLimit) { }"
				"else { gl.radius += gl.waveSpeed; }"
				"if(gl.placeRadius > gl.radiusLimit) { gl.radius = 0; gl.offset = 0.0; gl.placeRadius = 0; }"
				"}"
				"}"
				"\n"
				"function toggle() { time.running ^= 1; }"
				"\n"
				"function setCenter(x, y) { if(gl.width > gl.height) gl.center = Qt.point(x, gl.height - y); else gl.center = Qt.point(y, x); gl.placeRadius = 0; gl.offset = 0.0; }"
				"\n"
				"function pause() { gl_timer.stop(); }"
				"\n"
				"function play() { gl_timer.start(); }"
				"\n"
				"function stop() { gl_timer.stop(); reset(); }"
				"\n"
				"function reset() { gl.radius = 0; gl.placeRadius = 0; gl.offset = 0.0; }"
				"\n"
				"MouseArea{"
				"id: mouseArea;"
				"anchors.fill: parent;"
				"enabled: gl.mouse && gl.item != null;"
				//"onClicked: {"
				"onPositionChanged: {"
				"if(mouseArea.pressed)"
				"setCenter(mouse.x, mouse.y);"
				//"mouse.accepted = false;"
				"}"
				"onClicked: gl.clicked(mouse.x, mouse.y);"
				"}"
				"Component.onDestruction: {"
				"console.log('[Debug]: Qml -> WaterWareShader is destroyed.');"
				"}\n"
				"}"
				)
				, p, QUrl(), props);

	return obj;
}

QObject * idUtility::CreateQmlObject(const QString &src, QObject *p, const QUrl &url, const QVariantMap &props)
{
	QByteArray qmlSrc;
	QObject *obj;
	QDeclarativeItem *item;
	QDeclarativeItem *pitem;

	if(!p)
		return 0;
	if(!oEngine)
		return 0;

	qmlSrc.append(src);
	QDeclarativeComponent component(oEngine);
	component.setData(qmlSrc, url);
	obj = component.create();
	if(!component.isReady())
	{
		QList<QDeclarativeError> errors = component.errors();
		qWarning() << "[Warning]: Create Qml component error -> ";
		ID_CONST_FOREACH(QList<QDeclarativeError>, errors)
		{
			qWarning() << *itor;
		}
		return 0;
	}

	obj->setParent(p);
	item = qobject_cast<QDeclarativeItem *>(obj);
	if(item)
	{
		pitem = qobject_cast<QDeclarativeItem *>(p);
		if(pitem)
			item->setParentItem(pitem);
	}
	ID_CONST_FOREACH(QVariantMap, props)
	{
		QDeclarativeProperty(obj, itor.key()).write(itor.value());
	}

	return obj;
}

QVariant idUtility::EvaluteScript(const QString &src, QObject *scope)
{
	QVariant ret;
	bool ok;

	if(!scope)
		return ret;
	if(src.isEmpty())
		return ret;
	if(!oEngine)
		return ret;

	QDeclarativeExpression expr(oEngine->rootContext(), scope, src);
	ret = expr.evaluate(&ok);
	if(expr.hasError())
	{
		qDebug() << "[Debug]: Evalute qml script error -> " << expr.error();
	}

	return ret;
}

bool idUtility::EvaluteScriptv(const QString &src, QObject *scope, QVariant *r)
{
	QVariant ret;
	bool ok;

	if(!scope)
		return false;
	if(src.isEmpty())
		return false;
	if(!oEngine)
		return false;

	QDeclarativeExpression expr(oEngine->rootContext(), scope, src);
	ret = expr.evaluate(&ok);
	if(expr.hasError())
	{
		qDebug() << "[Debug]: Evalute qml script error -> " << expr.error();
		return false;
	}

	if(r)
		*r = ret;
	return true;
}

void idUtility::CheckUpdate(bool open)
{
#define OPENREPOS_VERSION "v1"
#define OPENREPOS_APIURL "https://openrepos.net/api"
#define OPENREPOS_APP_DETAIL "apps/"
	QString appid = Get("APPID").toString();
	QString url = QString("%1/%2/%3").arg(OPENREPOS_APIURL).arg(OPENREPOS_VERSION).arg(OPENREPOS_APP_DETAIL + appid);
	QObject *app;
	idNetworkConnector *connector;
	QString msg("正在检查更新...");

	qDebug() << msg;
	app = qml_viewer->rootObject();
	if(open)
	{
		EvaluteScriptv("showBanner('" + msg + "');", app);
	}

	connector = idNetworkConnector::Instance();

	connect(connector, SIGNAL(finished(const QString &, int, const QString &)), this, SLOT(CheckUpdateResult(const QString &, int, const QString &)));
	connector->Request(url, QString("CHECK_UPDATE_%1").arg(open ? "SHOW" : "HIDE"));
}

void idUtility::CheckUpdateResult(const QString &name, int ret, const QString &value)
{
#define OPENREPOS_APP_DETAIL_URL "https://openrepos.net/content/%1/%2"
	QObject *app;
	QJson::Parser parser;
	bool ok;
	QString msg;
	bool update;
	QString v(Get("VER").toString());
	int u;
	bool open;
	idNetworkConnector *connector;
    QRegExp Regex("[_\\+\\s]+");
	QVariant json;
	QVariantMap result;
	QString appid_r;
	QString title;
	QString updated;
	QString changelog;
	QString package_name;
	QString package_version;
	QString user_name;
	QString _url;

	connector = idNetworkConnector::Instance();
	update = false;
	open = name.startsWith("CHECK_UPDATE_SHOW");
	app = qml_viewer->rootObject();

	connector->disconnect(this, SLOT(CheckUpdateResult(const QString &, int, const QString &)));

	if(ret != 0)
	{
		msg = value;
		goto __Exit;
	}
	json = parser.parse(QByteArray().append(value), &ok);
	if(!ok)
	{
		msg = "返回数据错误.";
		goto __Exit;
	}
	if(json.canConvert<QVariantList>()) // ["Application not found"]
	{
		QVariantList list = json.toList();
		msg = list.isEmpty() ? "OpenRepos响应数据错误" : list[0].toString();
		goto __Exit;
	}
	result = json.toMap();
	appid_r = result["appid"].toString();
	title = result["title"].toString();
	updated = QDateTime::fromTime_t(result["updated"].toLongLong()).toString("yyyy-MM-dd" /* hh:mm:ss*/);
	changelog = result["changelog"].toString();
	user_name = result["user"].toMap()["name"].toString();
	result = result["package"].toMap();
	package_name = result["name"].toString();
	package_version = result["version"].toString();
	_url = QString(OPENREPOS_APP_DETAIL_URL)
		.arg(QString(user_name).replace(Regex, "").toLower())
		.arg(QString(title).replace(Regex, "").toLower())
		;

	qDebug() << "[Debug]: OpenRepos.net -> " << appid_r << title << updated << changelog << user_name << package_name <<package_version << _url;
	u = package_version.compare(v, Qt::CaseInsensitive);
	qDebug() << v << package_version << u;

	if(package_name.isEmpty() && package_version.isEmpty()) // downed
	{
		msg = "该应用已下架, 可能由于某种原因, 所以不建议继续使用.";
		goto __Exit;
	}
	if(package_name != Get("PKG").toString())
	{
		msg = "该应用未上传.";
		goto __Exit;
	}

	if(u == 0)
	{
		msg = "该应用已是最新版本.";
	}
	else if(u < 0)
	{
		msg = "该应用本地版本较新, 可能是在其他源进行安装, 或作者未上传最新版本.";
	}
	else // update
	{
		msg = "有新版本可更新."
			+ (" 版本: " + package_version)
			+ (" 发布: " + updated)
			;
		if(open)
			msg += " 正在打开下载页面.";
		else
			msg += " 请进入关于页面进行更新.";
		update = true;
	}

__Exit:
	qDebug() << msg;
	if(update)
	{
		EvaluteScriptv("showBanner('" + msg + "');", app);
		if(open)
		{
			QDesktopServices::openUrl(QUrl(
#ifdef _HARMATTAN
						_url
#else
						Get("PAN").toStringList()[0]
#endif
						));
		}
	}
	else
	{
		if(open)
			EvaluteScriptv("showBanner('" + msg + "');", app);
	}
}

QSize idUtility::ScreenSize() const
{
	return QApplication::desktop()->screenGeometry().size();
	//primaryScreen()
}

