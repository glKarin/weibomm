
#ifndef _KARIN_DETAILMODEL_H
#define _KARIN_DETAILMODEL_H

#include <QObject>

#include "id_std.h"

class id_DetailModel : public QObject
{
Q_OBJECT
        Q_PROPERTY(bool hasMapFlag READ HasMapFlag NOTIFY hasMapFlagChanged)
        Q_PROPERTY(QString statusText READ StatusText NOTIFY statusTextChanged)
        Q_PROPERTY(QString statusImage READ StatusImage NOTIFY statusImageChanged)
        Q_PROPERTY(QString retweetedID READ RetweetedID NOTIFY retweetedIDChanged)
        Q_PROPERTY(QString retweetedUserName READ RetweetedUserName NOTIFY retweetedUserNameChanged)
        Q_PROPERTY(QString retweetedText READ RetweetedText NOTIFY retweetedTextChanged)
        Q_PROPERTY(QString retweetedImage READ RetweetedImage NOTIFY retweetedImageChanged)
        Q_PROPERTY(int retweetedRepostCount READ RetweetedRepostCount NOTIFY retweetedRepostCountChanged)
        Q_PROPERTY(int retweetedCommentCount READ RetweetedCommentCount NOTIFY retweetedCommentCountChanged)
        Q_PROPERTY(QString mapUrl READ MapUrl NOTIFY mapUrlChanged)
        Q_PROPERTY(QString statusID READ StatusID NOTIFY statusIDChanged)
        Q_PROPERTY(int statusCommentCount READ StatusCommentCount NOTIFY statusCommentCountChanged)
        Q_PROPERTY(int statusRepostCount READ StatusRepostCount NOTIFY statusRepostCountChanged)
        Q_PROPERTY(QString statusSource READ StatusSource NOTIFY statusSourceChanged)
        Q_PROPERTY(QString statusCreateTime READ StatusCreateTime NOTIFY statusCreateTimeChanged)
        Q_PROPERTY(bool userVerified READ UserVerified NOTIFY userVerifiedChanged)
        Q_PROPERTY(QString userProfileImg READ UserProfileImg NOTIFY userProfileImgChanged)
        Q_PROPERTY(QString userName READ UserName NOTIFY userNameChanged)
        Q_PROPERTY(QString userID READ UserID NOTIFY userIDChanged)
        Q_PROPERTY(qreal latitude READ Latitude NOTIFY latitudeChanged)
        Q_PROPERTY(qreal longitude READ Longitude NOTIFY longitudeChanged)

    public:
        explicit id_DetailModel(QObject *parent = 0);
        virtual ~id_DetailModel();
        bool HasMapFlag() const;
        QString StatusText() const;
        QString StatusImage() const;
        QString RetweetedID() const;
        QString RetweetedUserName() const;
        QString RetweetedText() const;
        QString RetweetedImage() const;
        int RetweetedRepostCount() const;
        int RetweetedCommentCount() const;
        QString MapUrl() const;
        QString StatusID() const;
        int StatusCommentCount() const;
        int StatusRepostCount() const;
        QString StatusSource() const;
        QString StatusCreateTime() const;
        bool UserVerified() const;
        QString UserProfileImg() const;
        QString UserName() const;
        QString UserID() const;
        qreal Latitude() const;
        qreal Longitude() const;

        Q_INVOKABLE QVariant GetPageInfo() const;

        public Q_SLOTS:
            virtual void connectModel();
        virtual void disConnectModel();
        void getSinaWeiboDetail(const QString &statusID);
        void clearData();

Q_SIGNALS:
        void hasMapFlagChanged(bool hasMapFlag);
        void statusTextChanged(const QString &statusText);
        void statusImageChanged(const QString &statusImage);
        void retweetedIDChanged(const QString &retweetedID);
        void retweetedUserNameChanged(const QString &retweetedUserName);
        void retweetedTextChanged(const QString &retweetedText);
        void retweetedImageChanged(const QString &retweetedImage);
        void retweetedRepostCountChanged(int retweetedRepostCount);
        void retweetedCommentCountChanged(int retweetedCommentCount);
        void mapUrlChanged(const QString &mapUrl);
        void statusIDChanged(const QString &statusID);
        void statusCommentCountChanged(int statusCommentCount);
        void statusRepostCountChanged(int statusRepostCount);
        void statusSourceChanged(const QString &statusSource);
        void statusCreateTimeChanged(const QString &statusCreateTime);
        void userVerifiedChanged(bool userVerified);
        void userProfileImgChanged(const QString &userProfileImg);
        void userNameChanged(const QString &userName);
        void userIDChanged(const QString &userID);
        void latitudeChanged(qreal latitude);
        void longitudeChanged(qreal longitude);
        void getRequestResult(int errCode);

protected:
        void SetHasMapFlag(bool value);
        void SetStatusText(const QString &value);
        void SetStatusImage(const QString &value);
        void SetRetweetedID(const QString &value);
        void SetRetweetedUserName(const QString &value);
        void SetRetweetedText(const QString &value);
        void SetRetweetedImage(const QString &value);
        void SetRetweetedRepostCount(int value);
        void SetRetweetedCommentCount(int value);
        void SetMapUrl(const QString &value);
        void SetStatusID(const QString &value);
        void SetStatusCommentCount(int value);
        void SetStatusRepostCount(int value);
        void SetStatusSource(const QString &value);
        void SetStatusCreateTime(const QString &value);
        void SetUserVerified(bool value);
        void SetUserProfileImg(const QString &value);
        void SetUserName(const QString &value);
        void SetUserID(const QString &value);
        void SetLatitude(qreal value);
        void SetLongitude(qreal value);

        void AddPageInfo(const QVariant &p);

    private:
        bool m_hasMapFlag;
        QString m_statusText;
        QString m_statusImage;
        QString m_retweetedID;
        QString m_retweetedUserName;
        QString m_retweetedText;
        QString m_retweetedImage;
        int m_retweetedRepostCount;
        int m_retweetedCommentCount;
        QString m_mapUrl;
        QString m_statusID;
        int m_statusCommentCount;
        int m_statusRepostCount;
        QString m_statusSource;
        QString m_statusCreateTime;
        bool m_userVerified;
        QString m_userProfileImg;
        QString m_userName;
        QString m_userID;
        qreal m_latitude;
        qreal m_longitude;

        QVariantList m_pageInfo;

        bool m_connected;
};

#endif
