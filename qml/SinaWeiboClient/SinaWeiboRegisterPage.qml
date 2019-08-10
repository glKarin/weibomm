import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"

Page {
    id: registerContainer

    property string popupContent
    property int pageWdith: parent.width
    property int pageHeight: parent.height
    property bool landscape: pageHeight < pageWdith

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    Component.onCompleted:{
        registerModel.sendMessageFinish.connect(registerContainer.registerFinished);
    }

    Component.onDestruction:{
        registerModel.sendMessageFinish.disconnect(registerContainer.registerFinished);
    }

    Flickable {
        id: view
        anchors.fill: parent
        anchors.topMargin: 42
        contentWidth: pageWdith
        contentHeight: 550
        flickableDirection: Flickable.VerticalFlick
        interactive: true
        clip: true

        AccTitleBar{
            id: text1
            width: parent.width
            height: 40
            title:"请正确选择您的通信运营商"
            anchors.top: parent.top
            bgsource: "../images/refreshtimebg.png"
            textcolor: "black"
        }

        Text{
            id: text2
            anchors.top: text1.bottom
            anchors.topMargin: 45
            anchors.left: text1.left
            anchors.leftMargin: 80
            font.pixelSize: 24
            wrapMode: Text.Wrap
            width: pageWdith - 60
            text: "移动用户"
            color: "black"
        }

        Button {
            id: yidong
            anchors.top: text2.bottom
            anchors.topMargin: 10
            anchors.left: text1.left
            anchors.leftMargin: 80
            text: "1069009009"

            onClicked: {
                register(yidong.text);
            }
        }

        Text{
            id: text3
            anchors.top: yidong.bottom
            anchors.topMargin: 15
            anchors.left: text1.left
            anchors.leftMargin: 80
            font.pixelSize: 24
            wrapMode: Text.Wrap
            width: pageWdith - 60
            text: "联通用户"
            color: "black"
        }

        Button {
            id: liantong
            anchors.top: text3.bottom
            anchors.topMargin: 10
            anchors.left: text1.left
            anchors.leftMargin: 80
            text: "1066888866"

            onClicked: {
                register(liantong.text);
            }
        }

        Text{
            id: text4
            anchors.top: liantong.bottom
            anchors.topMargin: 15
            anchors.left: text1.left
            anchors.leftMargin: 80
            font.pixelSize: 24
            wrapMode: Text.Wrap
            width: pageWdith - 60
            text: "电信用户"
            color: "black"
        }

        Button {
            id: other
            anchors.top: text4.bottom
            anchors.topMargin: 10
            anchors.left: text1.left
            anchors.leftMargin: 80
            text: "1066888866"

            onClicked: {
                register(other.text);
            }
        }

        Text{
            id: text5
            anchors.top: other.bottom
            anchors.topMargin: 30
            anchors.left: text1.left
            anchors.leftMargin: 30
            font.pixelSize: 24
            wrapMode: Text.Wrap
            width: pageWdith - 60
            text: "发送完毕并收到确认短信后即可登陆，帐号为发送短信的手机号，密码为手机号后六位。"
            color: "darkgreen"
        }

        Image {
            id: line
            anchors.top: text5.bottom
            anchors.topMargin: 10
            anchors.left: text1.left
            anchors.right: text1.right
            source: "images/line.png"
            smooth: true
        }

        Text{
            id: text6
            anchors.top: line.bottom
            anchors.topMargin: 10
            anchors.left: text1.left
            anchors.leftMargin: 30
            font.pixelSize: 20
            wrapMode: Text.Wrap
            width: pageWdith - 60
            text: "注： 1.发送注册短信新浪不收取任何费用，您只需支付由运营商收取的标准短信费。 2.手机号只用于个人登录，其他用户不可见。"
            color: "gray"
        }
    }

    AccTitleBar{
        id: titleBar
        width: parent.width
        height: 42
        title:"短信注册"
        textOffset: 60
        anchors.top: parent.top
        bgsource: "../images/restitlebg_green.png"

        Image{
            anchors.verticalCenter: titleBar.verticalCenter
            anchors.left: titleBar.left
            anchors.leftMargin: 16
            source: "images/icon_phone_sm_green.png"
            smooth: true
        }
    }

    tools: ToolBarLayout {

        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back"; onClicked: listPage.viewBack();
        }
    }

    function register(phoneNum){
        registerModel.registerWeibo(phoneNum, "Register");
    }

    function registerFinished(errCode) {
        if(errCode == -1) {
            funcContainer.makeWaitingDialogVisible(true);
        }
        else {
            funcContainer.makeWaitingDialogVisible(false);

            if(errCode == 200) {
                listPage.changePage(1);
            }
            else {
                funcContainer.showPopup("注册失败！");
            }
        }
    }
}
