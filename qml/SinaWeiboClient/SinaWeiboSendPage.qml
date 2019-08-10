import QtQuick 1.0
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeMyWeiboPage

Page {
    id:sendpage
    anchors.fill:parent
    property int pageWdith: parent.width
    property bool reply: false
    property alias context: editbox.text
    property bool enableSoftkeyInputPanel: true

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccTitleBar{
        id: sendPageTitle
        width: parent.width
        height: 65
        title:"发私信"
        anchors.top: parent.top
        z: flickable.z + 1

        Button{
            id: sendButton
            width: 81
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            text: "发送"
            onClicked: {
                editbox.closeSoftwareInputPanel();
                if(sendPerson.text.length > 0)
                {
                    if(0< context.length)//there are more than one letter
                    {
                        if(140< context.length)
                        {
                            funcContainer.showPopup("发送内容不能超过140个字！");
                        }
                        else
                        {
                            messageCenterModel.sendMessageContent(funcContainer.userIDInMyProfilePage, context);
                        }
                    }
                    else //when it is empty
                    {
                        funcContainer.showPopup("发送不能为空！");
                    }
                }
                else
                {
                    funcContainer.showPopup("请选择一个收件人！");
                }
            }
        }
    }

    Flickable {
        id: flickable
        anchors {left: parent.left; right: parent.right; top:sendPageTitle.bottom; bottom: delButton.top; bottomMargin:5}
//        width: parent.width
//        height: parent.height - sendPageTitle.height - funcbar.height
        contentWidth: parent.width
        contentHeight: editbox.implicitHeight
        flickableDirection: Flickable.VerticalFlick

        TextArea {
            id:editbox

            anchors {left: parent.left; right: parent.right}
            placeholderText:"说点什么吧......"
            activeFocus: true;
            enableSoftwareInputPanel: sendpage.enableSoftkeyInputPanel

            height:implicitHeight

            onVisibleChanged:{
                if(visible){
                    editbox.forceActiveFocus();
                }
            }

            Component.onCompleted:
            {
                editbox.forceActiveFocus();
            }
        }
    }

    //delButton and funcbar bg
    Rectangle{
        id:bg
        anchors.top: delButton.top
        anchors.topMargin: -5
        anchors.bottom: parent.bottom
        width: parent.width
        color: "#f0f1f2"
    }

    TextField {
        id: sendPerson
        anchors.right: delButton.left;
        anchors.rightMargin: 10
        anchors.bottom:sendpage.height > sendpage.width ? funcbar.top : emotionInputPanel.top
        anchors.bottomMargin: 5
        width:300
        placeholderText: "收信人"
        platformStyle: TextFieldStyle { paddingRight: searchfriend.width }
        text: funcContainer.senderScreenName
        readOnly: true

        Image {
            id:searchfriend
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            source: "image://theme/icon-m-toolbar-search"
            scale: 0.8
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listPage.changePage(31);
                }
            }
        }
    }

    Button{
        id: delButton
        anchors.bottom:sendpage.height > sendpage.width ? funcbar.top : emotionInputPanel.top
        anchors.right: parent.right
        iconSource: "images/icon_delete_orange.png"
        width:160
        text: 140 - editbox.text.length
        onClicked: {
            if(0< editbox.text.length)//there is more than a letter
            {
                query.typeFlag = 0;
                query.open();
            }
        }
    }

    QueryDialog {
        id: query

        message:  {
            if(query.typeFlag == 0)
                return "是否清除文字？"
            else
                return "是否返回？"
        }
        acceptButtonText: "是"
        rejectButtonText: "否"
        onAccepted: {
            if(query.typeFlag == 0) {
                editbox.text = "";
                flickable.contentY = 0;
            }
            else
                listPage.viewBack();
        }
    }
    /*Dialog {
        id: query
        property int typeFlag:0
        title: Item {
            id: titleField
            height: query.style.titleBarHeight
            width: parent.width
            Image {
                id: supplement
                source: "images/icon_popup.png"
                height: parent.height - 10
                width: 75
                fillMode: Image.PreserveAspectFit
                anchors.leftMargin: 5
                anchors.rightMargin: 5
            }

            Label {
                id: titleLabel
                anchors.left: supplement.right
                anchors.verticalCenter: titleField.verticalCenter
                font.capitalization: Font.MixedCase
                color: "white"
                text: "询问"
            }

            Image {
                id: closeButton
                anchors.verticalCenter: titleField.verticalCenter
                anchors.right: titleField.right

                source: "image://theme/icon-m-framework-close"

                MouseArea {
                    id: closeButtonArea
                    anchors.fill: parent
                    onClicked:  { query.reject(); }
                }
            }
        }

        content:Item {
            id: name
            height: childrenRect.height
            Text {
                id: text
                font.pixelSize: 22
                color: "white"
                text: {
                    if(query.typeFlag == 0)
                        return "确定清除文字？"
                    else
                        return "确定返回？"
                }

            }
        }

        buttons: ButtonRow {
            style: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: b1;
                text: "确定";
                onClicked: {
                    query.accept();
                    if(query.typeFlag == 0) {
                        editbox.text = "";
                        flickable.contentY = 0;
                    }
                    else
                        listPage.viewBack();

                }
            }

            Button {id: b2; text: "取消"; onClicked: query.reject()}
        }
    }*/
    Component.onCompleted: {
        messageCenterModel.sendMessageFinished.connect(sendpage.jobDone);
    }
    Component.onDestruction: {
        if(null === messageCenterModel){
            console.log("=======messageCenterModel has been deleted======");
        }
        else{
            messageCenterModel.sendMessageFinished.disconnect(sendpage.jobDone);
        }
    }

    function jobDone(errCode)
    {
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);
            if(errCode == 200)
            {
                funcContainer.showPopup("发送成功！");
                editbox.text = "";
            }
            else
            {
                funcContainer.showPopup(ErrorCodeMyWeiboPage.getErrorInfo(errCode));
            }
        }
    }
    //tool bar without delete button
