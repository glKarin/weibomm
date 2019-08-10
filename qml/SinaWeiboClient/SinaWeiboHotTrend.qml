import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeHotTrendPage

Page
{
    id:hotTrendPage
    anchors.fill:parent
    property int pageWdith: parent.width

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccTitleBar{
        id: hotTrendTitle
        width: parent.width
        height: 65
        title:"热门话题"
        anchors.top: parent.top
        z: hotTrendList.z + 1
    }

    Component.onCompleted:
    {
        hotTrendModel.getHotTrendResult.connect(hotTrendPage.hotTrendFinished);
        hotTrendModel.getSinaHotTrendFromModel();
    }

    Component.onDestruction:{
        if(null === hotTrendModel){
            console.log("========hotTrendModel has been deleted============");
        }
        else{
            if(funcContainer.showStatusOfTrend) {
                hotTrendModel.clearData();
            }
            else {
                funcContainer.showStatusOfTrend = true;
            }
            hotTrendModel.getHotTrendResult.disconnect(hotTrendPage.hotTrendFinished);
        }
    }

    Component {
        id: trends

        Item{
            width: parent.width
            height: 80

            MouseArea
            {
                id:contentArea
                anchors.fill: parent
                onReleased:
                {
                    if(funcContainer.showStatusOfTrend) {
                        funcContainer.topicName = hotTrendModel.getTrendName(index);
                        listPage.changePage(26);
                    }
                    else {
                        funcContainer.insertTopic = hotTrendModel.getTrendName(index);

                        insertTopicModel.setRecentTopicToModel(funcContainer.insertTopic);
                        settingModel.saveRecentTopic(loginModel.userID,funcContainer.insertTopic);
                        if(funcContainer.microBlogId == 0)
                            listPage.jumpPageTo(11);
                        else if(funcContainer.microBlogId == 1)
                            listPage.jumpPageTo(9);
                        else if(funcContainer.microBlogId == 2)
                            listPage.jumpPageTo(8);
                        else if(funcContainer.microBlogId == 3)
                            listPage.jumpPageTo(25);
                        else if(funcContainer.microBlogId == 4)
                            listPage.jumpPageTo(45);
                        hotTrendModel.selectTopicItemFinished();
                    }
                }
            }

            Item{
                id: nametimearea
                anchors.fill: parent

                Text {
                    id: username
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 10
                    text: "   " + trendName
                    smooth:true;
                    font.pointSize: 20;
                    elide: Text.ElideRight
                    width: parent.width - 50
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
                id: arrowImg
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
        property bool allowRefresh: false

        id: hotTrendList
        anchors.top: hotTrendTitle.bottom
        width: parent.width
        height: parent.height-hotTrendTitle.height
        model: hotTrendModel
        delegate: trends
        orientation: ListView.Vertical
        snapMode: ListView.SnapToItem
        flickDeceleration: 1000

        Rectangle {
            id: updateBanner
            height: 100;
            anchors.left: parent.left;
            anchors.right: parent.right
            y: hotTrendList.visibleArea.yPosition > 0 ? -height : -(hotTrendList.visibleArea.yPosition * Math.max(hotTrendList.height, hotTrendList.contentHeight)) - height
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

                text:  hotTrendList.allowRefresh ? "松开即可刷新..." : "下拉可以刷新...";
                font.pixelSize: 20
            }

            Image{
                id: line
                source: "images/Thread.png"
                smooth: true
                anchors.bottom: parent.bottom
                width: parent.width
            }

            onYChanged: {
                if (hotTrendList.flicking) return;
                var contentYPos = hotTrendList.visibleArea.yPosition * Math.max(hotTrendList.height, hotTrendList.contentHeight);
                if ( (contentYPos < funcContainer.listDragDistance) && hotTrendList.moving ) {
                    hotTrendList.allowRefresh = true;
                    img.state = "rotated";
                }
            }
        }

        onMovementEnded:
        {
            if(hotTrendList.model.count != 0)
            {
                if(hotTrendList.atYEnd)
                {
                    console.log("hotTrendList.model.atYEnd");
                }
                else if (hotTrendList.atYBeginning) {
                    img.state = "rotatedBack";
                    if(hotTrendList.allowRefresh) {
                        hotTrendList.allowRefresh = false;
                        hotTrendModel.getSinaHotTrendFromModel();
                    }
                }
            }
            else {
                img.state = "rotatedBack";
                if(hotTrendList.allowRefresh) {
                    hotTrendList.allowRefresh = false;
                    hotTrendModel.getSinaHotTrendFromModel();
                }
            }
        }

        /*onContentYChanged: {
            if(hotTrendList.contentY < funcContainer.listDragDistance) {
                hotTrendList.allowRefresh = true;
                img.state = "rotated";
            }
        }*/
    }

    function hotTrendFinished(errCode)
    {
        console.log("hotTrendFinished.qml errCode:", errCode)

        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if(200 != errCode) {
                funcContainer.showPopup(ErrorCodeHotTrendPage.getErrorInfo(errCode));
            }
        }
    }

    //tool bar without delete button
    ToolBarLayout
    {
        id: toolbar
        visible: false
        ToolIcon
        {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: {listPage.viewBack();}
        }
    }

    tools: toolbar
}
