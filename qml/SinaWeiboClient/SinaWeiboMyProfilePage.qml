import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as SinaWeiboErrorCode

Page {
    id:myProfileContainer
    property bool is1stactive: true
    anchors.fill:parent

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    //for its whole font pointSize
    property int contextSize: 16

    function activepage(){
        funcContainer.hometabindex = 2;
        if(myProfileContainer.is1stactive){
            myProfileContainer.is1stactive = false;
            myProfileContainer.refresh();
        }
    }

    function refresh(){
        profile.getSinaWeiboProfile(loginModel.userID, "");
    }
    onVisibleChanged: {
        if(visible) {
            profile.connectModel();
        }
        else {
            profile.disConnectModel();
        }
    }
    //title
    AccTitleBar{
        id: titleBar
        width: parent.width
        height: 65
        title: "我的资料"
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
                    myProfileContainer.refresh();
                }
            }
        }
    }

    //user info
    AccIntroductoryBar {
        id: introductoryBar
        anchors.left: parent.left
        anchors.top: titleBar.bottom
        limitWord: if(parent.width > parent.height) {false} else {true}
        pressColor: "transparent"
        hasMark: false
        textX: 90
        textY: 30
        vipWidth: 18
        vipHeight: 19
        isVip: profile.isVip
        vipPath: "../images/icon_VIP.png"

        width: parent.width
        height: 80
        fontSize: 24

        hasIcon: true
        bgPath: "../images/bg_item_user.png"
        iconPath: profile.userIcon
        content: profile.nick;

        Button{
            id: eidtbutton
            width: 190
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "编辑"
            visible: false
            onClicked: {
                listPage.changePage(4);
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
             contentHeight: basicinfo.height + detailcinfo.height + 60 + favoriteInfo.height + 20
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
                    text: profile.address
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
                    text: profile.account;
                    color: "#282828"
                    font.pixelSize: basicinfo.textsize
                    wrapMode:Text.WrapAnywhere
                }
            }

            //
            Rectangle{
                id: detailcinfo
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
                    content: profile.attention > 0 ? profile.attention : 0;
                    textSize:basicinfo.textsize
                    onItemClicked:{
                        funcContainer.myfansId = loginModel.userID;
                        funcContainer.senderScreenName = profile.nick;
                        funcContainer.listContainerTabIndex = 4;
                        listPage.changePage(41);
                    }
                }
                SinaWeiboProfileItem{id:weibo; anchtype: 2;
                    title: "微博"
                    content: profile.weibo > 0 ? profile.weibo : 0
                    textSize:basicinfo.textsize
                    onItemClicked:{
                        funcContainer.myfansId = loginModel.userID;
                        funcContainer.senderScreenName = profile.nick;
                        funcContainer.listContainerTabIndex = 0;
                        listPage.changePage(41);
                    }
                }
                SinaWeiboProfileItem{
                    id:fans; anchtype: 3;
                    title: "粉丝";
                    content: profile.funs > 0 ? profile.funs : 0
                    textSize:basicinfo.textsize
                    onItemClicked:{
                        funcContainer.myfansId = loginModel.userID;
                        funcContainer.senderScreenName = profile.nick;
                        funcContainer.listContainerTabIndex = 3;
                        listPage.changePage(41);
                    }
                    Image {
                        visible: newMsgNotification.followCount > 0
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -20
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.horizontalCenterOffset:  50
                        source: "images/Digital_Tips.png"

                        Text{
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: {
                                if(newMsgNotification.followCount < 100) {
                                    return newMsgNotification.followCount;
                                }
                                else {
                                    return "..."
                                }
                            }
                        }
                    }
                }
                SinaWeiboProfileItem
                {id:favorite;anchtype: 4;
                    title: "话题"
                    content: ""
                    textSize:basicinfo.textsize
                    onItemClicked:{
                        funcContainer.myfansId = loginModel.userID;
                        funcContainer.senderScreenName = profile.nick;
                        funcContainer.listContainerTabIndex = 1;
                        listPage.changePage(41);
                    }
                }
            }

            Rectangle{
                id:favoriteInfo
                anchors.top: detailcinfo.bottom; anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                border.color: "#e6e7e7"
                border.width: 1
                width: parent.width - 20
                height: 40 + favorText.paintedHeight
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
                    id: favorText
                    anchors.left: parent.left; anchors.leftMargin: 10
                    anchors.top: parent.top; anchors.topMargin: 20
                    text: "收藏 "
                    color: "#282828"
                    font.pixelSize: basicinfo.textsize
                }
                Text {
                    id: favorNum
                    anchors.top: parent.top; anchors.topMargin: 20
                    anchors.left: favorText.right; anchors.leftMargin: 5
                    width: parent.width - favorText.width - 5 - 10
                    text: "("+ profile.topic + ")"
                    color: "#6db339"
                    font.pixelSize: basicinfo.textsize
                    wrapMode:Text.WrapAnywhere
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        funcContainer.myfansId = loginModel.userID;
                        funcContainer.senderScreenName = profile.nick;
                        funcContainer.listContainerTabIndex = 2;
                        listPage.changePage(41);
                    }
                }
            }
        }
    }

    Component.onDestruction:{
        console.log("Component.onDestruction");
        if(null === profile){
            console.log("=======profile has been deleted========");
        }
        else{
            profile.readyFinishProfile.disconnect(myProfileContainer.initialProfile);
        }
    }

    function initialProfile( errCode )
    {
        console.log("SinaWeiboMyProfilePage.qml errCode:", errCode)
        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else if(200 == errCode){
            eidtbutton.visible = true;
            funcContainer.makeWaitingDialogVisible(false);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);
            funcContainer.showPopup(SinaWeiboErrorCode.getErrorInfo(errCode));
        }
    }

    Component.onCompleted:{
        console.log("=====Component.onCompleted=====");
        profile.readyFinishProfile.connect(myProfileContainer.initialProfile);
    }
}


