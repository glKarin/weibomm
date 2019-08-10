import QtQuick 1.1
import com.nokia.meego 1.0

import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeUpdateProfilePage

Page {
    id: updateProfileContainer

    property int pageWdith: parent.width
    property int pageHeight: parent.height
    property bool landscape: pageHeight < pageWdith
    property string gender: ""

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    Component.onCompleted:{
        updateProfileModel.getUpdateResult.connect(updateProfileContainer.updateProfilelFinished);
    }

    Component.onDestruction:{
        if(null === updateProfileModel){
            console.log("=======updateProfileModel has been deleted======");
        }
        else{
            updateProfileModel.getUpdateResult.disconnect(updateProfileContainer.updateProfilelFinished);
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked:{
            closeSoftKeyboard();
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: 60
        //anchors.leftMargin: 30
        //anchors.rightMargin: 30
        anchors.bottomMargin: 6
        contentWidth: col.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick
        interactive: false

        Column {
            id: col
            spacing: 15
            width:  flickable.width

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.right: parent.right
                anchors.rightMargin: 30
                text: "昵称"
            }

            TextField {
                id: nameInput
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.right: parent.right
                anchors.rightMargin: 30

                placeholderText: "昵称"
                echoMode: TextInput.Normal
                inputMethodHints: Qt.ImhNoPredictiveText
                text: profile.nick

                onActiveFocusChanged: {
                    if (activeFocus) {
                        platformOpenSoftwareInputPanel();
                    } else {
                        platformCloseSoftwareInputPanel();
                    }
                }
            }

            Image {
                anchors.left: parent.left
                anchors.right: parent.right
                source: "images/Thread.png"
                smooth: true
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.right: parent.right
                anchors.rightMargin: 30
                text: "性别"
            }

            ButtonRow {
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.right: parent.right
                anchors.rightMargin: 30

                RadioButton {
                    id: male;
                    checked: {
                        if(profile.gender == "m" || profile.gender == "n") {
                            return true;
                        }
                        else {
                            return false;
                        }
                    }
                    text: "男";
                }

                RadioButton {
                    id: famle;
                    checked: {
                        if(profile.gender == "f") {
                            return true;
                        }
                        else {
                            return false;
                        }
                    }
                    text: "女";
                }
                spacing: 80
            }

            Image {
                anchors.left: parent.left
                anchors.right: parent.right
                source: "images/Thread.png"
                smooth: true
            }

            Button {
                id: updateBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: "完成"

                onClicked: {
                    closeSoftKeyboard();

                    if(male.checked)
                        gender = "m";
                    else if(famle.checked)
                        gender = "f";

                    if(nameInput.text == "") {
                        funcContainer.showPopup("请输入昵称！");
                    }
                    else if(gender == "n") {
                        funcContainer.showPopup("请选择性别！");
                    }

                    else {
                        if(profile.nick == nameInput.text && profile.gender == gender)
                            listPage.viewBack();
                        else if(profile.nick == nameInput.text && profile.gender != gender)
                            updateProfileModel.updateProfile("", gender);
                        else if(profile.nick != nameInput.text && profile.gender == gender)
                            updateProfileModel.updateProfile(nameInput.text, "");
                        else if(profile.nick != nameInput.text && profile.gender != gender)
                            updateProfileModel.updateProfile(nameInput.text, gender);
                    }
                }
            }
        }
    }

    AccTitleBar{
        id: titleBar
        width: parent.width
        height: 42
        title:"完善资料"
        textOffset: 60
        anchors.top: parent.top
        bgsource: "../images/restitlebg_green.png"

        Image{
            anchors.verticalCenter: titleBar.verticalCenter
            anchors.left: titleBar.left
            anchors.leftMargin: 16
            source: "images/icon_user_sm_green.png"
            smooth: true
        }
    }

    tools: ToolBarLayout {

        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back"; onClicked: listPage.viewBack();
        }
    }

    function closeSoftKeyboard() {
        if(nameInput.activeFocus == true) {
            nameInput.activeFocus = false;
        }
    }

    function updateProfilelFinished(errCode) {
        console.log(errCode)
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if(200 != errCode) {
                if(40028 == errCode) {
                    funcContainer.showPopup("请换一个昵称！");
                }
                else {
                    funcContainer.showPopup(ErrorCodeUpdateProfilePage.getErrorInfo(errCode));
                }
            }
            else {

                /*if(listPage.getPreviousPageID() == 3) {
                    listPage.changePage(5);
                }
                else if(listPage.getPreviousPageID() == -1){
                    console.log("error");
                }
                else {*/
                    loginModel.nickName = nameInput.text;
                    profile.nick = nameInput.text;
                    profile.gender = gender;
                    accountModel.updateAccountName(loginModel.userID, nameInput.text);

                    listPage.viewBack();
                //}
            }
        }
    }
}
