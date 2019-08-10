#ifndef _KARIN_API_DEFINES_H
#define _KARIN_API_DEFINES_H

#define M_SCHEME "https:" // http will 302 redirect
#define M_DOMAIN "m.weibo.cn" // mobile h5 api
#define M_HOST M_SCHEME "//" M_DOMAIN

#define M_PROFILE_URL M_HOST "/profile/info" // ?uid=
#define M_COMMENTME_URL M_HOST "/message/mentionsCmt" //?page=1
#define M_ATME_URL M_HOST "/message/mentionsAt" //?page=1
#define M_MESSAGE_URL M_HOST "/message/msglist" //?page=1
#define M_MSGLIST_URL M_HOST "/api/chat/list" //?uid=1721030997&count=1&unfollowing=0
#define M_UPDATE_PROFILE_URL M_HOST "/settingDeal/inforSave" 
/*
gender:m
province:400
city:0
year:1991
month:12
day:23
email:
url:
qq:
msn:
description:ghvghvkhvwqeqqweq
 */
#define M_NEAR_URL M_HOST "/api/lbs/near" //?page=2
#define M_INDEX_URL M_HOST "/api/container/getIndex" //?containerid=230259&openApp=0
// 102803 热门 &since_id=1
// 230259 收藏 &page=2
// 231093_-_selffollowed 朋友 &page=2
// 231016_-_selffans 粉丝 &since_id=1
// 230413{user_id}_-_WEIBO_SECOND_PROFILE_WEIBO 我的 &page=2
// 102803_ctg1_7978_-_ctg1_7978 &page=2
// 搜人 urldecode(100103type=3&q=csol&t=0) &page_type=searchall&page=2
// 搜综合 urldecode(100103type=1&q=csol) &page_type=searchall&page=2
// 话题 containerid=231583&page_type=searchall&page=2
// 话题列表 containerid= urldecode(100103type=1&q=#csol#) &page_type=searchall&page=2
// 其他人的微博 uid=2155084244&type=uid&value=2155084244&containerid=1076032155084244&since_id=123123123
// containerid= urldecode(100103type=38&q=csol&t=0) &page_type=searchall&page=2

#define M_STATUSES_URL M_HOST "/api/statuses/update" // content:1231werwerwrwqeqweqeqwe[爱你][拜拜][抱抱][打脸][哈欠][顶][打脸][打脸][白眼][泪][泪][兔子][紫金草]&st:69122f picId:007BWE8tly1g5la0ebw4oj30rs0ihwik,007BWE8tly1g5la8qxmecj300g00g0hj
#define M_UNREAD_URL M_HOST "/api/remind/unread" //?t=1563860527060

#define M_FOLLOW_URL M_HOST "/api/friendships/create" // post uid=&st=
#define M_UNFOLLOW_URL M_HOST "/api/friendships/destory" // post uid=&st=

#define M_ATTITUDE_URL M_HOST "/api/attitudes/create" // post st=&id=&attitude=heart/*
#define M_UNATTITUDE_URL M_HOST "/api/attitudes/destory" // post st=&id=&attitude=heart/*

#define M_SENDMSG_URL M_HOST "/api/chat/send" // post uid=&content=&st=

#define M_SENDCMT_URL M_HOST "/api/comments/create"
//content:213123 mid:4398060681768761 st:5c6a7a
//referer:https://m.weibo.cn/detail/4398060681768761

#define M_REPOST_URL M_HOST "/api/statuses/repost"
//id:4397973825723331 content:123123123 mid:4397973825723331 st:5c6a7a dualPost=1
//referer:https://m.weibo.cn/compose/repost?id=4397973825723331

#define M_REPLY_URL M_HOST "/api/comments/reply"
//id:4398060681768761 reply:4398062132696589 content:123123123 withReply:1 mid:4398060681768761 cid:4398062132696589 st:5c6a7a
//referer:https://m.weibo.cn/compose/reply?id=4398060681768761&reply=4398062132696589&content=%E5%9B%9E%E5%A4%8D%40Hippo_%E6%9B%BC%E8%81%94%3A&withReply=1 回复@Hippo_曼联: dualPost=1

#define M_STATUSDETAIL_URL M_HOST "/detail/%1" // html
#define M_LONGTEXT_URL M_HOST "/statuses/extend" // ?id=

#define M_COMMENT_URL M_HOST "/comments/hotflow" //?id=4397285225657332&mid=4397285225657332&max_id=138424679598377&max_id_type=0

#define M_SEARCHCONTACT_URL M_HOST "/api/search/atusers" //?keyword=csol&page=2
#define M_CONTACT_URL M_HOST "/api/friendships/friends" //?page=2
#define M_DELSTATUS_URL M_HOST "/profile/delMyblog" // ?mid=&st= POST
#define M_UPLOADPIC_URL M_HOST "/api/statuses/uploadPic" // ?type=json&st=&pic= POST
#define M_DELCOMMENT_URL M_HOST "/comments/destroy" // ?cid=&st= POST

#define M_LOGOUT_URL M_HOST "/logout"

#define M_USER_URL M_HOST "/n/"

#define M_PASSPORT_URL M_SCHEME "//" "passport.weibo.cn"
#define M_REFERER_URL M_PASSPORT_URL "/signin/login?entry=mweibo&res=wel&wm=3349&r=http%3A%2F%2Fm.weibo.cn%2F"
#define M_PAGE_REFERER_URL M_HOST "/login?backURL=https%253A%252F%252Fm.weibo.cn%252F"
#define M_LOGIN_URL M_PASSPORT_URL "/sso/login"

#endif
