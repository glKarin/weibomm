import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeMsgPage

Rectangle
{
    id:messagePage
    color: "transparent"
    anchors.fill:parent
    property int pageWdith: parent.width
    //property bool isAtMe: true
    property bool is1stactive: true
    property bool isComment1st: true
    property bool isMessage1st: true

    function refresh(){
        console.log("messagePage refresh");
        if(tabbar.count == 0){
            console.log("===========get @me data from model=============");
            atMeModel.getAtMeFromModel(0);
        }
        else if(tabbar.count == 1){
            commentToMeModel.getSinaCommentToMeFromModel(0);
        }
        else{
            messageCenterModel.getMessageInfo(0);
        }
    }

    function activepage(){
        funcContainer.hometabindex = 1;
        if(messagePage.is1stactive){
            messagePage.is1stactive = false;
            messagePage.refresh();
        }
    }

    function activeFirstTab() {
        tabbar.count = 0;
    }

    AccTitleBar{
        id: msgpagetitle
        width: parent.width
        height: 65
        //title: isAtMe ? ("@我") : ("评论")

        anchors.top: parent.top
        z: messagelist.z + 1
        bgsource: "../images/restitlebg_green.png"
        AccTabBar{
            id:tabbar
            height: parent.height-20
            width: 288
            anchors.centerIn: parent
            commentCount : newMsgNotification.commentCount
            mentionCount : newMsgNotification.mentionCount
            privateMsgCount : newMsgNotification.privateMsgCount
            onTabChanged: {
                if(messagePage.isComment1st && tabbar.count == 1){
                    messagePage.refresh();
                    messagePage.isComment1st = false;
                }
                if(messagePage.isMessage1st && tabbar.count == 2){
                    messagePage.refresh();
                    messagePage.isMessage1st = false;
                }
            }
        }
        Image {
            id: name
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 20
            source: changmsgbut.pressed? "images/refresh_press.png":"images/refresh.png"
            MouseArea{
                id: changmsgbut
                anchors.fill: parent
                onClicked: {
                    messagePage.refresh();
                }
            }
//            Rectangle{
//                anchors.fill: parent
//                color: "green"
//                radius: 12
//                opacity: 0.3
//                visible: changmsgbut.pressed;
//            }
        }
        Image {
            id: newMessage
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left; anchors.leftMargin: 20
            source: newButton.pressed? "images/icon_message_press.png":"images/icon_message_nor.png"
            visible: tabbar.count==2
            MouseArea{
                id: newButton
                anchors.fill: parent
                onClicked: {
                    funcContainer.userIDInMyProfilePage = "";
                    funcContainer.senderScreenName = "";
                    listPage.changePage(25);
                }
            }
//            Rectangle{
//                anchors.fill: parent
//                color: "green"
//                radius: 12
//                opacity: 0.3
//                visible: newButton.pressed;
//            }
        }

//        TumblerButton {
//            width: 50
//            anchors.verticalCenter: parent.verticalCenter
//            anchors.right: parent.right; anchors.rightMargin: 20
//            text: ""
//            z:100
//            style: TumblerButtonStyle {
//                background:"../../../../../../share/SinaWeiboClient/qml/SinaWeiboClient/images/bg_topbutton_blue_updown.png"}
//        }
    }

    AccTitleBar{
        id: msgtimearea
        width: parent.width
        height: 40
        visible: tabbar.count!=2
        title: tabbar.count==0 ? ("最后更新:" + atMeModel.reflashTime) : ("最后更新:" + commentToMeModel.reflashTime)
        textcolor: "black"
        titlesize: 18
        bgsource: "../images/refreshtimebg.png"
        anchors.top: msgpagetitle.bottom
        z: commentlist.z + 1
    }
    //@me
    SinaWeiboItemList{
        id: atmelist
        visible: tabbar.count==0
        anchors.top: msgtimearea.bottom
        width: parent.width
        height: parent.height - msgpagetitle.height - msgtimearea.height
        model: atMeModel
        readMode: funcContainer.readMode

        onItemlistscrolled:{
            atMeModel.getAtMeFromModel(type);
        }
        onItemSelected:{
            console.log("==onItemSelected==  index = ",index);
            funcContainer.statusIDInDetailPage = atMeModel.getAtMeId(index);
            listPage.changePage(6);
        }
        onShowStatusImage:{
            funcContainer.showDetailImage(atMeModel.getImageAddress(0,index),atMeModel.getImageAddress(1,index));
            //funcContainer.showStateImage(1,index);
        }
        onShowForwardImage:{
            funcContainer.showDetailImage(atMeModel.getImageAddress(2,index),atMeModel.getImageAddress(3,index));
            //funcContainer.showForwardImage(1,index);
        }
        Component.onCompleted:{
            atMeModel.getAtMeResult.connect(messagePage.sinaMsgPageFinished);
        }

        Component.onDestruction:{
            if(null === atMeModel){
                console.log("=======atMeModel has been deleted========");
            }
            else{
                atMeModel.getAtMeResult.disconnect(messagePage.sinaMsgPageFinished);
            }
        }
    }

    //Comment
    SinaWeiboItemList{
        id: commentlist
        visible: tabbar.count==1
        anchors.top: msgtimearea.bottom
        width: parent.width
        height: atmelist.height
        model: commentToMeModel
        readMode: funcContainer.readMode
        onItemlistscrolled:{
            console.log("==onItemlistscrolled==  type = ", type);
            commentToMeModel.getSinaCommentToMeFromModel(type);
        }
        onItemSelected:{
            console.log("==onItemSelected==  index = ",index);
            funcContainer.statusIDInDetailPage = commentToMeModel.getCommentOriginalId(index);
            funcContainer.userIDInMyProfilePage = commentToMeModel.getCommentUserId(index);
            funcContainer.commentStatusID = commentToMeModel.getCommentId(index);
            funcContainer.replyRetweetedId = commentToMeModel.getCommentRetweetedId(index);
            funcContainer.commentHeader = "回复 @" + commentToMeModel.getCommentUserName(index) + " :";
            contextMenu.open();
        }
        Component.onCompleted:{
            commentToMeModel.getCommentToMeResult.connect(messagePage.sinaMsgPageFinished);
        }

        Component.onDestruction:{
            if(null === commentToMeModel){
                console.log("=======commentToMeModel has been deleted========");
            }
            else{
                commentToMeModel.getCommentToMeResult.disconnect(messagePage.sinaMsgPageFinished);
            }
        }
    }

    ContextMenu {
        id: contextMenu
        icon: "image://theme/icon-l-contacts"
        titleText: "请选择"
        MenuLayout {
            MenuItem {text: "回复评论"; onClicked: { listPage.changePage(45) } }
            MenuItem {text: "查看个人资料"; onClicked: { listPage.changePage(7) }}
            MenuItem {text: "查看原微博"; onClicked: { listPage.changePage(6) }}
        }
    }

    //message center
    SinaWeiboMessageCenter {
        id: messagelist
        visible: tabbar.count==2
        anchors.top: msgpagetitle.bottom
        width: parent.width
        height: parent.height - msgpagetitle.height
        z:msgtimearea.z+1
        onItemlistscrolled:{
            messageCenterModel.getMessageInfo(type);
        }
        Component.onCompleted:{
            messageCenterModel.getMessageFinished.connect(messagePage.sinaMsgPageFinished);
            messageCenterModel.deleteMessageFinished.connect(messagePage.sinaMsgPageFinishedWithRefresh);
        }
        Component.onDestruction:{
            if(null === messageCenterModel){
                console.log("=======messageCenterModel has been deleted========");
            }
            else{
                messageCenterModel.getMessageFinished.disconnect(messagePage.sinaMsgPageFinished);
                messageCenterModel.deleteMessageFinished.disconnect(messagePage.sinaMsgPageFinishedWithRefresh);
            }
        }
    }

    QueryDialog {
        id: popup

        message: "删除成功！"
        acceptButtonText: "确定"
        onAccepted: {
            //messagePage.refresh();
            messageCenterModel.removeTheMessage(funcContainer.indexForMessageCenter);
        }
    }

    function sinaMsgPageFinished(errCode){
        console.log("==========SinaWeiboMSGPage errCode:=============", errCode)
        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if((errCode != 40018) && (200 != errCode)) {
                funcContainer.showPopup(ErrorCodeMsgPage.getErrorInfo(errCode));
            }
        }
    }
    function sinaMsgPageFinishedWithRefresh(errCode){
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if((errCode != 40018) && (200 != errCode)) {
                funcContainer.showPopup(ErrorCodeMsgPage.getErrorInfo(errCode));
            }
            else{
                popup.open();
            }
        }
    }
}

