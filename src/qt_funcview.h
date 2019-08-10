#ifndef _KARIN_QT_FUNCVIEW_H
#define _KARIN_QT_FUNCVIEW_H

#include <QObject>

#include "id_std.h"

class id_qt_funcView : public QObject
{
	Q_OBJECT

	public:
		virtual ~id_qt_funcView();
		ID_SINGLE_INSTANCE_DEF(id_qt_funcView)

			public Q_SLOTS:
		void printCurrentTime(const QString &text) const;
		void init();
		int getSystemVolume() const;
		void openUrlInSysBrowser(const QString &url) const;

	private:
		explicit id_qt_funcView(QObject *parent = 0);
		Q_DISABLE_COPY(id_qt_funcView)

};

#endif
