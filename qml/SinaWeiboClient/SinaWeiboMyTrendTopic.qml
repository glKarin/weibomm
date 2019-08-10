import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeHotTrendPage
import SinaWeiboTypeLib 1.0

Page
{
    id:myTrendTopicPage
    anchors.fill:parent
    property int pageWdith: parent.width
    property string userId: funcContainer.myfansId//loginModel.userID
    property bool pageChage:funcContainer.typeForListContainer
    signal itemSelected(int index);
    property bool firstEnter: true
    property bool allowRefresh: false
    property bool needRefresh: !myTrendTopicModel.isReadingDB
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
        myTrendTopicModel.getSinaMyTrendTopicFromModel(0,userId,myTrendTopicPage.pageNum);
    }

    function connectModel()
    {
        myTrendTopicModel.connectModel();
    }

    function disconnectModel()
    {
        myTrendTopicModel.disConnectModel();
    }

    TrendTopicModel {
        id: myTrendTopicModel

        onGetMyTrendTopicResult: {
            myTrendTopicPage.myTrendTopicFinished(errCode);
        }
    }

    AccTitleBar{
        id: myTrendTopicTitle
        width: parent.width
        height: 65
        title:"话题"
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
        z: myTrendTopicList.z + 1
    }

//    onVisibleChanged: {
//        if(pageChage ==1)
//        {
//            myTrendTopicModel.getSinaMyTrendTopicFromModel(0,userId);
//        }
//    }

    Component.onCompleted:
    {
        myTrendTopicPage.pageNum = funcContainer.pageNumforCache
    }

    Component.onDestruction:{
        myTrendTopicModel.clearData();
        myTrendTopicModel.deleteTableRecord(myTrendTopicPage.pageNum);
    }

    Component {
        id: topics

        Item{
            width: parent.width
            height: 80

            MouseArea
            {
                id:contentArea
                anchors.fill: parent
                onReleased:
                {
                    funcContainer.topicName = myTrendTopicModel.getTrendName(index);
                      console.log("topic name ", myTrendTopicModel.getTrendName(index));
                    listPage.changePage(26);
                }
            }

            Item{
                id: nametimearea
                anchors.fill: parent

                Text {
                    id: username
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 10
                    text: "   " + topicName
                    smooth:true;
                    font.pointSize: 20;
                }

            }

            Image {
                id: line
                anchors.top: parent.top
                anchors.topMargin: 79
                width: parent.width
                smooth: true
                source: "images/Thread.png"
                fillMode:Image.Stretch
            }

            Image {
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

    ListView {
        id: myTrendTopicList
        anchors.top: myTrendTopicTitle.bottom
        width: parent.width
        height: parent.height-myTrendTopicTitle.height
        model: myTrendTopicModel
        delegate: topics
        orientation: ListView.Vertical
        snapMode: ListView.SnapToItem
        flickDeceleration: 1000

        Rectangle {
            id: updateBanner
            height: 100;
            anchors.left: parent.left;
            anchors.right: parent.right
            visible: needRefresh
            y: myTrendTopicList.visibleArea.yPosition > 0 ? -height : -(myTrendTopicList.visibleArea.yPosition * Math.max(myTrendTopicList.height, myTrendTopicList.contentHeight)) - height
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
                text:  myTrendTopicPage.allowRefresh ? "松开即可刷新..." : "下拉可以刷新...";
                font.pixelSize: 20
            }
            Image{
                source: "images/Thread.png"
                smooth: true
                anchors.bottom: parent.bottom
                width: parent.width
            }

            onYChanged: {
                if (myTrendTopicList.flicking) return;
                var contentYPos = myTrendTopicList.visibleArea.yPosition * Math.max(myTrendTopicList.height, myTrendTopicList.contentHeight);
                if(myTrendTopicPage.needRefresh) {
                    if ( (contentYPos < funcContainer.listDragDistance) && myTrendTopicList.moving ) {
                        myTrendTopicPage.allowRefresh = true;
                        img.state = "rotated";
                    }
                }
            }
        }


        onMovementEnded:
        {
            if(myTrendTopicList.model.count != 0)
            {
                if (myTrendTopicList.atYBeginning)
                {      
                    if(needRefresh) {
                        img.state = "rotatedBack";
                        if(myTrendTopicPage.allowRefresh) {
                            myTrendTopicPage.allowRefresh = false;
                            myTrendTopicModel.getSinaMyTrendTopicFromModel(0,userId,myTrendTopicPage.pageNum);
                        }
                    }
                    else {
                         myTrendTopicModel.getSinaMyTrendTopicFromModel(1,userId,myTrendTopicPage.pageNum);
                    }
                }
                else if(myTrendTopicList.atYEnd)
                {
                    if(needRefresh && myTrendTopicPage.allowRefresh) {
                        img.state = "rotatedBack";
                        myTrendTopicPage.allowRefresh = false;
                        myTrendTopicModel.getSinaMyTrendTopicFromModel(0,userId,myTrendTopicPage.pageNum);

                    }
                    else {
                        console.log("myTrendTopicList.model.atYEnd");
                        myTrendTopicModel.getSinaMyTrendTopicFromModel(2,userId,myTrendTopicPage.pageNum);
                    }
                }
            }
            else {
                img.state = "rotatedBack";
                if(myTrendTopicPage.allowRefresh) {
                    myTrendTopicPage.allowRefresh = false;
                    myTrendTopicModel.getSinaMyTrendTopicFromModel(0,userId,myTrendTopicPage.pageNum);
                }
            }
        }

        /*onContentYChanged: {
            if(needRefresh) {
                if(myTrendTopicList.contentY < funcContainer.listDragDistance) {
                    myTrendTopicPage.allowRefresh = true;
                    img.state = "rotated";
                }
            }
        }*/
    }

    function myTrendTopicFinished(errCode)
    {
        console.log("myTrendTopicFinished.qml errCode:", errCode)

        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if(200 != errCode) {
                funcContainer.showPopup(ErrorCodeHotTrendPage.getErrorInfo(errCode));
            }
            else{
                if(myTrendTopicModel.hasData() == false) {
                    //popup.open();
                }
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
//            onClicked: {listPage.viewBack();}
//        }

////        ToolIcon {
////            iconSource: "images/icon_edit.png";
////            onClicked: {
////                listPage.changePage(11);
////            }
////        }
//    }

//    tools: toolbar

    QueryDialog {
        id: popup

        message: "无记录"
        acceptButtonText: "确定"
        onAccepted:
        {
            //listPage.viewBack();
        }
    }
}
