import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeFstPage

Rectangle
{
    id:homePage
    anchors.fill:parent
    color: "transparent"
    property int pageWdith: parent.width

    function refresh(){
        console.log("homepage refresh");
        firstPageModel.getSinaContentFromModel(0);
    }
    function activepage(){
        funcContainer.hometabindex = 0;

        if(funcContainer.needRefresh) {
            funcContainer.needRefresh = false;
            refresh();
        }
    }

    AccTitleBar{
        id: homepagetitle
        width: parent.width
        height: 65
        //title:"首页"
        anchors.top: parent.top
        z: sinalist.z + 1

        Image {
            id: profileImg
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            source: loginModel.profileImageUrl
            width: 55
            height: 55
            smooth:true
            fillMode: Image.PreserveAspectFit

            Image {
                id: mask
                anchors.fill: parent
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "images/mask_userimage_blue.png"
            }
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 20
            source: refreshbut.pressed? "images/refresh_press_blue.png":"images/refresh_blue.png"
            MouseArea{
                id: refreshbut
                anchors.fill: parent
                onClicked: {
                    homePage.refresh();
                }
            }
        }

        Label {
            id: mainText
            width: parent.width * 2/3
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: profileImg.right
            anchors.leftMargin: 10
            text: loginModel.nickName
            //font.weight: Font.Bold
            font.pixelSize: 26
        }
    }

    AccTitleBar{
        id: timearea
        width: parent.width
        height: 40
        title: "最后更新:" + firstPageModel.reflashTime
        textcolor: "black"
        titlesize: 18
        bgsource: "../images/refreshtimebg.png"
        anchors.top: homepagetitle.bottom
        z: sinalist.z + 1
    }

    SinaWeiboItemList{
        id: sinalist
        anchors.top: timearea.bottom
        width: parent.width
        height: parent.height-homepagetitle.height-timearea.height
        model: firstPageModel
        readMode: funcContainer.readMode
        onItemlistscrolled:{
            console.log("==onItemlistscrolled==  type = ", type);
            firstPageModel.getSinaContentFromModel(type);
        }
        onItemSelected:{
            console.log("==onItemSelected==  index = ",index);
            funcContainer.statusIDInDetailPage = firstPageModel.getSinaStudusId(index);
            listPage.changePage(6);
        }
        onShowStatusImage:{
            funcContainer.showDetailImage(firstPageModel.getImageAddress(0,index),firstPageModel.getImageAddress(1,index));
            //funcContainer.showStateImage(0,index);
        }
        onShowForwardImage:{
            funcContainer.showDetailImage(firstPageModel.getImageAddress(2,index),firstPageModel.getImageAddress(3,index));
            //funcContainer.showForwardImage(0,index);
        }
    }

    Component.onCompleted:
    {
        firstPageModel.getFriendsTimeLineResult.connect(homePage.sinaWeiBoFirstFinished);
        if(funcContainer.logined) {
            funcContainer.makeWaitingDialogVisible(true);
            firstPageModel.getSinaContentFromModel(0);
        }
    }

    Component.onDestruction:{
        if(null === firstPageModel){
            console.log("=======firstPageModel has been deleted========");
        }
        else{
            firstPageModel.getFriendsTimeLineResult.disconnect(homePage.sinaWeiBoFirstFinished);
        }
    }

    function sinaWeiBoFirstFinished(errCode){
        console.log("SinaWeiboFirstPage.qml errCode:", errCode)
        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if((errCode != 40018) && (200 != errCode)) {
                funcContainer.showPopup(ErrorCodeFstPage.getErrorInfo(errCode));
            }
        }
    }
}

