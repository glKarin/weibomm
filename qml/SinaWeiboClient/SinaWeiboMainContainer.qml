import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "SinaWeiboErrorCode.js" as QMLCommonMethod
import "controls"


Page{
//Rectangle {
    id: mainContainer
    property int itemheight: mainContainer.height - tools.height
    property int itemwidth: mainContainer.width
    property int msgCount: 0
    property int followCount: 0

    property variant currentPage
    property bool needAddPageToList: true

    property bool isFirstTime: true

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    tools: ToolBarLayout {
        ToolIcon {
            width: parent.width/5
            id: editIcon
            iconSource: "images/icon_edit.png";
            onClicked: {
                console.log("Tool bar onClicked--new blog");
                listPage.changePage(11);
            }
        }

        ButtonRow {
            anchors.left: editIcon.right
            anchors.right: parent.right
            style: TabButtonStyle { }
            TabButton {
                tab: homepage
                iconSource : "images/icon_home.png";
                Image {
                    id: mewblogindicator
                    visible: false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset:  10
                    source: "images/icon_new.png"
                }
            }
            TabButton {
                tab: msgpage
                iconSource : "images/icon_message.png";
                Image {
                    id: mewmsgindicator
                    visible: msgCount > 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset:  10
                    source: "images/Digital_Tips.png"

                    Text{
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter

                        text: {
                            if(msgCount < 100) {
                                return msgCount;
                            }
                            else {
                                return "..."
                            }
                        }
                    }
                }
            }
            TabButton {
                tab: myprofilepage
                iconSource : "images/icon_user.png";

                Image {
                    visible: followCount > 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset:  10
                    source: "images/Digital_Tips.png"

                    Text{
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter

                        text: {
                            if(followCount < 100) {
                                return followCount;
                            }
                            else {
                                return "..."
                            }
                        }
                    }
                }
            }

            TabButton {
                tab: morepage
                iconSource : "images/more.png";
            }
        }
    }

    TabGroup {
        id: tabGroup
        currentTab: homepage
        onCurrentTabChanged:{
            console.log("onCurrentTabChanged");
            console.log("funcContainer.needRefresh,funcContainer.needRefreshMsg", funcContainer.needRefresh,funcContainer.needRefreshMsg);
            if(funcContainer.needRefresh || funcContainer.needRefreshMsg) {
                msgpage.is1stactive = true;
                msgpage.isComment1st = true;
                msgpage.isMessage1st = true;
                msgpage.activeFirstTab();

                myprofilepage.is1stactive = true;

                funcContainer.needRefreshMsg = false;
            }

            currentTab.activepage();
        }

        SinaWeiboFirstPage{
            id: homepage
            width: itemwidth
            height: itemheight
        }

        SinaWeiboMsgPage{
            id: msgpage
            width: itemwidth
            height: itemheight
        }

        SinaWeiboMyProfilePage{
            id: myprofilepage
            width: itemwidth
            height: itemheight
        }

        SinaWeiboMorePage{
            id: morepage
            width: itemwidth
            height: itemheight
        }
    }

    onVisibleChanged: {
        console.log("funcContainer.hometabindex = ", funcContainer.hometabindex);
        if (0 == funcContainer.hometabindex){

            if(tabGroup.currentTab == homepage){
                console.log("=====tabGroup.currentTab == homepage====");
                if(funcContainer.needRefresh || funcContainer.needRefreshMsg) {
                    msgpage.is1stactive = true;
                    msgpage.isComment1st = true;
                    msgpage.isMessage1st = true;
                    msgpage.activeFirstTab();

                    myprofilepage.is1stactive = true;

                    funcContainer.needRefreshMsg = true;
                }

                tabGroup.currentTab.activepage();
            }
            else{
                console.log("=====tabGroup.currentTab !!!!= homepage====");
                tabGroup.currentTab = homepage;
            }
        }
        else if(1 == funcContainer.hometabindex){
            tabGroup.currentTab = msgpage;
        }
        else if(2 == funcContainer.hometabindex){
            tabGroup.currentTab = myprofilepage;
        }
        else if(3 == funcContainer.hometabindex){
            tabGroup.currentTab = morepage;
        }
    }

    function setNewBlogIndicator(){
        mewblogindicator.visible = newMsgNotification.isNewStatus;
    }

    function setCommentCount(){
        msgCount = newMsgNotification.commentCount + newMsgNotification.mentionCount + newMsgNotification.privateMsgCount;
    }
    function setMentionCount(){
        msgCount = newMsgNotification.commentCount + newMsgNotification.mentionCount + newMsgNotification.privateMsgCount;
    }
    function setPrivateMsgCount(){
        msgCount = newMsgNotification.commentCount + newMsgNotification.mentionCount + newMsgNotification.privateMsgCount;
    }
    function setFollowCount(){
        followCount = newMsgNotification.followCount;
    }

    Component.onCompleted:
    {
//        funcContainer.showStatusBar = true;
        newMsgNotification.newStatusChanged.connect(mainContainer.setNewBlogIndicator);
        newMsgNotification.commentChanged.connect(mainContainer.setCommentCount);
        newMsgNotification.mentionChanged.connect(mainContainer.setMentionCount);
        newMsgNotification.privateMsgChanged.connect(mainContainer.setPrivateMsgCount);
        newMsgNotification.followCountChanged.connect(mainContainer.setFollowCount);

        loginModel.userIDChanged.connect(mainContainer.currentUserChanged);

        //loginModel.getloginResult.connect(mainContainer.loginFinished);
        accountModel.loginFinish.connect(mainContainer.loginFinished);

        if(accountModel.getAccountCount() != 0 && funcContainer.logined == false) {
            //loginModel.login(funcContainer.loginName, funcContainer.loginPw);
            accountModel.login();
        }
    }

    Component.onDestruction:{
        if(null === newMsgNotification){
            console.log("=======newMsgNotification has been deleted========");
        }
        else{
            newMsgNotification.newStatusChanged.disconnect(mainContainer.setNewBlogIndicator);
            newMsgNotification.commentChanged.disconnect(mainContainer.setCommentCount);
            newMsgNotification.mentionChanged.disconnect(mainContainer.setMentionCount);
            newMsgNotification.privateMsgChanged.disconnect(mainContainer.setPrivateMsgCount);
            newMsgNotification.followCountChanged.connect(mainContainer.setFollowCount);
        }

        if(null === loginModel){
            console.log("=======loginModel has been deleted========");
        }
        else{
            loginModel.getloginResult.disconnect(mainContainer.loginFinished)
            loginModel.userIDChanged.disconnect(mainContainer.currentUserChanged);
        }

        if(null === accountModel){
            console.log("=======accountModel has been deleted========");
        }
        else{
            accountModel.loginFinish.disconnect(mainContainer.loginFinished);
        }
    }

    function currentUserChanged(){
        firstPageModel.removeAllItemList();
        atMeModel.removeAllItemList();
        commentToMeModel.removeAllItemList();
        messageCenterModel.removeAllItemList();
        profile.initializeData();
    }

    function loginFinished(errCode) {
        console.log("loginFinished_XOuth" + errCode)
        if(errCode == -1) {
            makeWaitingVisible(true);
        }
        else {
            makeWaitingVisible(false);

            if(errCode == 200){
                funcContainer.logined = true;
                newMsgNotification.start();
                firstPageModel.getSinaContentFromModel(0);

//                if(funcContainer.needRelogin) {
//                    funcContainer.needRelogin = false;
//                }
            }
            else {
                if(errCode == 403 || errCode == 202) {
                    popup_error.popupContent = "账号或密码错误！"
                    popup_error.open();
                }
                else if(errCode == 99 || errCode == 3) {
                    popup_networkError.popupContent = "网络异常，请重试！";
                    popup_networkError.open();
                }
                else {
                    popup_error.popupContent = QMLCommonMethod.getErrorInfo(errCode);
                    popup_error.open();
                }
            }
        }
    }

    function makeWaitingVisible(type){
        if(type){
            process.start();
            funcContainer.showWaitingDialog(true);
        }
        else{
            process.stop();
            funcContainer.showWaitingDialog(false);
        }
    }

    Timer {
        id: process
        interval: 45000; running: false; repeat: false;
        onTriggered: {
            process.running = false;
            makeWaitingVisible(false);
            popup_networkError.popupContent = "操作超时！";
            popup_networkError.open();
        }
    }

    QueryDialog {
        id: popup_error

        property string popupContent

        message: popupContent
        acceptButtonText: "确定"

        onAccepted:{
            listPage.changePage(1);
        }

        onRejected: {
            listPage.changePage(1);
        }
    }

    QueryDialog {
        id: popup_networkError
        property string popupContent

        message: popupContent
        acceptButtonText: "确定"

        onAccepted:{
            if(accountModel.getAccountCount() != 0 && funcContainer.logined == false) {
                //loginModel.login(funcContainer.loginName, funcContainer.loginPw);
//                accountModel.login();
                listPage.changePage(19);
            }
        }

        onRejected: {
            if(accountModel.getAccountCount() != 0 && funcContainer.logined == false) {
                //loginModel.login(funcContainer.loginName, funcContainer.loginPw);
//                accountModel.login();
                listPage.changePage(19);
            }
        }
    }
}
