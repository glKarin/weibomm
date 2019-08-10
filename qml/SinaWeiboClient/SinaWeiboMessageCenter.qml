import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeSearchUserPage

Rectangle
{
    id:messageCenterPage
    //anchors.fill:parent
    width: 480
    height: 800
    color: "transparent"
    property int pageWdith: parent.width
    signal itemlistscrolled(int type);
    signal itemSelected(int index);
    property bool allowRefresh: false
    property bool needRefresh: !messageCenterModel.isReadingDB

//    AccTitleBar{
//        id: messageCenterTitle
//        width: parent.width
//        height: 65
//        title:"私信"
//        anchors.top: parent.top
//        z: messageList.z + 1
//    }

    Component {
        id: messageitem

        Item{
            width: parent.width
            height: 100
            MouseArea
            {
                id:contentArea
                anchors.fill: parent
                onReleased:
                {
                    console.log("Item select" + index);
                    messageCenterPage.itemSelected(index);
                }
            }

            //Image
            Item{
                id: senderphotoarea
                width: 80; height: 80
                //anchors.top: parent.top;  anchors.left: parent.left
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    width: 64; height: 64
                    //anchors.top: parent.top; anchors.topMargin: (parent.height - height)/2
                    //anchors.left: parent.left; anchors.leftMargin: (parent.width - width)/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    smooth: true
                    source: imageAddress;
                    Image {
                        id: mask
                        anchors.fill: parent
                        smooth: true
                        source: "images/mask_userimage.png"
                    }

                    Image{
                        id:vipBadge
                        anchors.right: parent.right; anchors.top: parent.top
                        source: "images/icon_VIP.png"
                        visible: isVip;
                        smooth: true
                    }
                }
            }

            //Name
            Item{
                id: nametimearea
                width: parent.width - senderphotoarea.width; //height: 30
                anchors.left: senderphotoarea.right
                anchors.top: senderphotoarea.top
                //anchors.topMargin: 5

                //UserName
                Text {
                    id: sendername
                    //anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 10
                    anchors.top: parent.top; anchors.topMargin: 10
                    text: senderId
                    width: parent.width/2;
                    elide: Text.ElideRight
                    smooth:true;
                    font.pixelSize: 22;
                }
                Text {
                    id:sendtime
                    anchors.right: parent.right; anchors.rightMargin:20+arrow.paintedWidth
                    anchors.bottom: sendername.bottom
                    text: changeDateFormat(dateInfo)
//                    color: "lightblue"
                    color:"black"
                    smooth:true;
                    font.pixelSize: 20;
                }
                Text{
                    id:content;
                    anchors.left: parent.left; anchors.leftMargin: 10
                    anchors.top: sendername.bottom; anchors.topMargin: 10
                    width: parent.width/2;
                    text: shortText
                    color:"black"
                    smooth:true;
                    //horizontalAlignment:Text.AlignLeft
                    elide: Text.ElideRight
                    font.pixelSize: 28;
                }
            }

            Image {
                id: line
                anchors.top: parent.top
                anchors.topMargin: 99
                width: parent.width
                //height: 8
                smooth: true
                source: "images/Thread.png"
                fillMode:Image.Stretch
            }

            Image {
                id:arrow
                source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.rightMargin: 10;
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle
            {
                id:marginfoucus
                anchors.fill:parent
                color: "lightsteelblue";
                opacity: 0.3
                z:parent.z + 1;
                visible: contentArea.pressed;
            }
        }
    }

    ListView
    {
        id: messageList
        anchors.top: parent.top
        width: parent.width
        height: parent.height
        model: messageCenterModel
        delegate: messageitem
        orientation: ListView.Vertical
        snapMode: ListView.SnapToItem;
        flickDeceleration: 1000
//        onMovementEnded:
//        {
//            if(messageList.model.count != 0)
//            {
//                if (messageList.atYBeginning)
//                {
//                    console.log("itemlist.model.atYBeginning");
//                    messageCenterPage.itemlistscrolled(1);
//                }
//                else if(messageList.atYEnd)
//                {
//                    console.log("itemlist.model.atYEnd");
//                    messageCenterPage.itemlistscrolled(2);
//                }
//            }
//        }

        Rectangle {
            id: updateBanner
            height: 100;
            anchors.left: parent.left;
            anchors.right: parent.right
            visible: needRefresh
            y: messageList.visibleArea.yPosition > 0 ? -height : -(messageList.visibleArea.yPosition * Math.max(messageList.height, messageList.contentHeight)) - height
            color: "transparent";

            Image{
                id: img
                source: "images/Drop-down arrow.png"
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 50

                states: [
                    State {
                        name: "rotated"
                        PropertyChanges { target: img; rotation: 180 }
                    },
                    State {
                        name: "rotatedBack"
                        PropertyChanges { target: img; rotation: 0 }
                    }

                ]

                transitions: Transition {
                    RotationAnimation { duration: 200; }
                }
            }

            // Text shown in the banner
            Text {
                id: topText;
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: img.right
                anchors.leftMargin: if(parent.width > 700) {280} else {100}

                text:  messageCenterPage.allowRefresh ? "松开即可刷新..." : "下拉可以刷新...";
                font.pixelSize: 20
            }

            Image{
                source: "images/Thread.png"
                smooth: true
                anchors.bottom: parent.bottom
                width: parent.width
            }

            onYChanged: {
                if (messageList.flicking) return;
                var contentYPos = messageList.visibleArea.yPosition * Math.max(messageList.height, messageList.contentHeight);
                if(messageCenterPage.needRefresh) {
                    if ( (contentYPos < funcContainer.listDragDistance) && messageList.moving ) {
                        messageCenterPage.allowRefresh = true;
                        img.state = "rotated";
                    }
                }
            }
        }

        onMovementEnded:
        {
            if(messageList.model.count != 0)
            {
                if(messageList.atYEnd)
                {
                    if(needRefresh && messageCenterPage.allowRefresh) {
                        img.state = "rotatedBack";
                        messageCenterPage.allowRefresh = false;
                        messageCenterPage.itemlistscrolled(0);
                    }
                    else {
                        console.log("itemlist.model.atYEnd");
                        messageCenterPage.itemlistscrolled(2);
                    }
                }
                else if (messageList.atYBeginning) {
                    if(needRefresh) {
                        img.state = "rotatedBack";
                        if(messageCenterPage.allowRefresh) {
                            messageCenterPage.allowRefresh = false;
                            messageCenterPage.itemlistscrolled(0);
                        }
                    }
                    else {
                        messageCenterPage.itemlistscrolled(1);
                    }
                }
            }
            else {
                img.state = "rotatedBack";
                if(messageCenterPage.allowRefresh) {
                    messageCenterPage.allowRefresh = false;
                    messageCenterPage.itemlistscrolled(0);
                }
            }
        }

        /*onContentYChanged: {
            if(needRefresh) {
                if(messageList.contentY < funcContainer.listDragDistance) {
                    messageCenterPage.allowRefresh = true;
                    img.state = "rotated";
                }
            }
        }*/
    }

    ContextMenu {
        id: contextMenu
        icon: "image://theme/icon-l-contacts"
        titleText: "请选择"
        MenuLayout {
            MenuItem {text: "查看私信"; onClicked: { listPage.changePage(33) } }
            MenuItem {text: "回复私信"; onClicked: { listPage.changePage(25) } }
            MenuItem {text: "查看个人资料"; onClicked: { listPage.changePage(7) }}
            MenuItem {text: "删除这条私信"; onClicked: { query.open() }}
        }
    }

    QueryDialog {
        id: query

        message: "是否删除此私信？"
        acceptButtonText: "是"
        rejectButtonText: "否"
        onAccepted: {
            messageCenterModel.deleteTheMessage(funcContainer.indexForMessageCenter);
        }
    }
    /*Dialog {
        id: query
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
                text: "确定删除此私信？"
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
                    messageCenterModel.deleteTheMessage(funcContainer.indexForMessageCenter);
                }
            }
            Button {id: b2; text: "取消"; onClicked: query.reject()}
        }
    }*/
    onItemSelected: {
        funcContainer.userIDInMyProfilePage = messageCenterModel.getSenderIdbyIndex(index);
        funcContainer.senderScreenName = messageCenterModel.getSenderNamebyIndex(index);
        funcContainer.indexForMessageCenter = index;
        contextMenu.open();
    }
    function changeDateFormat(oldString)
    {
			return oldString; //k
        var bef = funcContainer.tranferStringMonthToInt(oldString.substr(0,3));

        return bef+"-"+oldString.substr(4,8);
    }

}
