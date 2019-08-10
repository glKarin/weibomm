import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"

Page
{
    id:searchPage
    anchors.fill:parent

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccTitleBar{
        id: searchPageTitle
        width: parent.width
        height: 65
        title:"搜索"
        anchors.top: parent.top
        bgsource: "../images/restitlebg_green.png"

        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 20
            source: "images/icon_home_green.png"
            smooth:  true
            MouseArea{
                id: changmsgbut
                anchors.fill: parent
                onClicked: {
                    funcContainer.hometabindex = 0;
                    listPage.changePage(12);
                }
            }
            Image{
                anchors.fill: parent
                source: "images/icon_home_green_press.png"
                smooth:  true
                //color: "blue"
                //radius: 12
                //opacity: 0.3
                visible: changmsgbut.pressed;
            }
        }
    }

    TextField {
        id: searchText
        anchors.left: searchPageTitle.left;
        anchors.leftMargin: 10
        anchors.right: searchPageTitle.right;
        anchors.rightMargin: 10
        anchors.top: searchPageTitle.bottom
        anchors.topMargin: 10
        platformStyle: TextFieldStyle { paddingRight: sendButton.width }
        inputMethodHints: Qt.ImhNoPredictiveText

        placeholderText: "搜索"

        Image {
            id: sendButton
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            source: "image://theme/icon-m-toolbar-search"
            //scale: 0.8
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    search();
                }
            }
        }

        Keys.onReturnPressed:{
            search();
        }
    }

    function search(){
        if(searchText.text == "") {
            funcContainer.showPopup("请输入搜索条件");
        }
        else {
            funcContainer.searchContent = searchText.text;

            if(btnGroup.checkedButton == searchBlog) {
                listPage.changePage(21);
            }
            else {
                funcContainer.showUserInfo = true;
                listPage.changePage(22);
            }
        }
    }

    ButtonRow {
        id: btnGroup
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.top: searchText.bottom
        anchors.topMargin: 5

        RadioButton {
            id: searchBlog;
            text: "搜微博";
        }

        RadioButton {
            id: searchPeople;
            text: "搜人";
        }
        spacing: 80
    }

    Rectangle{
        id: gap
        anchors.top: btnGroup.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: parent.right
        height: image.paintedHeight

        Image {
            id: image
            anchors.left: parent.left
            anchors.right: parent.right
            source: "images/Thread.png"
            smooth: true
        }
    }

    ButtonColumn {
        anchors.left: gap.left;
        anchors.leftMargin: 20
        anchors.top: gap.bottom
        anchors.topMargin: 15
        anchors.right: parent.right;
        anchors.rightMargin: 20

        exclusive: false
        Button {
            text: "热门话题"
            height: 80
            onClicked:  {
                funcContainer.showStatusOfTrend = true;
                listPage.changePage(20);
            }
        }
        Button {
            text: "随便看看"
            height: 80
            onClicked:  listPage.changePage(5);
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
