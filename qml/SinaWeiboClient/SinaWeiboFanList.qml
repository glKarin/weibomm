import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeSearchUserPage
import SinaWeiboTypeLib 1.0

Page {
    id:fanListPage
    anchors.fill: parent
    property int pageWdith: parent.width
    property int type   //0--my friendlist, 1-my fan's friendlist
    //signal itemlistscrolled(int type);
    signal itemSelected(int index);
    property string fansId
    property string fansName
    property bool firstEnter: true
    property bool allowRefresh: false
    property bool needRefresh: !fanListModel.isReadingDB
    property int pageNum

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    Component {
        id: fanitem

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
                    fanListPage.itemSelected(index);
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
        id: fanPageTitle
        width: parent.width
        height: 65
//        title:{
//            if(type == 0) return "粉丝"
//            if(type == 1) return fansName + "的粉丝"
//        }
        title: "粉丝"
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

        z: fanList.z + 1
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
            fanListModel.getFanInfo(0,fansId,fanListPage.pageNum);
        }
        else
        {
            fanListModel.getFanInfo(0,loginModel.userID,fanListPage.pageNum);

            //fanListModel.getFanInfo(0,"1823503435");
        }
    }

    ListView
    {
        id: fanList
        anchors.top: fanPageTitle.bottom
        //anchors.topMargin: 10
        width: parent.width
        height: parent.height - fanPageTitle.height - 10
        model: fanListModel
        delegate: fanitem
        orientation: ListView.Vertical
        snapMode: ListView.SnapToItem;
        flickDeceleration: 1000


        Rectangle {
            id: updateBanner
            height: 100;
            anchors.left: parent.left;
            anchors.right: parent.right
            visible: needRefresh
            y: fanList.visibleArea.yPosition > 0 ? -height : -(fanList.visibleArea.yPosition * Math.max(fanList.height, fanList.contentHeight)) - height
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

                text:  fanListPage.allowRefresh ? "松开即可刷新..." : "下拉可以刷新...";
                font.pixelSize: 20
            }

            Image{
                source: "images/Thread.png"
                smooth: true
                anchors.bottom: parent.bottom
                width: parent.width
            }

            onYChanged: {
                if (fanList.flicking) return;
                var contentYPos = fanList.visibleArea.yPosition * Math.max(fanList.height, fanList.contentHeight);
                if(fanListPage.needRefresh) {
                    if ( (contentYPos < funcContainer.listDragDistance) && fanList.moving ) {
                        fanListPage.allowRefresh = true;
                        img.state = "rotated";
                    }
                }
            }
        }
//        onMovementEnded:
//        {
//            if(fanList.model.count != 0)
//            {
//                if (fanList.atYBeginning)
//                {
//                    if(type == 1)
//                    {
//                        fanListModel.getFanInfo(1,fansId);
//                    }
//                    else
//                    {
//                        fanListModel.getFanInfo(1,loginModel.userID);
//                    }
//                }
//                else if(fanList.atYEnd)
//                {
//                    if(type == 1)
//                    {
//                        fanListModel.getFanInfo(2,fansId);
//                    }
//                    else
//                    {
//                        fanListModel.getFanInfo(2,loginModel.userID);
//                    }
//                }
//            }
//        }
        onMovementEnded:
        {
            if(fanList.model.count != 0)
            {
                if(fanList.atYEnd)
                {
                    if(needRefresh && fanListPage.allowRefresh) {
                        img.state = "rotatedBack";
                        fanListPage.allowRefresh = false;
                        refresh();
                    }
                    else
                    {
                        if(type == 1)
                        {
                            fanListModel.getFanInfo(2,fansId,fanListPage.pageNum);
                        }
                        else
                        {
                            fanListModel.getFanInfo(2,loginModel.userID,fanListPage.pageNum);
                        }
                    }
                }
                else if (fanList.atYBeginning) {
                    if(needRefresh) {
                        img.state = "rotatedBack";
                        if(fanListPage.allowRefresh) {
                            fanListPage.allowRefresh = false;
                            refresh();
                        }
                    }
                    else {
                        if(type == 1)
                        {
                            fanListModel.getFanInfo(1,fansId,fanListPage.pageNum);
                        }
                        else
                        {
                            fanListModel.getFanInfo(1,loginModel.userID,fanListPage.pageNum);
                        }
                    }
                }
            }
            else {
                img.state = "rotatedBack";
                if(fanListPage.allowRefresh) {
                    fanListPage.allowRefresh = false;
                    refresh();
                }
            }
        }

        /*onContentYChanged: {
            if(needRefresh) {
                if(fanList.contentY < funcContainer.listDragDistance) {
                    fanListPage.allowRefresh = true;
                    img.state = "rotated";
                }
            }
        }*/
    }

    FanListModel{
        id: fanListModel

        onGetFanFinished: {
            fanListPage.sinafanlistPageFinished(errCode);
        }
    }

    function connectModel()
    {
        fanListModel.connectModel();
    }

    function disconnectModel()
    {
        fanListModel.disConnectModel();
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
//                    listPage.viewBack();
//            }
//        }
//    }

//    tools: toolbar

    onItemSelected: {
//        funcContainer.myfansId = fanListModel.getFanIdbyIndex(index);
//        funcContainer.senderScreenName = fanListModel.getFanNamebyIndex(index);
        funcContainer.userIDInMyProfilePage = fanListModel.getFanIdbyIndex(index);
        funcContainer.userNameInProfilePage = fanListModel.getFanNamebyIndex(index);
        listPage.changePage(7);
    }

    function sinafanlistPageFinished(errCode){
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
        fanListPage.type = funcContainer.typeForListContainer
        fanListPage.fansId = funcContainer.myfansId
        fanListPage.fansName = funcContainer.senderScreenName
        fanListPage.pageNum = funcContainer.pageNumforCache
        //fanListModel.getFanFinished.connect(fanListPage.sinafanlistPageFinished);
    }
    Component.onDestruction:{
        //fanListModel.getFanFinished.disconnect(fanListPage.sinafanlistPageFinished);
        //fanListModel.setCursorBack();
    }
}
