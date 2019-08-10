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
    property bool firstEnter: true
//    property int favoritesNum : (1 == viewId) ? userProfile.topic : profile.topic
    property bool allowRefresh: false
    property bool needRefresh: !myFavoritesModel.isReadingDB
    property string smallSource: ""
    property string bigSource: ""

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    FavoritesModel {
        id: myFavoritesModel
    }

    function connectModel()
    {
        disconnectModel();
        myFavoritesModel.connectModel();
    }

    function disconnectModel()
    {
        myFavoritesModel.disConnectModel();
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
       // myFavoritesModel.setFavoritesCount(favoritesNum);
        myFavoritesModel.getMyFavoritesFromModel(0);
    }

    AccTitleBar{
        id: myWeibotitle
        width: parent.width
        height: 65
        title:"收藏"
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
        title: "最后更新:" + myFavoritesModel.reflashTime
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
        model: myFavoritesModel
        readMode: funcContainer.readMode
        onItemlistscrolled:{
            console.log("==onItemlistscrolled==  type = ", type);
            myFavoritesModel.getMyFavoritesFromModel(type);
        }
        onItemSelected:{
            console.log("==onItemSelected==  index = ",index);
            funcContainer.statusIDInDetailPage = myFavoritesModel.getMyFavoritesStudusId(index);
            listPage.changePage(6);
        }
        onShowStatusImage:{
            smallSource = myFavoritesModel.getImageAddress(0,index);
            bigSource = myFavoritesModel.getImageAddress(1,index);

            funcContainer.showDetailImage(smallSource,bigSource);
        }
        onShowForwardImage:{
            smallSource = myFavoritesModel.getImageAddress(2,index);
            bigSource = myFavoritesModel.getImageAddress(3,index);

            funcContainer.showDetailImage(smallSource,bigSource);
        }
    }

    Component.onCompleted:
    {
        myFavoritesModel.getUserTimelineItemResult.connect(myWeiboListPage.myWeiBoListFinished);
    }

    Component.onDestruction:{
        myFavoritesModel.getUserTimelineItemResult.disconnect(myWeiboListPage.myWeiBoListFinished);
        myFavoritesModel.clearMyFavorites();
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


}



