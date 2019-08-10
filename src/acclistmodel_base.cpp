#include "acclistmodel_base.h"

#include <QDebug>

#include "helper.h"

	id_accListModel_base::id_accListModel_base(QObject *parent)
: idPagedQmlModel_base(parent)
{
	setObjectName("id_accListModel_base");
	InitRoleMap();
}

id_accListModel_base::~id_accListModel_base()
{
	//ID_QOBJECT_DESTROY_DBG
}

void id_accListModel_base::InitRoleMap()
{
	m_roles.clear();
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, userNickName);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, isVip);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, untilTime);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, hasPic);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, forwardcontent);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, forwardThumbnailPic);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, fromPlat);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, commentCount);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, forwardCount);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, statusThumbnailPic);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, hasMap);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, weibocontent);
	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, image);

	ID_QMLMODEL_INSERT_ROLE(id_accListModel_base, userId);
	setRoleNames(m_roles);
}

bool id_accListModel_base::MakeModelData(QVariantMap &map, const QVariantMap &item)
{
	if(item["card_type"].toInt() != 9)
		return false;

	QString pic;
	QVariantMap mblog = item["mblog"].toMap();
	QVariantMap user = mblog["user"].toMap();
	QVariantMap forward = mblog["retweeted_status"].toMap();

	map.clear();
	map.insert("isVip", user["verified"].toBool());
	map.insert("userNickName", user["screen_name"].toString());
	map.insert("untilTime", mblog["created_at"].toString());
	map.insert("hasPic", mblog["pic_num"].toInt());
	map.insert("hasMap", mblog["weibo_position"].toInt());
	map.insert("weibocontent", idHelper::FixedContentEmotion(mblog["text"].toString()));
	map.insert("image", user["profile_image_url"].toString());
	map.insert("fromPlat", mblog["source"].toString());
	map.insert("commentCount", mblog["commentsCount"].toInt());
	map.insert("forwardCount", mblog["repostsCount"].toInt());

	map.insert("forwardcontent", !forward.isEmpty() ? idHelper::FixedContentEmotion(forward["text"].toString()) : "");
	if(!forward.isEmpty())
	{
		pic = forward["thumbnail_pic"].toString();
		map.insert("forwardThumbnailPic", pic);
		pic = forward["original_pic"].toString();
		map.insert("imageAddress_forward", pic);
	}
	else
	{
		map.insert("forwardThumbnailPic", "");
		map.insert("imageAddress_forward", "");
	}
	pic = mblog["thumbnail_pic"].toString();
	map.insert("statusThumbnailPic", pic);
	pic = mblog["original_pic"].toString();
	map.insert("imageAddress_status", pic);


	map.insert("userId", user["id"].toString());
	map.insert("statusId", mblog["id"].toString());
	return true;
}

QString id_accListModel_base::getImageAddress(int type, int index) const
{
	const char *KeyNames[] = {
		"statusThumbnailPic",
		"imageAddress_status",
		"forwardThumbnailPic",
		"imageAddress_forward",
	};
	return GetValue(index, KeyNames[type]).toString();
}

QString id_accListModel_base::GetStatusId(int index) const
{
	return GetValue(index, "statusId").toString();
}
