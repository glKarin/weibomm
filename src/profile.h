#ifndef _KARIN_PROFILE_H
#define _KARIN_PROFILE_H

#include <QObject>

#include "id_std.h"

class id_profile : public QObject
{
	Q_OBJECT
		Q_PROPERTY(int topic READ Topic NOTIFY topicChanged)
		Q_PROPERTY(bool isVip READ IsVip NOTIFY isVipChanged)
		Q_PROPERTY(QString userIcon READ UserIcon NOTIFY userIconChanged)
		Q_PROPERTY(QString nick READ Nick WRITE SetNick NOTIFY nickChanged)
		Q_PROPERTY(QString address READ Address NOTIFY addressChanged)
		Q_PROPERTY(QString account READ Account NOTIFY accountChanged)
		Q_PROPERTY(int attention READ Attention NOTIFY attentionChanged)
		Q_PROPERTY(int weibo READ Weibo NOTIFY weiboChanged)
		Q_PROPERTY(int funs READ Funs NOTIFY funsChanged)
		Q_PROPERTY(QString gender READ Gender WRITE SetGender NOTIFY genderChanged) // m, n, f
		Q_PROPERTY(QString userId READ UserId NOTIFY userIdChanged)

	public:
		virtual ~id_profile();
		ID_SINGLE_INSTANCE_DEF(id_profile)
			int Topic() const;
		bool IsVip() const;
		QString UserIcon() const;
		QString Nick() const;
		QString Address() const;
		QString Account() const;
		int Attention() const;
		int Weibo() const;
		int Funs() const;
		QString Gender() const;
		QString UserId() const;
		void SetGender(const QString &value);
		void SetNick(const QString &value);
		bool Result() const;

		public Q_SLOTS:
			virtual void getSinaWeiboProfile(const QString &userId, const QString &name = QString());
		virtual void connectModel();
		virtual void disConnectModel();
		void initializeData();

	protected:
		explicit id_profile(QObject *parent = 0);
		void SetTopic(int value);
		void SetUserIcon(const QString &value);
		void SetAddress(const QString &value);
		void SetAccount(const QString &value);
		void SetIsVip(bool value);
		void SetAttention(int value);
		void SetWeibo(int value);
		void SetFuns(int value);
		void SetUserId(const QString &id);
		void SetResult(bool value);

Q_SIGNALS:
		void readyFinishProfile(int errCode);
		void topicChanged(int topic);
		void isVipChanged(bool isVip);
		void userIconChanged(const QString &userIcon);
		void nickChanged(const QString &nick);
		void addressChanged(const QString &address);
		void accountChanged(const QString &account);
		void attentionChanged(int attention);
		void weiboChanged(int weibo);
		void funsChanged(int funs);
		void genderChanged(const QString &gender);
		void userIdChanged(const QString &userId);

	protected:
		int m_topic;
		bool m_isVip;
		QString m_userIcon;
		QString m_nick;
		QString m_address;
		QString m_account;
		int m_attention;
		int m_weibo;
		int m_funs;
		QString m_gender;
		QString m_userId;

		bool m_connected;
		bool m_result;

private:
		Q_DISABLE_COPY(id_profile)
};

#endif
