#include "atmemodel.h"

#include <QDebug>

#include "helper.h"
#include "api.h"

	id_atMeModel::id_atMeModel(QObject *parent)
	: id_accListModel_base(parent)
{
	setObjectName("id_atMeModel");
}

id_atMeModel::~id_atMeModel()
{
	ID_QOBJECT_DESTROY_DBG
}

void id_atMeModel::getAtMeFromModel(int type)
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
	emit getAtMeResult(idAPI::ErrCode_Loading);
	params.insert("page", pn);
	result = idAPI::MyAt(params, &ret);
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
	emit getAtMeResult(idAPI::ErrCode_Success);
	return;

__Error:
	emit getAtMeResult(idAPI::ErrCode_Error);
	return;
}

QString id_atMeModel::getAtMeId(int index) const
{
	return GetValue(index, "statusId").toString();
}

bool id_atMeModel::MakeModelData(QVariantMap &map, const QVariantMap &item)
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
	map.insert("statusId", item["id"].toString());
	return true;
}

ID_SINGLE_INSTANCE_DECL(id_atMeModel)
