#include "helper.h"

#include <QRegExp>
#include <QGraphicsObject>

#include "api.h"
#include "api_defines.h"
#include "utility.h"
#include "qmlapplicationviewer.h"

extern QmlApplicationViewer *qml_viewer;

QString idHelper::FixedContentEmotion(const QString &src)
{
	// <span class=\"url-icon\"><img alt=[吃惊] src=\"//h5.sinaimg.cn/m/emoticon/icon/default/d_chijing-e806473437.png\" style=\"width:1em; height:1em;\" /></span>
	QRegExp p("<img alt=\\[(\\S*)\\] src=\"//");
	return QString(src).replace(p, "<img alt=[_\\1_] src=\"" M_SCHEME "//");
}

void idHelper::ShowBanner(const QString &text)
{
	QObject *app;

	if(!qml_viewer)
		return;

	app = qml_viewer->rootObject();
	idUtility::Instance()->EvaluteScriptv("showBanner('" + text + "');", app);
}

