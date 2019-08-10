import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "SinaWeiboErrorCode.js" as QMLCommonMethod
import "controls"


Page{
//Rectangle {
    id: listContainer

    property int itemheight: listContainer.height - tools.height
    property int itemwidth: listContainer.width
    property int typeId: funcContainer.typeForListContainer
    property int tabIndex:funcContainer.listContainerTabIndex
    property variant currentPage

    property bool isFirstTime: funcContainer.listNeedRefresh

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    tools: ToolBarLayout {

        ToolIcon
        {
            visible: listContainer.typeId == 0? false:true
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: {
                    listPage.viewBack();
            }
        }
        ButtonRow {
            style: TabButtonStyle { }
            TabButton {
                tab: userblog
                iconSource : "images/Microblogging.png";
            }
            TabButton {
                tab: usertopic
                iconSource : "images/Topic.png";
            }

            TabButton {
                tab: userCollection
                visible: listContainer.typeId == 0? true:false
                iconSource : "images/Collection.png";
            }

            TabButton {
                tab: userfans
                iconSource : "images/Fans.png";
            }

            TabButton {
                tab: userattention
                iconSource : "images/Attention.png";
            }

        }
    }

    TabGroup {
        id: tabGroup
        currentTab: userblog
        onCurrentTabChanged:{
            currentTab.activePage();
        }

        SinaWeiboMyWeiboList{
            id: userblog
            width: itemwidth
            height: itemheight
        }

        SinaWeiboMyTrendTopic{
            id: usertopic
            width: itemwidth
            height: itemheight
        }

        SinaWeiboMyFavoritesList{
            id: userCollection
            visible: listContainer.typeId == 0? true:false
            width: itemwidth
            height: itemheight
        }

        SinaWeiboFanList{
            id: userfans
            width: itemwidth
            height: itemheight
        }

        SinaWeiboFriendList{
            id: userattention
            width: itemwidth
            height: itemheight
        }
    }

    function connectModel()
    {
        userattention.connectModel();
        userfans.connectModel();
        usertopic.connectModel();
        userblog.connectModel();
        userCollection.connectModel();
    }

    function disconnectModel()
    {
        userattention.disconnectModel();
        userfans.disconnectModel();
        usertopic.disconnectModel();
        userblog.disconnectModel();
        userCollection.disconnectModel();
    }

    onVisibleChanged: {

        if(visible == true)
        {
            connectModel();
        }
        else
        {
            disconnectModel();
        }

        if(isFirstTime) {
            userfans.firstEnter = true;
            userattention.firstEnter = true;
            userblog.firstEnter = true;
            userCollection.firstEnter = true;
            usertopic.firstEnter = true;

            if (0 == tabIndex){
                tabGroup.currentTab = userblog;
            }
            else if(1 == tabIndex){
                tabGroup.currentTab = usertopic;
            }
            else if(2 == tabIndex){
                tabGroup.currentTab = userCollection;
            }
            else if(3 == tabIndex){
                tabGroup.currentTab = userfans;
            }
            else if(4 == tabIndex){
                tabGroup.currentTab = userattention;
            }

            tabGroup.currentTab.activePage();
            isFirstTime = false;
        }
    }
    Component.onCompleted:
    {

    }

    Component.onDestruction:{

    }

}
