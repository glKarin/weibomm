import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeMyWeiboPage
import SinaWeiboTypeLib 1.0

Page
{
    id:myWeiboListPage
    anchors.fill:parent
    property int pageWdith: parent.width
    property int type: funcContainer.typeForListContainer //0--my profile, 1--anther user profile
    property bool firstEnter: true
    property string  myfansId: funcContainer.myfansId
    property string  screenName: funcContainer.senderScreenName
    property int pageNum: funcContainer.pageNumforCache
    property string  smallSource: ""
    property string  bigSource: ""

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    MyWeiboListModel {
        id: myWeiboModel
    }

    function connectModel()
    {
        disconnectModel();
        myWeiboModel.connectModel();
    }

    function disconnectModel()
    {
        myWeiboModel.disConnectModel();
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
            myWeiboModel.setUser(myfansId, screenName);
        }
        else
        {
            myWeiboModel.setUser(loginModel.userID, loginModel.nickName);
        }
        myWeiboModel.setPageNum(pageNum);
        myWeiboModel.createDBTable();
        myWeiboModel.getMyWeiBoFromModel(0);
    }

    AccTitleBar{
        id: myWeibotitle
        width: parent.width
        height: 65
        title: "微博"
        anchors.top: parent.top
        z: myweibolist.z + 1

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
    }

    AccTitleBar{
        id: timearea
        width: parent.width
        height: 40
        title: "最后更新:" + myWeiboModel.reflashTime
        textcolor: "black"
        titlesize: 18
        bgsource: "../images/refreshtimebg.png"
        anchors.top: myWeibotitle.bottom
        z: myweibolist.z + 1
    }

    SinaWeiboItemList{
        id: myweibolist
        anchors.top: timearea.bottom
        width: parent.width
        height: parent.height-myWeibotitle.height-timearea.height
        model: myWeiboModel
        readMode: funcContainer.readMode
        onItemlistscrolled:{
            console.log("==onItemlistscrolled==  type = ", type);
            myWeiboModel.getMyWeiBoFromModel(type);
        }
        onItemSelected:{
            console.log("==onItemSelected==  index = ",index);
            funcContainer.statusIDInDetailPage = myWeiboModel.getMyWeiBoStudusId(index);
            listPage.changePage(6);
        }
        onShowStatusImage:{
            smallSource = myWeiboModel.getImageAddress(0,index);
            bigSource = myWeiboModel.getImageAddress(1,index);

            funcContainer.showDetailImage(smallSource,bigSource);

        }
        onShowForwardImage:{
            smallSource = myWeiboModel.getImageAddress(2,index);
            bigSource = myWeiboModel.getImageAddress(3,index);

            funcContainer.showDetailImage(smallSource,bigSource);
        }
    }

    Component.onCompleted:
    {
        myWeiboModel.getUserTimelineItemResult.connect(myWeiboListPage.myWeiBoListFinished);
    }

    Component.onDestruction:{
        myWeiboModel.getUserTimelineItemResult.disconnect(myWeiboListPage.myWeiBoListFinished);
        myWeiboModel.clearMyWeiBoModel();
    }

    function myWeiBoListFinished(errCode)
    {
        console.log("myWeiBoListFinished.qml errCode:", errCode)
        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if((errCode != 40018) && (200 != errCode)) {
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
//            onClicked: {listPage.viewBack();}
//        }

//        ToolIcon {
//            iconSource: "images/icon_refresh.png";
//            onClicked: {
//                myWeiboModel.getMyWeiBoFromModel(0);
//            }
//        }
//    }

//    tools: toolbar
}



