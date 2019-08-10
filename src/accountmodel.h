#ifndef _KARIN_ACCOUNTMODEL_H
#define _KARIN_ACCOUNTMODEL_H

#include "qmlmodel_base.h"
#include "id_std.h"

#define ID_UNLOGIN_USERID_PREFIX "__idUnloginUserID__"

class id_loginModel;

class id_accountModel : public idQmlModel_base
{
	Q_OBJECT

	public:
		enum idDataRole_e
		{
				Role_userName = Qt::UserRole + 1,
		};

	public:
		virtual ~id_accountModel();
		ID_SINGLE_INSTANCE_DEF(id_accountModel)
		void UpdateAccountFromLoginModel(const id_loginModel *login);
		QString CurrentUserId() const;

			public Q_SLOTS:
			QString getAccountId(int index) const;
		void login(const QString &token = QString(), const QString &secret = QString());
		void getAccountList();
		void deleteAccount(const QString &id);
		int getAccountCount() const;
		QString getAccountToken(int index) const;
		QString getAccountSecret(int index) const;
		bool checkExist(const QString &account) const;
		void addAccount(const QString &account, const QString &psw);
		void updateAccountName(const QString &id, const QString &name);

Q_SIGNALS:
		void loginFinish_ForAddAccount(int errCode);
		void loginFinish(int errCode);
		void currentUserIdChanged(const QString &currentUserId);

	protected:
		virtual void InitRoleMap();

		private Q_SLOTS:
			void loginFinished_Slot();

	private:
		void SetCurrentUserId(const QString &id);
		void Init(bool l = false);
		void HandleCurrentUserChanged();

	private:
		QString m_currentUserId;

	private:
		explicit id_accountModel(QObject *parent = 0);
};

#endif
