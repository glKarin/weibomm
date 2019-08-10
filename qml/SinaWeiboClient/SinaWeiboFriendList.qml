import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeSearchUserPage
import SinaWeiboTypeLib 1.0

Page {
    id:friendListPage
    anchors.fill: parent
    property int pageWdith: parent.width
    property int type   //2-message, 0-my friendlist, 1-my fan's friendlist
    //signal itemlistscrolled(int type);
    property string friendsId
    property string friendsName
    signal itemSelected(int index);
    property bool firstEnter: true
    property bool allowRefresh: false
    property bool needRefresh: !friendListModel.isReadingDB
    property int pageNum

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    function activePage()
    {
        if(firstEnter)
        {
            refresh();
            firstEnter = false;
        }
    }

    function refresh()
    {
        if(type == 1)
        {
            friendListModel.getFriendInfo(0,friendsId,friendListPage.pageNum);
        }
        else
        {
            friendListModel.getFriendInfo(0,loginModel.userID,friendListPage.pageNum);

            //friendListModel.getFriendInfo(0,"1823503435");
        }
    }
    Component {
        id: frienditem

        Item{
            width: parent.width
            height: 80
            MouseArea
            {
                id:contentArea
                anchors.fill: parent
                onReleased:
                {
                    console.log("Item select" + index);
                    friendListPage.itemSelected(index);
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
                    text: senderName
                    width: parent.width/2;
                    elide: Text.ElideRight
                    smooth:true;
                    font.pixelSize: 22;
                }
                Text{
                    id:content;
                    anchors.left: parent.left; anchors.leftMargin: 10
                    anchors.top: sendername.bottom; anchors.topMargin: 10
                    width: parent.width*2/3;
                    text: blogText
                    color:"black";
                    smooth:true;
                    //horizontalAlignment:Text.AlignLeft
                    elide: Text.ElideRight
                    font.pixelSize: 28;
                }
            }

            Image {
                id: line
                anchors.top: parent.top
                anchors.topMargin: 79
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
                visible: funcContainer.isshowmoreindicator
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

    AccTitleBar{
        id: friendPageTitle
        width: parent.width
        height: 65
//        title:{
//            if(type == 0) return "关注"
//            if(type == 2) return "关注"
//            if(type == 1) return friendsName + "的关注"
//        }
        title: "关注"
        anchors.top: parent.top

        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 20
            source: "images/icon_home_white_bluebg_50x50.png"
            MouseArea{
                id: changmsgbut
                anchors.fill: parent
                onClicked: {
                    funcContainer.hometabindex = 0;
                    listPage.changePage(12);
                }
            }
            Rectangle{
                anchors.fill: parent
                color: "blue"
                radius: 12
                opacity: 0.3
                visible: changmsgbut.pressed;
            }
        }

        z: friendList.z + 1
    }


    ListView
    {
        id: friendList
        anchors.top: friendPageTitle.bottom
        //anchors.topMargin: 10
        width: parent.width
        height: parent.height - friendPageTitle.height - 10
        model: friendListModel
        delegate: frienditem
        orientation: ListView.Vertical
        snapMode: ListView.SnapToItem;
        flickDeceleration: 1000
//        onMovementEnded:
//        {
//            if(friendList.model.count != 0)
//            {
//                if (friendList.atYBeginning)
//                {
//                    if(type == 1)
//                    {
//                        friendListModel.getFriendInfo(1,friendsId);
//                    }
//                    else
//                    {
//                        friendListModel.getFriendInfo(1,loginModel.userID);
//                    }
//                }
//                else if(friendList.atYEnd)
//                {
//                    if(type == 1)
//                    {
//                        friendListModel.getFriendInfo(2,friendsId);
//                    }
//                    else
//                    {
//                        friendListModel.getFriendInfo(2,loginModel.userID);
//                    }
//                }
//            }
//        }

        Rectangle {
            id: updateBanner
            height: 100;
            anchors.left: parent.left;
            anchors.right: parent.right
            visible: needRefresh
            y: friendList.visibleArea.yPosition > 0 ? -height : -(friendList.visibleArea.yPosition * Math.max(friendList.height, friendList.contentHeight)) - height
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

                text:  friendListPage.allowRefresh ? "松开即可刷新..." : "下拉可以刷新...";
                font.pixelSize: 20
            }

            Image{
                source: "images/Thread.png"
                smooth: true
                anchors.bottom: parent.bottom
                width: parent.width
            }

            onYChanged: {
                if (friendList.flicking) return;
                var contentYPos = friendList.visibleArea.yPosition * Math.max(friendList.height, friendList.contentHeight);
                if(friendListPage.needRefresh) {
                    if ( (contentYPos < funcContainer.listDragDistance) && friendList.moving ) {
                        friendListPage.allowRefresh = true;
                        img.state = "rotated";
                    }
                }
            }
        }

        onMovementEnded:
        {
            if(friendList.model.count != 0)
            {
                if(friendList.atYEnd)
                {
                    if(needRefresh && friendListPage.allowRefresh) {
                        img.state = "rotatedBack";
                        friendListPage.allowRefresh = false;
                        refresh();
                    }
                    else
                    {
                        if(type == 1)
                        {
                            friendListModel.getFriendInfo(2,friendsId,friendListPage.pageNum);
                        }
                        else
                        {
                            friendListModel.getFriendInfo(2,loginModel.userID,friendListPage.pageNum);
                        }
                    }

                }
                else if (friendList.atYBeginning) {
                    if(needRefresh) {
                        img.state = "rotatedBack";
                        if(friendListPage.allowRefresh) {
                            friendListPage.allowRefresh = false;
                            refresh();
                        }
                    }
                    else {
                        if(type == 1)
                        {
                            friendListModel.getFriendInfo(1,friendsId,friendListPage.pageNum);
                        }
                        else
                        {
                            friendListModel.getFriendInfo(1,loginModel.userID,friendListPage.pageNum);
                        }
                    }
                }
            }
            else {
                img.state = "rotatedBack";
                if(friendListPage.allowRefresh) {
                    friendListPage.allowRefresh = false;
                    refresh();
                }
            }
        }

        /*onContentYChanged: {
            console.log("friendList.contentY:" + friendList.contentY);
            console.log("needRefresh:" + needRefresh);
            console.log("friendListPage.allowRefresh:" + friendListPage.allowRefresh);
            console.log("friendList.visibleArea.yPosition:" + friendList.visibleArea.yPosition);

            if(needRefresh) {
                if(friendList.contentY < funcContainer.listDragDistance) {
                    friendListPage.allowRefresh = true;
                    img.state = "rotated";
                }
            }
        }*/
    }


    FriendListModel{
        id: friendListModel

        onGetFriendFinished: {
            friendListPage.sinafriendlistPageFinished(errCode);
        }
    }

    function connectModel()
    {
        friendListModel.connectModel();
    }

    function disconnectModel()
    {
        friendListModel.disConnectModel();
    }

    //tool bar without delete button
    ToolBarLayout
    {
        id: toolbar
        visible: false
        ToolIcon
        {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: {
                    listPage.viewBack();
            }
        }
    }

    tools: type == 2? toolbar:null

    onItemSelected: {
        if(type == 2)
        {
            funcContainer.senderScreenName = friendListModel.getFriendNamebyIndex(index);
            funcContainer.userIDInMyProfilePage = friendListModel.getFriendIdbyIndex(index);
            frequentContactModel.setFrequentContactToModel(funcContainer.senderScreenName,
                                                           friendListModel.getFriendImagebyIndex(index),
                                                           friendListModel.getFriendVipbyIndex(index),
                                                           funcContainer.userIDInMyProfilePage);
            listPage.jumpPageTo(25);
        }
        else
        {
    //        funcContainer.myfansId = fanListModel.getFanIdbyIndex(index);
    //        funcContainer.senderScreenName = fanListModel.getFanNamebyIndex(index);
            funcContainer.userIDInMyProfilePage = friendListModel.getFriendIdbyIndex(index);
            funcContainer.userNameInProfilePage = friendListModel.getFriendNamebyIndex(index);
            listPage.changePage(7);
        }

    }

    function sinafriendlistPageFinished(errCode){
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

    Component.onCompleted:{
        friendListPage.type = funcContainer.typeForListContainer
        friendListPage.friendsId = funcContainer.myfansId
        friendListPage.friendsName = funcContainer.senderScreenName
        friendListPage.pageNum = funcContainer.pageNumforCache
        if(type == 2)
        {
            activePage();
        }
    }
    Component.onDestruction:{
        disconnectModel();
    }
}
