#ifndef _KARIN_MAPI_H
#define _KARIN_MAPI_H

#include <QVariant>

#define ID_API_DEF(x) static QVariantMap x(const QVariantMap &params = QVariantMap(), int *r = 0);
#define ID_API_DECL(x) QVariantMap idAPI::x(const QVariantMap &params, int *r)

class idAPI
{
	public:
		enum{
			ErrCode_Loading = -1,
			ErrCode_Success = 200,
			ErrCode_Error = 9999,
		};

		enum{
			Type_This = 0,
			Type_Prev = 1,
			Type_Next = 2,
		};

	public:
		ID_API_DEF(UserProfile);
		ID_API_DEF(MyComment);
		ID_API_DEF(MyAt);
		ID_API_DEF(MyMessage);
		ID_API_DEF(MessageList);
		ID_API_DEF(Index);
		ID_API_DEF(UpdateProfile);
		ID_API_DEF(UpdateStatus);
		ID_API_DEF(SendMsg);
		ID_API_DEF(Follow);
		ID_API_DEF(Unfollow);
		ID_API_DEF(SendCmt);
		ID_API_DEF(Repost);
		ID_API_DEF(Reply);
		ID_API_DEF(StatusDetail);
		ID_API_DEF(LongText);
		ID_API_DEF(Comment);
		ID_API_DEF(Unread);
		ID_API_DEF(Contact);
		ID_API_DEF(SearchContact);
		ID_API_DEF(DelStatus);
		ID_API_DEF(UploadPic);
		ID_API_DEF(Logout);
		ID_API_DEF(Login);
		ID_API_DEF(UserId);

		ID_API_DEF(DelComment)
		ID_API_DEF(Attitude);
		ID_API_DEF(Unattitude);

	private:
		idAPI();
		virtual ~idAPI();
};

#endif
