import QtQuick 1.1
import com.nokia.meego 1.0

import "controls"
import "SinaWeiboErrorCode.js" as SinaWeiboAddAccountErrorCode

Page {
    id: addAccountPage

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    property bool inPortrait: funcContainer.inPortrait

    function loginFinished_Add(errCode) {
        console.log("loginFinished_Add" + errCode)
        if(errCode == -1) {
            funcContainer.makeWaitingDialogVisible(true);
        }
        else {
            funcContainer.makeWaitingDialogVisible(false);

            if(errCode == 200){
                funcContainer.hometabindex = 0;
                funcContainer.needRefresh = true;
                funcContainer.logined = true;
                funcContainer.needRefreshMsg = true;
                newMsgNotification.start();
                listPage.changePage(12);
            }
            else {
                closeSoftKeyboard();

                if(errCode == 403 || errCode == 202) {
                    popup_AddAccount.popupContent = "用户名或密码错误！";
                    popup_AddAccount.open();
                }
                else if(errCode == 99 || errCode == 3) {
                    popup_AddAccount.popupContent = "网络异常，请重试！";
                    popup_AddAccount.open();
                }
                else {
                    popup_AddAccount.popupContent = SinaWeiboAddAccountErrorCode.getErrorInfo(errCode);
                    popup_AddAccount.open();
                }
            }
        }
    }

    function closeSoftKeyboard() {
        if(accountInput.activeFocus) {
            accountInput.closeSoftwareInputPanel();
        }

        if(passwordInput.activeFocus) {
            passwordInput.closeSoftwareInputPanel();
        }
    }

    Component.onCompleted:{
        accountModel.loginFinish_ForAddAccount.connect(addAccountPage.loginFinished_Add)
    }

    Component.onDestruction:{
        if(null === accountModel){
            console.log("=======accountModel has been deleted======");
        }
        else{
            accountModel.loginFinish_ForAddAccount.disconnect(addAccountPage.loginFinished_Add)
        }
    }

    MouseArea {
        anchors.fill: addAccountPage
        onClicked:{
            closeSoftKeyboard();
        }
    }

    Flickable {
        id: view
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: if(inPortrait){700}else{350}//parent.height
        flickableDirection: Flickable.VerticalFlick
        interactive: false
        clip: true

        Image{
            id:bgImage
            anchors.top: parent.top;
            anchors.topMargin: if(inPortrait){25}else{-25}
            anchors.left: parent.left;
            source: if(inPortrait) {"images/blog_loading.png"} else {"images/blog_loading_landscape.png"}
            smooth: true;
        }

        TextField {
            id: accountInput
            anchors.left: parent.left;
            anchors.leftMargin: 20
            anchors.right: parent.right;
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: if(inPortrait){500}else{205}

            placeholderText: "账号"
            echoMode: TextInput.Normal
            inputMethodHints: Qt.ImhNoPredictiveText
            text: if(loginModel.needToSave) {loginModel.loginName} else {""}

//            onActiveFocusChanged: {
//                if (activeFocus) {
//                    platformOpenSoftwareInputPanel();
//                } else {
//                    platformCloseSoftwareInputPanel();
//                }
//            }
            Keys.onReturnPressed:{
                closeSoftKeyboard();
                passwordInput.forceActiveFocus();
            }
        }

        TextField {
            id: passwordInput
            anchors.left: parent.left;
            anchors.leftMargin: 20
            anchors.right: parent.right;
            anchors.rightMargin: 20
            anchors.top: accountInput.bottom
            anchors.topMargin: inPortrait ? 15 : 10

            placeholderText: "密码"
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhNoPredictiveText
            text: if(loginModel.needToSave) {loginModel.loginPassword} else {""}

//            onActiveFocusChanged: {
//                if (activeFocus) {
//                    platformOpenSoftwareInputPanel();
//                } else {
//                    platformCloseSoftwareInputPanel();
//                }
//            }
            Keys.onReturnPressed:{
                login();
            }
        }

        /*CheckBox {
            id: checkBox
            anchors.left: parent.left;
            anchors.leftMargin: 20
            anchors.top: passwordInput.bottom
            anchors.topMargin: inPortrait ? 20 : 15
            checked: if(loginModel.needToSave){true} else {false}
            text: "记住我的密码"
        }*/

       /* Button {
            id: registerBtn
            anchors.left: parent.left
            anchors.leftMargin: 20//if(inPortrait){20} else {checkBox.width + 50}
            anchors.top: passwordInput.bottom
            anchors.topMargin: 20//if(inPortrait){100} else {12}
            text: "注册"
            width: parent.width / 2 - 30//if(inPortrait){parent.width / 2 - 30} else {parent.width / 3}

            onClicked: {
                closeSoftKeyboard();

                listPage.changePage(2);
            }
        }*/

        Button {
            id: loginBtn
            /*anchors.right: parent.right
            anchors.rightMargin: 20*/
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: passwordInput.bottom
            anchors.topMargin: 20//if(inPortrait){100} else {12}
            text: "登录"
            width: parent.width / 2 - 30//if(inPortrait){parent.width / 2 - 30} else {parent.width / 3}

            onClicked: {
                login();
            }
        }
    }


    function login(){
        closeSoftKeyboard();
        if(accountInput.text == "") {
            popup_AddAccount.popupContent = "请输入账号！";
            popup_AddAccount.open();
        }
        else if(passwordInput.text == "") {
            popup_AddAccount.popupContent = "请输入密码！";
            popup_AddAccount.open();
        }
        else {
            if(accountModel.checkExist(accountInput.text)) {
                popup_AddAccount.popupContent = "该账号已经存在！";
                popup_AddAccount.open();
            }
            else {
                accountModel.addAccount(accountInput.text, passwordInput.text);
            }
        }
    }

    AccTitleBar{
        width: parent.width
        height: 65
        textcolor: "black"
        title:"添加账号"
        anchors.top: parent.top
        bgsource: "../images/titlebg_gray.png"
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: listPage.viewBack();
        }
    }

    QueryDialog {
        id: popup_AddAccount
        property string popupContent

        message: popupContent
        acceptButtonText: "确定"
    }
}
