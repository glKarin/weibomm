import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeSuiBianPage


Page
{
    id:mySuibianKanKanPage
    anchors.fill:parent
    property int pageWdith: parent.width

    AccTitleBar{
        id: suiBianKantitle
        width: parent.width
        height: 65
        title:"随便看看"
        anchors.top: parent.top
        z: suibiankankanList.z + 1

        /*Image {
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
        }*/
    }

    AccTitleBar{
        id: timearea
        width: parent.width
        height: 40
        title: "最后更新:" + suiBianKanModel.reflashTime
        textcolor: "black"
        titlesize: 18
        bgsource: "../images/refreshtimebg.png"
        anchors.top: suiBianKantitle.bottom
        z: suibiankankanList.z + 1
    }

    SinaWeiboItemList{
        id: suibiankankanList
        anchors.top: timearea.bottom
        width: parent.width
        height: parent.height-suiBianKantitle.height-timearea.height
        model: suiBianKanModel
        readMode: funcContainer.readMode
        onItemlistscrolled:{
            console.log("==onItemlistscrolled==  type = ", type);
            suiBianKanModel.getSuiBianKanFromModel(type);
        }
        onItemSelected:{
            console.log("==onItemSelected==  index = ",index);
            funcContainer.statusIDInDetailPage = suiBianKanModel.getSuiBianKanStudusId(index);
            listPage.changePage(6);
        }
        onShowStatusImage:{
            funcContainer.showDetailImage(suiBianKanModel.getImageAddress(0,index),suiBianKanModel.getImageAddress(1,index));
            //funcContainer.showStateImage(3,index);
        }
        onShowForwardImage:{
            funcContainer.showDetailImage(suiBianKanModel.getImageAddress(2,index),suiBianKanModel.getImageAddress(3,index));
            //funcContainer.showForwardImage(3,index);
        }
    }

    Component.onCompleted:
    {
        suiBianKanModel.getPublicTimelineItemResult.connect(mySuibianKanKanPage.suiBianKanFinished);
        suiBianKanModel.getSuiBianKanFromModel(0);
    }

    Component.onDestruction:{
        if(null === suiBianKanModel){
            console.log("=======suiBianKanModel has been deleted======");
        }
        else{
            suiBianKanModel.clearData();
            suiBianKanModel.getPublicTimelineItemResult.disconnect(mySuibianKanKanPage.suiBianKanFinished);
        }
    }

    function suiBianKanFinished(errCode)
    {
        console.log("suibiankankanListFinished.qml errCode:", errCode)
        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if((errCode != 40018) && (200 != errCode)) {
                funcContainer.showPopup(ErrorCodeSuiBianPage.getErrorInfo(errCode));
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

        /*ToolIcon {
            iconSource: "images/icon_refresh.png";
            onClicked: {
                suiBianKanModel.getSuiBianKanFromModel(0);
            }
        }*/
    }

    tools: toolbar
}
