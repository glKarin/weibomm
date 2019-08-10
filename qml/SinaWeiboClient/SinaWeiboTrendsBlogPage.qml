import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeTrendsBlogPage
import SinaWeiboTypeLib 1.0

Page
{
    id:trendBlogPage
    anchors.fill:parent
    property int pageWdith: parent.width
    property string topicName

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    onVisibleChanged: {
       if(visible) {
           trendBlogModel.connectModel();
       }
       else {
           trendBlogModel.disConnectModel();
       }
   }

    TrendBlogModel {
        id: trendBlogModel

        onGetTrendBlogResult: {
            trendBlogPage.trendBlogFinished(errCode);
        }
    }

    AccTitleBar{
        id: trendBlogTitle
        width: parent.width
        height: 65
        //title: topicName
        anchors.top: parent.top
        z: trendBlogPageList.z + 1

        Text {
            id:title
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            text: topicName
            color: "white"
            font.pixelSize: 30
            elide: Text.ElideRight
            width: parent.width - 90
        }

        Image {
            id: homeIcon
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
    }

    Component.onCompleted:
    {
        topicName = funcContainer.topicName;
        trendBlogModel.getSinaTrendBlogFromModel(topicName);
    }

    Component.onDestruction:{
        trendBlogModel.clearData();
    }

    SinaWeiboItemList{
        id: trendBlogPageList
        anchors.top: trendBlogTitle.bottom
        width: parent.width
        height: parent.height-trendBlogTitle.height
        model: trendBlogModel
        onItemlistscrolled:{
            console.log("==onItemlistscrolled==  type = ", type);
            if(type == 1 || type == 0 )
                trendBlogModel.getSinaTrendBlogFromModel(topicName);
        }
        onItemSelected:{
            console.log("==onItemSelected==  index = ",index);
            funcContainer.statusIDInDetailPage = trendBlogModel.getStudusId(index);
            listPage.changePage(6);
        }
        onShowStatusImage:{
            funcContainer.showDetailImage(trendBlogModel.getImageAddress(0,index),trendBlogModel.getImageAddress(1,index));
            //funcContainer.showStateImage(5,index);
        }
        onShowForwardImage:{
            funcContainer.showDetailImage(trendBlogModel.getImageAddress(2,index),trendBlogModel.getImageAddress(3,index));
            //funcContainer.showForwardImage(5,index);
        }
    }

    function trendBlogFinished(errCode)
    {
        console.log("trendBlogFinished.qml errCode:", errCode)

        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if(200 != errCode) {
                funcContainer.showPopup(ErrorCodeTrendsBlogPage.getErrorInfo(errCode));
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

        ToolIcon {
            iconSource: "images/icon_edit.png";
            onClicked: {
                listPage.changePage(11);
                funcContainer.insertTopic = topicName;
                hotTrendModel.selectTopicItemFinished();
            }
        }
    }

    tools: toolbar

}
