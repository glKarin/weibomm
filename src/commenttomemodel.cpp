#include "commenttomemodel.h"

#include <QDebug>

#include "api.h"
#include "helper.h"

	id_commentToMeModel::id_commentToMeModel(QObject *parent)
: id_accListModel_base(parent)
{
	setObjectName("id_commentToMeModel");
}

id_commentToMeModel::~id_commentToMeModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_commentToMeModel::deleteItemByStatusId(const QString &statusID)
{
	int i;
	int len;
	int ret;
	QVariantMap result;
	QVariantMap params;

//#warning unimplement id_commentToMeModel::deleteItemByStatusId()
	//qWarning() << QString("[Warning]: delete comment to me is unimplement -> %1::%2(%3)").arg(objectName()).arg(__func__).arg(statusID);

	emit getCommentToMeResult(idAPI::ErrCode_Loading);
	params.insert("cid", statusID);
	result = idAPI::DelComment(params, &ret);
	if(ret != 0 && result["ok"].toInt() == 0)
	{
		qDebug() << result["msg"].toString();
	}

	len = m_list.size();
	for(i = 0; i < len; i++)
	{
		if(m_list[i]["statusId_comment"].toString() == statusID)
		{
			Remove(i);
			return;
		}
	}

}

void id_commentToMeModel::getSinaCommentToMeFromModel(int type)
{
	int ret;
	QVariantMap result;
	QVariantMap params;
	QVariantList list;
	int pn;
	int c;

	c = 0;
	if(type == idAPI::Type_Next)
	{
		if(!m_hasMore)
			return;
		pn = m_pn + 1;
	}
	else
	{
		removeAllItemList();
		pn = 1;
		SetHasNext(true);
	}
	emit getCommentToMeResult(idAPI::ErrCode_Loading);
	params.insert("page", pn);
	result = idAPI::MyComment(params, &ret);
	if(ret != 0)
	{
		goto __Error;
	}
	if(result["ok"].toInt())
	{
		list = result["data"].toList();
		if(list.isEmpty())
		{
			SetHasNext(false);
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
		SetPn(pn);
		SetReflashCount(c);
		SetReflashTime();
	}
	else
	{
		qDebug() << result["msg"].toString();
		goto __Error;
	}

__Success:
	emit getCommentToMeResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getCommentToMeResult(idAPI::ErrCode_Error);
	return;
}

QString id_commentToMeModel::getCommentOriginalId(int index) const
{
	return idQmlModel_base::GetValue(index, "statusId").toString();
}

QString id_commentToMeModel::getCommentUserId(int index) const
{
	return GetValue(index, "userId").toString();
}

QString id_commentToMeModel::getCommentId(int index) const
{
	return idQmlModel_base::GetValue(index, "statusId_comment").toString();
}

QString id_commentToMeModel::getCommentRetweetedId(int index) const
{
	return idQmlModel_base::GetValue(index, "statusId").toString();
}

QString id_commentToMeModel::getCommentUserName(int index) const
{
	return idQmlModel_base::GetValue(index, "userNickName").toString();
}

bool id_commentToMeModel::MakeModelData(QVariantMap &map, const QVariantMap &item)
{
	QString pic;
	QVariantMap forward = item["status"].toMap();
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


	pic = item["thumbnail_pic"].toString();
	map.insert("statusThumbnailPic", pic);
	pic = item["original_pic"].toString();
	map.insert("imageAddress_status", pic);

	map.insert("userId", user["id"].toString());
	map.insert("statusId_comment", item["id"].toString());
	map.insert("statusId", !forward.isEmpty() ? forward["id"].toString() : "");
	return true;
}

ID_SINGLE_INSTANCE_DECL(id_commentToMeModel)
