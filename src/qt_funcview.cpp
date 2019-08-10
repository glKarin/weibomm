#include "qt_funcview.h"

#include <QDesktopServices>
#include <QDebug>
#include <QDateTime>
#include <QUrl>
#include <QSystemDeviceInfo>

	id_qt_funcView::id_qt_funcView(QObject *parent)
	: QObject(parent)
{
	setObjectName("id_qt_funcView");
}

id_qt_funcView::~id_qt_funcView()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_qt_funcView::printCurrentTime(const QString &text) const
{
	qDebug() << "[" + QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss") + "]:" + text;
}

void id_qt_funcView::init()
{
	qDebug() << "[Debug]: qt_funcView::init()";
}

int id_qt_funcView::getSystemVolume() const
{
	QTM_USE_NAMESPACE
	return QSystemDeviceInfo::ProfileDetails().messageRingtoneVolume(); //voiceRingtoneVolume()
}

void id_qt_funcView::openUrlInSysBrowser(const QString &url) const
{
	QDesktopServices::openUrl(QUrl(url));
}

ID_SINGLE_INSTANCE_DECL(id_qt_funcView)
