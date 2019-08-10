#ifndef _KARIN_WEIBOPROFILEMODEL_H
#define _KARIN_WEIBOPROFILEMODEL_H

#include "profile.h"

class id_WeiboProfileModel : public id_profile
{
	Q_OBJECT
		Q_PROPERTY(bool isFollowing READ IsFollowing NOTIFY isFollowingChanged)
		Q_PROPERTY(bool isFollowMe READ IsFollowMe NOTIFY isFollowMeChanged)

	public:
		explicit id_WeiboProfileModel(QObject *parent = 0);
		virtual ~id_WeiboProfileModel();
		void SetIsFollowing(bool value);
		void SetIsFollowMe(bool value);
		bool IsFollowing() const;
		bool IsFollowMe() const;

		public Q_SLOTS:
			void destroyAttentionShip(const QString &userId, const QString &userName);
		void createAttentionShip(const QString &userId, const QString &userName);
		void getAttention(const QString &userId, const QString &userName);

Q_SIGNALS:
      void readyFinishAttention(int errCode, bool isattend, bool isfollowed);
      void createOrDestroyAttention(int errCode);
			void isFollowingChanged(bool m_isFollowing);
			void isFollowMeChanged(bool m_isFollowMe);

	private:
			bool m_isFollowing;
			bool m_isFollowMe;
};

#endif
