#include "api.h"

#include <QDebug>
#include <QUrl>
#include <QDateTime>
#include <QCryptographicHash>
#include "qjson/parser.h"

#include "api_defines.h"
#include "networkconnector.h"
#include "qmlapplicationviewer.h"
#include "utility.h"
#include "id_std.h"

extern QmlApplicationViewer *qml_viewer;

ID_API_DECL(UserProfile)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap header;
	QVariantMap result;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	querys.push_back(qMakePair<QByteArray, QByteArray>("uid", params["uid"].toByteArray()));

	ret = connector.SyncRequest(M_PROFILE_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("profile")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("profile")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(MyComment)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap header;
	QVariantMap result;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	querys.push_back(qMakePair<QByteArray, QByteArray>("page", params["page"].toByteArray()));

	ret = connector.SyncRequest(M_COMMENTME_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("commentme")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("commentme")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(MyAt)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap header;
	QVariantMap result;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	querys.push_back(qMakePair<QByteArray, QByteArray>("page", params["page"].toByteArray()));

	ret = connector.SyncRequest(M_ATME_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("atme")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("atme")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(MyMessage)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap header;
	QVariantMap result;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	querys.push_back(qMakePair<QByteArray, QByteArray>("page", params["page"].toByteArray()));

	ret = connector.SyncRequest(M_MESSAGE_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("message")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("message")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(MessageList)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap header;
	QVariantMap result;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	querys.push_back(qMakePair<QByteArray, QByteArray>("uid", params["uid"].toByteArray()));
	querys.push_back(qMakePair<QByteArray, QByteArray>("count", params["count"].toByteArray()));
	querys.push_back(qMakePair<QByteArray, QByteArray>("unfollowing", params["unfollowing"].toByteArray()));

	ret = connector.SyncRequest(M_MSGLIST_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("msglist")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("msglist")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Index)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap header;
	QVariantMap result;
	QList<QPair<QByteArray, QByteArray> > querys;
	const char *Params[] = {
		"containerid",
		"openApp",
		"since_id", "page",
		"page_type",
		"type",
		"uid", "value"
	};

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	for(int i = 0; i < int(sizeof(Params) / sizeof(const char *)); i++)
	{
		if(params.contains(Params[i]))
			querys.push_back(qMakePair<QByteArray, QByteArray>(Params[i], params[Params[i]].toByteArray()));
	}

	ret = connector.SyncRequest(M_INDEX_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("index")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("index")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(UpdateProfile)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	const char *FormName[] = {
		"gender",
		"province",
		"city",
		"year",
		"month",
		"day",
		"email",
		"url",
		"qq",
		"msn",
		"description"
	};

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	for(int i = 0; i < int(sizeof(FormName) / sizeof(formData[0])); i++)
	{
		if(params.contains(FormName[i]))
			formData.insert(FormName[i], params[FormName[i]]);
	}
	header.insert("referer", M_HOST "/users/" + params["uid"].toByteArray() + "?set=1");
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_UPDATE_PROFILE_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("update_profile")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("update_profile")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(UpdateStatus)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("content", params["content"]);
	formData.insert("st", xsrf_token); 
	if(params.contains("picId"))
		formData.insert("picId", params["picId"]);
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/compose");
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_STATUSES_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("update_status")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("update_status")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(SendMsg)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	QByteArray uid(params["uid"].toByteArray());
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("content", params["content"]);
	formData.insert("uid", uid);
	formData.insert("st", xsrf_token); 
	formData.insert("fileId", QVariant()); 
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/message/chat?uid=" + uid + "&name=msgbox");
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_SENDMSG_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("send_message")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("send_message")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Follow)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));
	QByteArray uid(params["uid"].toByteArray());

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("uid", uid);
	formData.insert("st", xsrf_token);
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/profile/" + uid);
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_FOLLOW_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("follow")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("follow")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Unfollow)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));
	QByteArray uid(params["uid"].toByteArray());

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("uid", uid);
	formData.insert("st", xsrf_token);
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/profile/" + uid);
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_UNFOLLOW_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("unfollow")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("unfollow")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}


