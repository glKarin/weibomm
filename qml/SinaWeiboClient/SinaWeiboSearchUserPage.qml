import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeSearchUserPage

Page
{
    id:searchUserPage
    anchors.fill:parent
    property int pageWdith: parent.width

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccTitleBar{
        id: searchUserPageTitle
        width: parent.width
        height: 65
        title:"搜人"
        anchors.top: parent.top
        z: searchUserPageList.z + 1
    }

    Component {
        id: user

        Item{
            width: parent.width
            height: 100

            MouseArea
            {
                id:contentArea
                anchors.fill: parent
                onReleased:
                {
                    if(funcContainer.showUserInfo) {
                        funcContainer.userIDInMyProfilePage = searchUserModel.getUserId(index);
                        listPage.changePage(7);
                    }
                    else {
                        frequentContactModel.setFrequentContactToModel(searchUserModel.getUserName(index),
                                                                       searchUserModel.getUserImage(index),
                                                                       searchUserModel.getUserIsVip(index),
                                                                       searchUserModel.getUserId(index));
                        funcContainer.insertContact = searchUserModel.getUserName(index);
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
                        frequentContactModel.selectContactItemFinished();
                    }
                }
            }

            //Image
            Item{
                id: userphotoarea
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
                    source: image;
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
                width: parent.width - userphotoarea.width; //height: 30
                anchors.left: userphotoarea.right
                anchors.top: userphotoarea.top
                //anchors.topMargin: 5

                //UserName
                Text {
                    id: username
                    //anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 10
                    text: userNickName
                    smooth:true;
                    font.pointSize: 20;
                }

                Text{
                    id:content;
                    anchors.left: parent.left; anchors.leftMargin: 10
                    anchors.top: username.bottom; anchors.topMargin: 10
                    //width: parent.width - 20;
                    text: "粉丝： " + followNum
                    color:"black";
                    smooth:true;
                    horizontalAlignment:Text.AlignLeft
                    wrapMode:Text.WrapAtWordBoundaryOrAnywhere
                    font.pointSize: 14;
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

    ListView
    {
        id: searchUserPageList
        anchors.top: searchUserPageTitle.bottom
        width: parent.width
        height: parent.height-searchUserPageTitle.height
        model: searchUserModel
        delegate: user
        orientation: ListView.Vertical
        snapMode: ListView.SnapToItem;
        flickDeceleration: 1000

        onMovementEnded:
        {
            if(searchUserPageList.model.count != 0)
            {
                if (searchUserPageList.atYBeginning)
                {
                    searchUserModel.searchUserFromModel(1, funcContainer.searchContent);
                }
                else if(searchUserPageList.atYEnd)
                {
                    searchUserModel.searchUserFromModel(2, funcContainer.searchContent);
                }
            }
        }
    }

    Component.onCompleted:
    {
        searchUserModel.searchUserResult.connect(searchUserPage.searchUserResult);
        searchUserModel.searchUserFromModel(0, funcContainer.searchContent);
    }

    Component.onDestruction:{
        if(null === searchUserModel){
            console.log("=======searchUserModel has been deleted======");
        }
        else{
            searchUserModel.clearData();
            searchUserModel.searchUserResult.disconnect(searchUserPage.searchUserResult);
        }
    }

    function searchUserResult(errCode)
    {
        console.log("ListFinished.qml errCode:", errCode)
        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if(200 != errCode) {
                funcContainer.showPopup(ErrorCodeSearchUserPage.getErrorInfo(errCode));
            }
            else{
                if(searchUserModel.hasData() == false) {
                    popup.open();
                }
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


    QueryDialog {
        id: popup

        message: "无记录"
        acceptButtonText: "确定"
        onAccepted: listPage.viewBack();
    }
}