//    ToolBarLayout
//    {
//        id: toolbar
//        visible: false
//        ToolIcon
//        {
//            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
//            onClicked: {
//                if(0< context.length)
//                {
//                    query.typeFlag = 1;
//                    query.open();
//                }
//                else
//                {
//                    listPage.viewBack();
//                }
//            }
//        }
//    }

//    tools: toolbar
    Row{
        id: funcbar
        anchors.bottom: emotionInputPanel.top
        width: parent.width

        ToolIcon { iconId: "icon-m-toolbar-back";
            onClicked: {
                if(0< context.length)
                {
                    query.typeFlag = 1;
                    query.open();
                }
                else
                {
                    listPage.viewBack();
                }
            }
        }

        ToolIcon {
            iconSource: sendpage.enableSoftkeyInputPanel ? "images/emotion.jpg" : "images/icon_edit.png";
            onClicked: {
                console.log("onClicked", sendpage.height);
                if(sendpage.enableSoftkeyInputPanel){
                    editbox.forceActiveFocus();
                    editbox.closeSoftwareInputPanel();
                    sendpage.enableSoftkeyInputPanel = !sendpage.enableSoftkeyInputPanel
                }
                else{
                    editbox.forceActiveFocus();
                    sendpage.enableSoftkeyInputPanel = !sendpage.enableSoftkeyInputPanel
                    editbox.openSoftwareInputPanel();
                }
                console.log("onClicked", sendpage.height);
            }
        }
    }

    SinaWeiboEmotion{
        id:emotionInputPanel
        visible: !sendpage.enableSoftkeyInputPanel
        anchors.bottom: parent.bottom
        width: parent.width
        height: visible ? sendpage.height - (sendpage.height > sendpage.width ? 501 : 209) : 0
        onItemClick: {
            editbox.forceActiveFocus();
            var textLength = editbox.text.length;
            var textCursorPos = editbox.cursorPosition;
            var textContentPre = editbox.text.substring(0, textCursorPos);
            var textContentNxt = editbox.text.substring(textCursorPos, textLength);

            editbox.text = textContentPre + emotionString + textContentNxt;
            editbox.cursorPosition = textCursorPos + emotionString.length;
        }
    }
}