ID_API_DECL(Attitude)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("id", params["id"]);
	formData.insert("st", xsrf_token);
	formData.insert("attitude", "heart");
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/");
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_ATTITUDE_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("attitude")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("attitude")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Unattitude)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("id", params["id"]);
	formData.insert("st", xsrf_token);
	formData.insert("attitude", "heart");
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/");
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_UNATTITUDE_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("unattitude")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("unattitude")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(SendCmt)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	QByteArray mid(params["mid"].toByteArray());
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("mid", mid);
	formData.insert("st", xsrf_token);
	formData.insert("content", params["content"]);
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/detail/" + mid);
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_SENDCMT_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("send_comment")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("send_comment")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Reply)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	QByteArray uname(params["uname"].toByteArray());
	QByteArray mid(params["mid"].toByteArray());
	QByteArray cid(params["cid"].toByteArray());

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));
	formData.insert("id", mid);
	formData.insert("mid", mid);
	formData.insert("st", xsrf_token);
	formData.insert("content", params["content"]);
	formData.insert("reply", cid);
	formData.insert("cid", cid);
	formData.insert("withReply", params["withReply"]);
	if(params.contains("dualPost"))
		formData.insert("dualPost", params["dualPost"]);
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/compose/reply?id=" + mid + "&reply=" + cid + "&content=" + QUrl::toPercentEncoding("回复@:") + uname + "&withReply=1");
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_REPLY_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("reply")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("reply")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Repost)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QVariantMap formData;
	QByteArray mid(params["mid"].toByteArray());
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("id", mid);
	formData.insert("mid", mid);
	formData.insert("st", xsrf_token);
	formData.insert("content", params["content"]);
	if(params.contains("dualPost"))
		formData.insert("dualPost", params["dualPost"]);
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/compose/repost?id=" + mid);
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_REPOST_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("repost")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("repost")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(StatusDetail)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap header;
	QVariantMap result;
	QList<QPair<QByteArray, QByteArray> > querys;
	int index;
	int end;
	const char Start[] = "var $render_data = [";
	const char End[] = "][0]";

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	ret = connector.SyncRequest(QString(M_STATUSDETAIL_URL).arg(params["mid"].toString()), querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("status_detail")

		index = data.indexOf(Start);
	ok = false;
	if(index != -1)
	{
		index += strlen(Start);
		end = data.indexOf(End, index);
		if(end != -1)
		{
			data = data.mid(index, end - index);
			json = parser.parse(data, &ok);
		}
	}
	ID_JSON_ERR("status_detail")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(LongText)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap header;
	QVariantMap result;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	querys.push_back(qMakePair<QByteArray, QByteArray>("id", params["mid"].toByteArray()));
	ret = connector.SyncRequest(M_LONGTEXT_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("long_text")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("long_text")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Comment)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	QByteArray mid(params["mid"].toByteArray());

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	querys.push_back(qMakePair<QByteArray, QByteArray>("id", mid));
	querys.push_back(qMakePair<QByteArray, QByteArray>("mid", mid));
	if(params.contains("max_id"))
		querys.push_back(qMakePair<QByteArray, QByteArray>("max_id", params["max_id"].toByteArray()));
	querys.push_back(qMakePair<QByteArray, QByteArray>("max_id_type", params["max_id_type"].toByteArray()));
	ret = connector.SyncRequest(M_COMMENT_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("comment")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("comment")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Unread)
{
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	querys.push_back(qMakePair<QByteArray, QByteArray>("t", params.contains("t") ? params["t"].toByteArray() : QByteArray::number(QDateTime::currentMSecsSinceEpoch())));
	ret = idNetworkConnector::SyncRequest_thread(M_UNREAD_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("unread")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("unread")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Contact)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	querys.push_back(qMakePair<QByteArray, QByteArray>("page", params["page"].toByteArray()));

	ret = connector.SyncRequest(M_CONTACT_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("contact")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("contact")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(SearchContact)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	querys.push_back(qMakePair<QByteArray, QByteArray>("keyword", params["keyword"].toByteArray()));
	querys.push_back(qMakePair<QByteArray, QByteArray>("page", params["page"].toByteArray()));

	ret = connector.SyncRequest(M_SEARCHCONTACT_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("search_contact")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("search_contact")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(DelStatus)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QVariantMap formData;
	QList<QPair<QByteArray, QByteArray> > querys;
	QByteArray mid(params["mid"].toByteArray());
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("mid", mid);
	formData.insert("st", xsrf_token);
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/detail/" + mid);
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_DELSTATUS_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("del_status")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("del_status")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(DelComment)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QVariantMap formData;
	QList<QPair<QByteArray, QByteArray> > querys;
	QByteArray mid(params["mid"].toByteArray());
	QByteArray cid(params["cid"].toByteArray());
	QVariant xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN"));

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("cid", cid);
	formData.insert("st", xsrf_token);
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/detail/" + mid + "?cid=" + cid);
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness

	ret = connector.SyncRequest(M_DELCOMMENT_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("del_comment")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("del_comment")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(UploadPic)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QByteArray formData;
	QList<QPair<QByteArray, QByteArray> > querys;
	QByteArray xsrf_token(idUtility::Instance()->GetCookie(M_HOST, "XSRF-TOKEN").toByteArray());
	const QByteArray boundaryValue(QCryptographicHash::hash(QByteArray().append(QByteArray::number(qulonglong((QDateTime::currentMSecsSinceEpoch() ^ qrand()) ^ 2014)).toBase64()), QCryptographicHash::Md5).toHex().mid(8, 16));
	const QByteArray boundary("----WebKitFormBoundary" + boundaryValue);

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	header.insert("x-xsrf-token", xsrf_token);
	header.insert("referer", M_HOST "/compose/");
	header.insert("x-requested-with", "XMLHttpRequest"); // not ness
	header.insert("origin", M_HOST); // not ness
	header.insert("Content-Type", "multipart/form-data; boundary=" + boundary);

	formData
		.append("--")
		.append(boundary)
		.append("\r\n")
		.append("Content-Disposition: form-data; name=\"type\"")
		.append("\r\n")
		.append("\r\n")
		.append(params["type"].toByteArray())
		.append("\r\n")

		.append("--")
		.append(boundary)
		.append("\r\n")
		.append("Content-Disposition: form-data; name=\"pic\"; filename=\"" + params["filename"].toByteArray() + "\"")
		.append("\r\n")
		.append("Content-Type: " + params["filetype"].toByteArray())
		.append("\r\n")
		.append("\r\n")
		.append(params["filedata"].toByteArray())
		.append("\r\n")

		.append("--")
		.append(boundary)
		.append("\r\n")
		.append("Content-Disposition: form-data; name=\"st\"")
		.append("\r\n")
		.append("\r\n")
		.append(xsrf_token)
		.append("\r\n")

		.append("--")
		.append(boundary)
		.append("--")
		;

	//qDebug() << formData;
	ret = connector.SyncRequest(M_UPLOADPIC_URL, querys, formData, idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("upload_pic")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("upload_pic")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Logout)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;
	Q_UNUSED(params)

	ret = -1;

	connector.SetEngine(qml_viewer->engine());

	ret = connector.SyncRequest(M_LOGOUT_URL, querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data);
	ID_REQ_ERR("logout")

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(Login)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QJson::Parser parser;
	bool ok;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QVariantMap formData;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());
	formData.insert("username", params["username"]);
	formData.insert("password", params["password"]);
	formData.insert("savestate", params["savestate"]);
	formData.insert("r", "http://m.weibo.cn/");
	formData.insert("ec", 0);
	formData.insert("pagerefer", M_PAGE_REFERER_URL);
	formData.insert("entry", "mweibo");
	formData.insert("mainpageflag", 1);

	header.insert("Content-Type", "application/x-www-form-urlencoded");
	header.insert("Accept", "application/json, text/plain, */*");
	header.insert("Accept-Encoding", "gzip, deflate, br");
	header.insert("Accept-Language", "zh-CN,zh;q=0.8,zh-TW;q=0.6,en;q=0.4");
	header.insert("Connection", "keep-alive");
	header.insert("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36");
	header.insert("X-Requested-With", "XMLHttpRequest");
	header.insert("Host", "m.weibo.cn");
	header.insert("Origin", "https://m.weibo.cn");
	header.insert("Referer", "https://m.weibo.cn/compose");
	header["Host"] = "passport.weibo.cn";
	header["Origin"] = "https://passport.weibo.cn";
	header["Referer"] = M_REFERER_URL;

	ret = connector.SyncRequest(M_LOGIN_URL, querys, idNetworkConnector::MakePostData(formData), idNetworkConnector::Connect_Post, header, &data);
	ID_REQ_ERR("login_mobile")
		json = parser.parse(data, &ok);
	ID_JSON_ERR("login_mobile")

		result = json.toMap();

__Error:
	if(r)
		*r = ret;
	return result;
}

ID_API_DECL(UserId)
{
	idNetworkConnector connector;
	int ret;
	QByteArray data;
	QVariant json;
	QVariantMap result;
	QVariantMap header;
	QList<QPair<QByteArray, QByteArray> > querys;

	ret = -1;

	connector.SetEngine(qml_viewer->engine());

	ret = connector.SyncRequest(M_USER_URL + params["name"].toString(), querys, QByteArray(), idNetworkConnector::Connect_Get, header, &data, false);
	ID_REQ_ERR("user_id")
		result.insert("url", data);

__Error:
	if(r)
		*r = ret;
	return result;
}
