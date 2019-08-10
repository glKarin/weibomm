#ifndef _KARIN_DELETEMODEL_H
#define _KARIN_DELETEMODEL_H

#include <QObject>

class id_DeleteModel : public QObject
{
	Q_OBJECT

	public:
		explicit id_DeleteModel(QObject *parent = 0);
		virtual ~id_DeleteModel();

		public Q_SLOTS:
			virtual void connectModel();
		virtual void disConnectModel();

		void deleteStatus(const QString &statusID);

Q_SIGNALS:
		void getDeleteResult(int errCode);

	private:
		bool m_connected;
};

#endif
