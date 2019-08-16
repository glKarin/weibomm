#ifndef ID_STD_H
#define ID_STD_H

#include <QVariant>

#define ID_APP "WeiBo++"
#define ID_NAME "微博++"
#define ID_PKG "weibomm"
#define ID_PATCH "2"
#define ID_VER "1.3.2.1harmattan2014." ID_PATCH
#define ID_CODE "paradise"
#define ID_DEV "karin"
#define ID_DEVELOPER "Karin"
#define ID_RELEASE "20140405"
#define ID_STATE "devel"
#define ID_GITHUB "https://github.com/glKarin/weibomm"
#define ID_PAN "https://pan.baidu.com/s/1o2TEIE1W9dhHu0jahJ5Abg vrku"
#define ID_OPENREPOS "https://openrepos.net/content/karinzhao/weibo"
#define ID_EMAIL "beyondk2000@gmail.com"
#define ID_TMO "http://talk.maemo.org/member.php?u=70254"
#define ID_DESC "微博++(weibomm)是基于新浪微博N9版客户端UI+H5端API接口, 重写可执行文件版本."
#define ID_BUID "beyondk2000"
#define ID_APPID "10857"
#ifdef _HARMATTAN
#define ID_PLATFORM "MeeGo 1.2 Harmattan"
#else
#define ID_PLATFORM "Symbian"
#endif

#define ID_QML_DIR "SinaWeiboClient"

#define ID_FOREACH(T, t) for(T::iterator itor = t.begin(); itor != t.end(); ++itor)
#define ID_CONST_FOREACH(T, t) for(T::const_iterator itor = t.constBegin(); itor != t.constEnd(); ++itor)
#define ID_FOREACH2(T, t, n) for(T::iterator itor_##n = t.begin(); itor_##n != t.end(); ++itor_##n)
#define ID_CONST_FOREACH2(T, t, n) for(T::const_iterator itor_##n = t.constBegin(); itor_##n != t.constEnd(); ++itor_##n)
#define ID_UNTIL(condition) while(!(condition))

#define ID_QML_URI ID_DEV"."ID_PKG
#define ID_QML_MAJOR_VER 1
#define ID_QML_MINOR_VER 0

#define ungzip(dst, src) iduncompress(dst, src, 32 + 15)
#define unz(dst, src) iduncompress(dst, src, -15)

#ifdef _DBG
#define ID_DESTROY_DBG(x) qDebug() << QString("[Debug]: %1 is destroyed.").arg(x);
#define ID_QOBJECT_DESTROY_DBG ID_DESTROY_DBG(objectName());
#else
#define ID_DESTROY_DBG(x)
#define ID_QOBJECT_DESTROY_DBG
#endif

#define ID_SINGLE_INSTANCE_DEF(clazz) \
	static clazz * Instance();
#define ID_SINGLE_INSTANCE_DECL(clazz) \
	clazz * clazz::Instance() \
{ \
	static clazz _staticObject; \
	return &_staticObject; \
}

#define ID_REQ_ERR(msg) if(ret != 0) \
	{ \
		qDebug() << msg " => " << ret; \
		goto __Error; \
	}

#define ID_JSON_ERR(msg) if(!ok) \
	{ \
		qDebug() << msg << data; \
		goto __Error; \
	}

namespace id
{
	QString md5(const QString &src);
	QString md5_b64(const QString &src);
	int iduncompress(QByteArray *dst, const QByteArray &data, int windowbits);
	QVariant qvariant_from_xml(const QString &xml);
	bool file_put_contents(const QString &file, const QByteArray &data, int mode = 0);
	bool mkdirs(const QString &path);
	QString adjust_path(const QString &path);
	QString get_alphabet(const QString &str);
	bool network_online();
	QByteArray file_get_contents(const QString &src, bool *ok = 0);
}

#endif // ID_STD_H
