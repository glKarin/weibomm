#include "crypt.h"

#include <QDebug>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

namespace id
{
	static int bin2hex(char **dst, int *len, const char *src, int slen);
	static int evp_public_encrypt(RSA *rsa, char **dst, int *dlen, const char *src, int slen);
	static int generate_public_key(RSA *r, const char *n_hex, const char *e_hex);
}

namespace id
{
	int bin2hex(char **dst, int *len, const char *src, int slen)
	{
		int i;
		int dlen;
		char *r;
		const char Hex[] = "0123456789abcdef";
		char *p;
		const unsigned char *sp;

		dlen = slen * 2 + 1;
		r = (char *)malloc(dlen);
		p = r;
		sp = (const unsigned char *)src;
		memset(r, 0, dlen);
		for(i = 0; i < slen; i++)
		{
			*p++ = Hex[*sp >> 4];
			*p++ = Hex[*sp++ & 0x0F];
		}

		*len = dlen - 1;
		*dst = r;
		return 0;
	}

	int generate_public_key(RSA *rsa, const char *n_hex, const char *e_hex)
	{
#ifndef _SIMULATOR
		BIGNUM *e;
		BIGNUM *m;

		if(n_hex)
		{
			if(rsa->n)
			{
				BN_free(rsa->n);
				rsa->n = 0;
			}
			m = BN_new();
			BN_hex2bn(&m, n_hex);
			rsa->n = m;
		}
		if(e_hex)
		{
			if(rsa->e)
			{
				BN_free(rsa->e);
				rsa->e = 0;
			}
			e = BN_new();
			BN_hex2bn(&e, e_hex);
			rsa->e = e;
		}
#endif
		return 0;
	}

	int evp_public_encrypt(RSA *rsa, char **dst, int *dlen, const char *src, int slen)
	{
#ifndef _SIMULATOR
		EVP_PKEY *pkey;
		char *encrypt_data;
		int len;
		int ret;
		int i;

		pkey = EVP_PKEY_new();
		assert(pkey != NULL);
		EVP_PKEY_assign_RSA(pkey, rsa);
		OpenSSL_add_all_ciphers();

		len = RSA_size(rsa);
		encrypt_data = (char *)malloc(len);
		memset(encrypt_data, 0, len);
		ret = EVP_PKEY_encrypt((unsigned char *)encrypt_data, (unsigned char *)src, slen, pkey);
		if(ret > 0)
		{
			*dst = encrypt_data;
			*dlen = len;
		}
#if 0
		printf("ret: %d %p\n", len, encrypt_data);
		printf("ret: %d %d\n", ret, len);
		for(i = 0; i < len; i++)
		{
			printf("%x ", encrypt_data[i]);
		}
		printf("\n");
#endif

		EVP_PKEY_free(pkey);
		return ret > 0 ? 0 : -1;
#else
    return 0;
#endif
    }
}



	idCrypt::idCrypt(QObject *parent)
: QObject(parent),
	m_rsa(0)
{
	setObjectName("idCrypt");
}

idCrypt::~idCrypt()
{
	ID_QOBJECT_DESTROY_DBG
	return;
#ifndef _SIMULATOR
	if(m_rsa)
		RSA_free(m_rsa);
#endif
}


void idCrypt::SetPublicKey(const QString &m, const QString &e)
{
#ifndef _SIMULATOR
	if(!m_rsa)
		m_rsa = RSA_new();
	id::generate_public_key(m_rsa, QByteArray().append(m).constData(), QByteArray().append(e).constData());
#endif
}

QString idCrypt::Encrypt(const QString &str)
{
#ifndef _SIMULATOR
	char *dst, *dst_hex;
	int len, len_hex;
	QByteArray bytes;
	int ret;

	if(!m_rsa)
		return QString::null;
	bytes.append(str);
	if(bytes.size() == 0)
		return QString::null;

	ret = id::evp_public_encrypt(m_rsa, &dst, &len, bytes.constData(), bytes.size());
	if(ret != 0)
		return QString::null;
	id::bin2hex(&dst_hex, &len_hex, dst, len);

	QByteArray rbytes(dst_hex, len_hex);

	free(dst);
	free(dst_hex);

	return QString(rbytes);
#else
	return QString();
#endif
}

QByteArray idCrypt::Encrypt(const QString &data, const QString &n, const QString &e)
{
	idCrypt crypto;
	crypto.SetPublicKey(n, e);
	return QByteArray().append(crypto.Encrypt(data));
}

ID_SINGLE_INSTANCE_DECL(idCrypt)
