#ifndef _KARIN_CRYPT_H
#define _KARIN_CRYPT_H

#include <QObject>

#ifndef _SIMULATOR
#include <openssl/ssl.h>
#else
typedef void RSA;
#endif

#include "id_std.h"

class idCrypt : public QObject
{
	Q_OBJECT

	public:
		virtual ~idCrypt();
		ID_SINGLE_INSTANCE_DEF(idCrypt)

	public :
			Q_INVOKABLE QString Encrypt(const QString &data);
			Q_INVOKABLE void SetPublicKey(const QString &n, const QString &e);
			static QByteArray Encrypt(const QString &data, const QString &n, const QString &e);

	private:
			RSA *m_rsa;

	public:
			explicit idCrypt(QObject *parent = 0);
			Q_DISABLE_COPY(idCrypt)
};

#endif
