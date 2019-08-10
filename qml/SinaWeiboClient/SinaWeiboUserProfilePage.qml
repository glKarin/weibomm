import QtQuick 1.1

import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as SinaWeiboErrorCode
import SinaWeiboTypeLib 1.0

Page {
    id:userProfileContainer
    anchors.fill:parent
    property bool isAttention
    property bool isFollowedBy
    property bool isUserCorrect: true

    //it is user ID
    property string userId: funcContainer.userIDInMyProfilePage
    property string user : funcContainer.userNameInProfilePage

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    function refresh(){
        profileModel.getSinaWeiboProfile(userId, user);
    }

    onVisibleChanged: {
        if(visible) {
            profileModel.connectModel();
        }
        else {
            profileModel.disConnectModel();
        }
    }

    WeiboProfileModel{
        id: profileModel
        onReadyFinishProfile:{userProfileContainer.initialProfile(errCode)}
        onReadyFinishAttention: {userProfileContainer.attention(errCode, isattend, isfollowed)}
        onCreateOrDestroyAttention: {userProfileContainer.attentionShip(errCode)}
    }

    //title
    AccTitleBar{
        id: titleBar
        width: parent.width
        height: 65
        title: "资料"
        //textOffset: 60
        anchors.top: parent.top
        bgsource: "../images/restitlebg_green.png"

        Image {
            id: name
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 20
            source: changmsgbut.pressed? "images/refresh_press.png":"images/refresh.png"
            MouseArea{
                id: changmsgbut
                anchors.fill: parent
                onClicked: {
                    userProfileContainer.refresh();
                }
            }
        }
    }

    //user info
    AccIntroductoryBar {
        id: introductoryBar
        anchors.left: parent.left
        anchors.top: titleBar.bottom
        limitWord: (parent.width > parent.height) ? false : true
        pressColor: "transparent"
        hasMark: false
        textX: 90
        textY: 30
        vipWidth: 18
        vipHeight: 19
        isVip: profileModel.isVip
        vipPath: "../images/icon_VIP.png"

        width: parent.width
        height: 80
        fontSize: 24

        hasIcon: true
        bgPath: "../images/bg_item_user.png"
        iconPath: profileModel.userIcon
        content: profileModel.nick;

        Button{
            id: attentionButton
            width: 190
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            iconSource: if(isFollowedBy && isAttention) {"images/Cancel attention.png"} else{ "" }
            visible: attentionButton.text=="" ? false : true
            onClicked: {
                if(isAttention)
                {
                    profileModel.destroyAttentionShip(userId, user);
                    console.log(userId+",,,,,," +user)
                }
                else
                {
                    profileModel.createAttentionShip(userId, user);
                    console.log(userId+",,,,,," +user)
                }
            }
        }
    }

    Item{
        anchors.top: introductoryBar.bottom
        width: parent.width
        height: parent.height - titleBar .height - introductoryBar.height

        Flickable {
             id: flick
             anchors.fill: parent
             contentWidth: parent.width
             contentHeight: basicinfo.height + detailcinfo.height + 60
             flickableDirection: Flickable.VerticalFlick
             clip: true

            Rectangle{
                id: basicinfo
                property int textsize: 26
                anchors.top: parent.top; anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                border.color: "#e6e7e7"
                border.width: 1
                width: parent.width - 20
                height: 20*4
                        + (address.height > addresscontent.height ? address.height : addresscontent.height)
                        + (intro.height > introcontent.height ?  intro.height : introcontent.height)
                radius: 20
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#ffffff" }
                    GradientStop { position: 0.125; color: "#fcfcfc" }
                    GradientStop { position: 0.25; color: "#f5f5f5" }
                    GradientStop { position: 0.75; color: "#f5f5f5" }
                    GradientStop { position: 0.875; color: "#fcfcfc" }
                    GradientStop { position: 1.0; color: "#ffffff" }
                }

                Text {
                    id: address
                    anchors.left: parent.left; anchors.leftMargin: 10
                    anchors.top: parent.top; anchors.topMargin: 20
                    text: "地址: "
                    color: "#6db339"
                    font.pixelSize: basicinfo.textsize
                }
                Text {
                    id: addresscontent
                    anchors.top: parent.top; anchors.topMargin: 20
                    anchors.left: address.right; anchors.leftMargin: 5
                    width: parent.width - address.width - 5 - 10
                    text: profileModel.address
                    color: "#282828"
                    font.pixelSize: basicinfo.textsize
                    wrapMode:Text.WrapAnywhere
                }

                //Line
                Rectangle{
                    id: line
                    anchors.top: address.height > addresscontent.height ? address.bottom : addresscontent.bottom
                    anchors.topMargin: 20
                    width: parent.width
                    height: 1
                    color: "#dcdcdc"
                }

                Text {
                    id: intro
                    anchors.left: parent.left; anchors.leftMargin: 10
                    anchors.top: line.bottom; anchors.topMargin: 20
                    text: "介绍: "
                    color: "#6db339"
                    font.pixelSize: basicinfo.textsize
                }
                Text {
                    id: introcontent
                    width: addresscontent.width
                    anchors.top: line.bottom; anchors.topMargin: 20
                    anchors.left: intro.right; anchors.leftMargin: 5
                    text: profileModel.account;
                    color: "#282828"
                    font.pixelSize: basicinfo.textsize
                    wrapMode:Text.WrapAnywhere
                }
            }

            //
            Rectangle{
                id: detailcinfo
                visible: userProfileContainer.isUserCorrect
                anchors.top: basicinfo.bottom; anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                border.color: "#e6e7e7"
                border.width: 1
                width: parent.width - 20
                height: 160
                radius: 20
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#ffffff" }
                    GradientStop { position: 0.125; color: "#fcfcfc" }
                    GradientStop { position: 0.25; color: "#f5f5f5" }
                    GradientStop { position: 0.75; color: "#f5f5f5" }
                    GradientStop { position: 0.875; color: "#fcfcfc" }
                    GradientStop { position: 1.0; color: "#ffffff" }
                }
                //Line
                Rectangle{
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 1
                    color: "#dcdcdc"
                }
                Rectangle{
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 1
                    height: parent.height
                    color: "#dcdcdc"
                }
                SinaWeiboProfileItem{id:follow; anchtype: 1; title: "关注";
                    content: profileModel.attention;
                    textSize:basicinfo.textsize
                    onItemClicked:{
                        funcContainer.myfansId = userProfileContainer.userId;
                        funcContainer.senderScreenName = profileModel.nick;
                        funcContainer.listContainerTabIndex = 4;
                        listPage.changePage(40);
                    }
                }
                SinaWeiboProfileItem{id:weibo; anchtype: 2;
                    title: "微博"
                    content: profileModel.weibo
                    textSize:basicinfo.textsize
                    onItemClicked:{
                        funcContainer.myfansId = userProfileContainer.userId;
                        funcContainer.senderScreenName = profileModel.nick;
                        funcContainer.listContainerTabIndex = 0;
                        listPage.changePage(40);
                    }
                }
                SinaWeiboProfileItem{
                    id:fans; anchtype: 3;
                    title: "粉丝";
                    content: profileModel.funs
                    textSize:basicinfo.textsize
                    onItemClicked:{
                        funcContainer.myfansId = userProfileContainer.userId;
                        funcContainer.senderScreenName = profileModel.nick;
                        funcContainer.listContainerTabIndex = 3;
                        listPage.changePage(40);
                    }
                }
                SinaWeiboProfileItem
                {id:favorite;anchtype: 4;
                    title: "话题"
                    content: ""
                    textSize:basicinfo.textsize
                    onItemClicked:{
                        funcContainer.myfansId = userProfileContainer.userId;
                        funcContainer.senderScreenName = profileModel.nick;
                        funcContainer.listContainerTabIndex = 1;
                        listPage.changePage(40);
                    }
                }
            }
        }
    }

    //tool bar without delete button
    ToolBarLayout
    {
        id: toolbar
        ToolIcon
        {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: {listPage.viewBack();}
        }

        ToolIcon {
            iconSource: "images/message.png";
            visible: userProfileContainer.isUserCorrect
            onClicked: {
                funcContainer.senderScreenName = profileModel.nick;
                listPage.changePage(25);
            }
        }
    }

    tools: toolbar

    QueryDialog {
        id: userprofilepopup
        acceptButtonText: "确定"
        onAccepted: {
            listPage.viewBack();
        }
        onRejected:{
            listPage.viewBack();
        }
    }

    function initialProfile( errCode )
    {
        console.log("SinaWeiboMyProfilePage.qml errCode:", errCode)
        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else if(200 == errCode)
        {
            if(profileModel.userId != loginModel.userID)
            {
                userProfileContainer.userId = profileModel.userId;
                profileModel.getAttention(userId, user);
            }
            else
            {
                funcContainer.makeWaitingDialogVisible(false);
            }
            funcContainer.userIDInMyProfilePage=profileModel.userId;
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);
            if(40023 == errCode)
            {
                userProfileContainer.isUserCorrect = false;
                userprofilepopup.message = SinaWeiboErrorCode.getErrorInfo(errCode);
                userprofilepopup.open();
            }
            else
            {
                funcContainer.showPopup(SinaWeiboErrorCode.getErrorInfo(errCode));
            }
        }
    }

    //get whether it is attended.
    function attention(errCode, isattend, isfollowed)
    {
        funcContainer.makeWaitingDialogVisible(false);
        if(200 == errCode){
            isAttention = isattend;
            isFollowedBy = isfollowed;
            if(isAttention) {
                attentionButton.text= "取消关注";
            }
            else
                attentionButton.text= "关注";


            console.log("isAttention  "+ isAttention);
        }
        else{
            funcContainer.showPopup(SinaWeiboErrorCode.getErrorInfo(errCode));
        }
    }

    //the slot of changing the attention ship
    function attentionShip(errCode)
    {
        funcContainer.makeWaitingDialogVisible(false);
        if(200 == errCode)
        {
            isAttention = !isAttention;
            if(isAttention)
                attentionButton.text= "取消关注";
            else
                attentionButton.text= "关注";
//            if(1 == viewId)
//                profileModel.getAttention(userId, user);
        }
        else
        {
            funcContainer.showPopup(SinaWeiboErrorCode.getErrorInfo(errCode));
        }
        console.log(isAttention);
    }

    Component.onCompleted:{
        console.log("=====Component.onCompleted=====");
        userProfileContainer.refresh();
    }
}


