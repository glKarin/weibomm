import QtQuick 1.1
import com.nokia.meego 1.0

import "controls"
import "SinaWeiboErrorCode.js" as SinaWeiboErrorCode

Page {
    id: loginPage

    property bool inPortrait: funcContainer.inPortrait

    function loginFinished(errCode) {
        console.log("loginFinished" + errCode)
        if(errCode == -1) {
            funcContainer.makeWaitingDialogVisible(true);
        }
        else {
            funcContainer.makeWaitingDialogVisible(false);

            if(errCode == 200 || 1){
                funcContainer.logined = true;
                funcContainer.needRefresh = true;
                funcContainer.needRefreshMsg = true;
                loginModel.getloginResult.disconnect(loginPage.loginFinished);
                listPage.changePage(12);
            }
            else {
                closeSoftKeyboard();

                if(errCode == 403 || errCode == 202)
                    funcContainer.showPopup("用户名或密码错误！");
                else if(errCode == 99 || errCode == 3)
                    funcContainer.showPopup("网络异常，请重试!");
                else
								{
									if(errCode == 2070) // show pin
									{
										funcContainer.showPopup("请输入验证码");
										pinimage.source = loginModel.loginData;
									}
									else if(errCode == 2093) // show pin
									{
										funcContainer.showPopup("验证码错误");
										pinimage.source = loginModel.loginData;
									}
									else
									funcContainer.showPopup(SinaWeiboErrorCode.getErrorInfo(errCode));
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
//        funcContainer.showStatusBar = true;
        loginModel.getloginResult.connect(loginPage.loginFinished)
    }

    Component.onDestruction:{
        if(null === loginModel){
            console.log("=======loginModel has been deleted========");
        }
        else{
            loginModel.getloginResult.disconnect(loginPage.loginFinished);
        }
    }

    MouseArea {
        anchors.fill: loginPage
        onClicked:{
            closeSoftKeyboard();
        }
    }

    Flickable {
        id: view
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: if(inPortrait){750}else{450}//parent.height
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
            anchors.topMargin: if(inPortrait){500}else{210}

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

				Row{
					id: pinrow;
					anchors.top: passwordInput.bottom
					anchors.left: parent.left;
					anchors.leftMargin: 64;
					anchors.right: parent.right;
					anchors.rightMargin: 64;
					anchors.topMargin: inPortrait ? 15 : 10

					height: pinimage.height;
					spacing: 24;
					visible: height > 0;
					Image{
						id: pinimage;
						cache: false;
						//source: "https://login.sina.com.cn/cgi/pin.php?p=tc-0d6fa121d489ce5a05ceebf47f71fb81bb63&r=64101&s=0";
						MouseArea{
							anchors.fill: parent;
							onClicked: {
								pininput.text = "";
								loginModel.clearData();
								login();
							}
						}
						onSourceChanged: {
							pininput.text = "";
						}
					}

					TextField {
						id: pininput;
						height: parent.height;
						width: parent.width - parent.spacing - pinimage.width;
						placeholderText: "验证码"
						inputMethodHints: Qt.ImhNoPredictiveText
						Keys.onReturnPressed:{
							login();
						}
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

//        Button {
//            id: registerBtn
//            anchors.left: parent.left
//            anchors.leftMargin: 20//if(inPortrait){20} else {checkBox.width + 50}
//            anchors.top: passwordInput.bottom
//            anchors.topMargin: 20//if(inPortrait){100} else {12}
//            text: "注册"
//            width: parent.width / 2 - 30//if(inPortrait){parent.width / 2 - 30} else {parent.width / 3}

//            onClicked: {
//                closeSoftKeyboard();

//                //listPage.changePage(2);
////                funcContainer.webviewurl = "http://weibo.cn/dpool/ttt/reg.php";
////                listPage.changePage(38);
//                var openUrl = "http://weibo.cn/dpool/ttt/h5/reg.php";
//                //funcContainer.webviewurl = "http://3g.sina.com.cn/dpool/ttt/sinaurlc.php?vt=3&u=" + content + "&from=10102400";
//                qt_funcView.openUrlInSysBrowser(openUrl);
//            }
//        }

        Button {
            id: loginBtn
//            anchors.right: parent.right
//            anchors.rightMargin: 20
            anchors.top: pinrow.bottom
            anchors.topMargin: funcContainer.inPortrait ? 30:7//if(inPortrait){100} else {12}
            anchors.horizontalCenter: parent.horizontalCenter
            text: "登录"
            width: parent.width / 2 - 30//if(inPortrait){parent.width / 2 - 30} else {parent.width / 3}
            onClicked: {
                login();
            }
        }

        Text {
            anchors.top: loginBtn.bottom
            anchors.topMargin: funcContainer.inPortrait ? 30:7
            anchors.verticalCenterOffset: -2
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30
            textFormat: Text.RichText
//            text: "<a href=\"http://weibo.cn/dpool/ttt/h5/reg.php\">立即注册微博</a>"
//            onLinkActivated: qt_funcView.openUrlInSysBrowser("http://weibo.cn/dpool/ttt/h5/reg.php");
            text: "<a href=\"http://weibo.cn/dpool/ttt/h5/regwb.php?from=10132400&wm=9026_0001&hidetop=1\">立即注册微博</a>"
            onLinkActivated: qt_funcView.openUrlInSysBrowser("http://weibo.cn/dpool/ttt/h5/regwb.php?from=10132400&wm=9026_0001&hidetop=1");
        }

    }

    function login(){
        closeSoftKeyboard();
        if(accountInput.text == "") {
            funcContainer.showPopup("请输入账号！");
        }
        else if(passwordInput.text == "") {
            funcContainer.showPopup("请输入密码！");
        }
        else {
						loginModel.login(accountInput.text, passwordInput.text, pininput.text);
        }
    }

/*
    AccTitleBar{
        width: parent.width
        height: 65
        textcolor: "black"
        title:"登录"
        anchors.top: parent.top
        bgsource: "../images/titlebg_gray.png"

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -2
            anchors.right: parent.right
            anchors.rightMargin: 20
            font.pixelSize: 30
            textFormat: Text.RichText
            text: "<a href=\"http://weibo.cn/dpool/ttt/h5/reg.php\">注册</a>"
            onLinkActivated: qt_funcView.openUrlInSysBrowser("http://weibo.cn/dpool/ttt/h5/reg.php");
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconSource: "images/about_sel.png";
            onClicked: listPage.changePage(16);
            anchors.right: parent.right
        }
    }
*/
}
