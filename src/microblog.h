#ifndef _KARIN_MICROBLOG_H
#define _KARIN_MICROBLOG_H

#include <QObject>
#include <QStringList>
#include <QGeoSearchReply>
#include <QGeoSearchManagerEngine>

#include "id_std.h"

QTM_USE_NAMESPACE

class id_microBlog : public QObject
{
	Q_OBJECT

	public:
		explicit id_microBlog(QObject *parent = 0);
		virtual ~id_microBlog();
		ID_SINGLE_INSTANCE_DEF(id_microBlog)

		public Q_SLOTS:
			void reqGeoAddress(qreal latitude, qreal longitude);
		void handleTimeout();
		void addLocation(qreal latitude, qreal longitude); // UNUSED
		QString getGeoAddress();
		void removeLocation();
		void sendNewMicroBlog(const QString &content, const QString &selectImageSrc = QString());
		void sendCommentMicroBlog(const QString &statusId, const QString &content, bool checked);
		void sendCommentReply(const QString &commentStatusID, const QString &content, const QString &replyRetweetedId);
		void sendForwordMicroBlog(const QString &content, const QString &statusId, bool checked = false);

		void SendNewMicroBlog(const QString &content, const QStringList &selectImageSrc = QStringList());

Q_SIGNALS:
		void readyFinishNew(int errCode); // UNUSED, using qml
		void getPosFromGPS(int errCode);
		void readyFinishComment(int errCode);
		void readyFinishForword(int errCode);
		void readyFinishCommentReply(int errCode);
		void readyFinishGeoAddress(int errCode);

		private Q_SLOTS:
			void replyFinished_Slot();

	private:
		QGeoSearchManagerEngine *m_engine;
		QGeoSearchReply *m_reply;
		QString m_address;
};

#endif
