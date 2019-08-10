#include "emotionlist.h"

#include <QDir>
#include <QDebug>
#include <math.h>

#define ID_EMOTION_DIR "images/emotion_png"

id_emotionlist::id_emotionlist(QObject *parent)
	: idQmlModel_base(parent),
	m_path(QDir::cleanPath(id::adjust_path("qml/" ID_QML_DIR "/" ID_EMOTION_DIR)))
{
	setObjectName("id_emotionlist");
	Init();
}

id_emotionlist::~id_emotionlist()
{
	ID_QOBJECT_DESTROY_DBG
}

QString id_emotionlist::getPath() const
{
	return m_path;
}

int id_emotionlist::getPageCount(int ps) const
{
	return (int)ceil((double)rowCount() / (double)ps);
}

QString id_emotionlist::getIconPath(int pn, int index, int ps) const
{
	int i;

	i = pn * ps + index;
	if(i >= rowCount())
		return QString();
	return ID_EMOTION_DIR + ("/" + GetValue(i, "file_name").toString());
}

void id_emotionlist::Init()
{
	QDir dir(m_path);
	if(!dir.exists())
		return;

	idQmlModelData_t list;
	removeAllItemList();
	QStringList files = dir.entryList(QDir::NoDotAndDotDot | QDir::Files, QDir::Name);
	ID_CONST_FOREACH(QStringList, files)
	{
		QVariantMap m;
		m.insert("file_name", *itor);
		list.push_back(m);
	}
	idQmlModel_base::operator=(list);
	SetReflashCount(list.size());
	SetReflashTime();
}

ID_SINGLE_INSTANCE_DECL(id_emotionlist)
