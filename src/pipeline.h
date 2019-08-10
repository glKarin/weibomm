#ifndef _KARIN_PIPELINE_H
#define _KARIN_PIPELINE_H

#ifndef _SIMULATOR
#include <QtDBus>
#else
#include <QObject>
#endif

#include <QVariant>

#include "id_std.h"

class idPipeline : public 
#ifndef _SIMULATOR
									 QDBusAbstractAdaptor
#else
									 QObject
#endif
{
	Q_OBJECT
#ifndef _SIMULATOR
		Q_CLASSINFO("D-Bus Interface", "com.karin.weibomm")  

		Q_CLASSINFO("D-Bus Introspection",  
				"  <interface name=\"com.karin.weibomm\">\n"  
				"    <method name=\"ActivateWindow\">\n"  
				"    </method>\n" 
				"    <method name=\"DeactivateWindow\">\n"  
				"    </method>\n" 
				"  </interface>\n"  
				"")
#endif

	public:
		virtual ~idPipeline();
		static idPipeline * Create(QObject *parent);
		Q_INVOKABLE void ShowNotification(const QString &title, const QString &message);
		Q_INVOKABLE void AddNotification(const QString &title, const QString &message);
		Q_INVOKABLE void ClearNotifications();

		public Q_SLOTS:
		void ActivateWindow();
		void DeactivateWindow();

	private:
		idPipeline(QObject *parent = 0);

		Q_DISABLE_COPY(idPipeline)

};

namespace id
{
	bool register_to_qt_dbus(const QString &service, const QString &path, QObject *obj);
}

#endif
