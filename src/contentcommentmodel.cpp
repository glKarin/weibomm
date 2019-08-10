#include "contentcommentmodel.h"

#include <QDebug>

#include "api.h"
#include "helper.h"

	id_contentCommentModel::id_contentCommentModel(QObject *parent)
	: id_accListModel_base(parent)
{
	setObjectName("id_contentCommentModel");
}

id_contentCommentModel::~id_contentCommentModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_contentCommentModel::getContentCommentFromModel(const QString &statusId, int type)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	QVariantMap data;
	int c;

	c = 0;
	if(type == idAPI::Type_Next)
	{
		if(!m_hasMore)
			return;
		params.insert("max_id", m_maxId);
	}
	else
	{
		removeAllItemList();
		SetMaxId();
		SetHasNext(true);
		SetPn(0);
	}
	emit getContentCommentResult(idAPI::ErrCode_Loading);
	params.insert("mid", statusId);
	if(!m_maxId.isEmpty())
		params.insert("max_id", m_maxId);
	params.insert("max_id_type", 0);
	result = idAPI::Comment(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}
	if(result["ok"].toInt())
	{
		data = result["data"].toMap();
		list = data["data"].toList();
		SetMaxId(data["max_id"].toString());
		if(m_maxId.isEmpty())
			SetHasNext(false);
		else
			SetPn(m_pn + 1);
		if(list.isEmpty())
		{
			goto __Success;
		}

		ID_CONST_FOREACH(QVariantList, list)
		{
			QVariantMap map;
			QVariantMap item = itor->toMap();
			if(this->MakeModelData(map, item))
			{
				Push_back(map);
				c++;
			}
		}
		SetReflashCount(c);
		SetReflashTime();
	}
	else
	{
		qDebug() << result["msg"].toString();
		goto __Error;
	}

__Success:
	emit getContentCommentResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getContentCommentResult(idAPI::ErrCode_Error);
	return;
}

void id_contentCommentModel::SetMaxId(const QString &id)
{
	if(m_maxId != id)
		m_maxId = id;
	if(m_maxId == "0")
		m_maxId.clear();
}

bool id_contentCommentModel::MakeModelData(QVariantMap &map, const QVariantMap &item)
{
	QString pic;
	QVariantMap user = item["user"].toMap();

	map.clear();
	map.insert("isVip", user["verified"].toBool());
	map.insert("userNickName", user["screen_name"].toString());
	map.insert("untilTime", item["created_at"].toString());
	map.insert("hasPic", item["pic_num"].toInt());
	map.insert("hasMap", item["weibo_position"].toInt());
	map.insert("weibocontent", idHelper::FixedContentEmotion(item["text"].toString()));
	map.insert("image", user["profile_image_url"].toString());
	map.insert("fromPlat", item["source"].toString());
	map.insert("commentCount", item["commentsCount"].toInt());
	map.insert("forwardCount", item["repostsCount"].toInt());

	map.insert("forwardcontent", "");
	map.insert("forwardThumbnailPic", "");
	map.insert("imageAddress_forward", "");

	pic = item["thumbnail_pic"].toString();
	map.insert("statusThumbnailPic", pic);
	pic = item["original_pic"].toString();
	map.insert("imageAddress_status", pic);

	map.insert("userId", user["id"].toString());
	map.insert("statusId", item["id"].toString());
	return true;
}

ID_SINGLE_INSTANCE_DECL(id_contentCommentModel)
