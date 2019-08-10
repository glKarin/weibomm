#include "selectqmlmodel_base.h"

idSelectQmlModel_base::idSelectQmlModel_base(QObject *parent)
	: idQmlModel_base(parent)
{
	setObjectName("idSelectQmlModel_base");
}

idSelectQmlModel_base::~idSelectQmlModel_base()
{
	//ID_QOBJECT_DESTROY_DBG
}

void idSelectQmlModel_base::setListHeaderText(const QString &header)
{
	if(m_listHeaderText != header)
	{
		m_listHeaderText = header;
		emit listHeaderTextChanged(m_listHeaderText);
	}
}

void idSelectQmlModel_base::setListTailText(const QString &tail)
{
	if(m_listTailText != tail)
	{
		m_listTailText = tail;
		emit listTailTextChanged(m_listTailText);
	}
}

QString idSelectQmlModel_base::ListHeaderText() const
{
	return m_listHeaderText;
}

QString idSelectQmlModel_base::ListTailText() const
{
	return m_listTailText;
}
