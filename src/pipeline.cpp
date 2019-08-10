#include "pipeline.h"

#include <QApplication>
#include <QDebug>
#include <QNetworkReply>
#ifndef _SIMULATOR
#include <MNotification>
#include <MRemoteAction>
#endif

#include "id_std.h"
#include "networkmanager.h"
#include "qmlapplicationviewer.h"

extern QmlApplicationViewer *qml_viewer;

idPipeline::idPipeline(QObject *parent)
	: 
#ifndef _SIMULATOR
		QDBusAbstractAdaptor
#else
		QObject
#endif
		(parent)
{
	setObjectName("idPipeline");
}

idPipeline::~idPipeline()
{
	ID_QOBJECT_DESTROY_DBG
	ClearNotifications();
}

void idPipeline::ShowNotification(const QString &title, const QString &message)
{
	ClearNotifications();
	AddNotification(title, message);
}

void idPipeline::AddNotification(const QString &title, const QString &message)
{
#ifndef _SIMULATOR
	MNotification notification(ID_PKG, title, message);
	MRemoteAction action("com." ID_DEV "." ID_PKG, "/com/" ID_DEV "/" ID_PKG, "com." ID_DEV "." ID_PKG, "ActivateWindow");
	notification.setAction(action);
	notification.publish();
#else
	qDebug() << "AddNotification:" << title << message;
#endif
}

void idPipeline::ClearNotifications()
{
#ifndef _SIMULATOR
	QList<MNotification *> activeNotifications = MNotification::notifications();
	QMutableListIterator<MNotification *> i(activeNotifications);
	while (i.hasNext()) {
		MNotification *notification = i.next();
		if (notification->eventType() == ID_PKG)
			notification->remove();
	}
#else
	qDebug() << "ClearNotification";
#endif
}

void idPipeline::ActivateWindow()
{
	if(qml_viewer)
	{
		qDebug() << "Activate window";
		qml_viewer->showExpanded();
		qml_viewer->activateWindow();
	}
}

void idPipeline::DeactivateWindow()
{
	if(qml_viewer)
	{
		qDebug() << "Deactivate window";
		qml_viewer->hide();
	}
}

idPipeline * idPipeline::Create(QObject *parent)
{
	static idPipeline *pipeline = 0;
	if(!pipeline)
	{
		pipeline = new idPipeline(parent);
		id::register_to_qt_dbus("com." ID_DEV "." ID_PKG, "/com/" ID_DEV "/" ID_PKG, parent);
	}
	return pipeline;
}



namespace id
{
	bool register_to_qt_dbus(const QString &service, const QString &path, QObject *obj)
	{
#ifndef _SIMULATOR
		QDBusConnection conn = QDBusConnection::sessionBus();
		if(!conn.registerService(service))
			qDebug() << "QtDBus -> " << conn.lastError();
		else
		{
			if(!conn.registerObject(path, obj))
				qDebug() << "QtDBus -> " << conn.lastError();
			else
				return true;
		}
#endif
		return false;
	}
}
