import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"

Rectangle
{
    id:morePage
    anchors.fill:parent
    color: "transparent"

    function activepage(){
        funcContainer.hometabindex = 3;
        //do nothing
    }

    AccTitleBar{
        id: morePagetitle
        width: parent.width
        height: 65
        title:"更多"
        anchors.top: parent.top
        z:flickable.z+1
        bgsource: "../images/restitlebg_green.png"
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: 85
        contentWidth: col.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: col
            spacing: 20
            width:  flickable.width

            Component.onCompleted: {
                var count = children.length;
                for (var i = 0; i < count; i++) {
                    var item = children[i];
                    item.anchors.horizontalCenter = item.parent.horizontalCenter;
                }
            }

            Button {
                width: parent.width - 40
                height: 80
                iconSource: "images/search.png";
                text: "搜索"
                onClicked:  listPage.changePage(24);
            }

            ButtonColumn {
                width: parent.width - 40
                exclusive: false
                Button {
                    width: parent.width
                    height: 80
                    iconSource: "images/setting.png";
                    text: "设置"
                    onClicked:  listPage.changePage(17);
                }
                Button {
                    width: parent.width
                    height: 80
                    iconSource: "images/readmode.png";
                    text: "阅读模式"
                    onClicked:  listPage.changePage(18);
                }
            }

            Button {
                width: parent.width - 40
                height: 80
                iconSource: "images/account.png";
                text: "账号管理"
                onClicked:  listPage.changePage(19);
            }

            Button {
                width: parent.width - 40
                height: 80
                iconSource: "images/abou_icon.png";
                text: "关于"
                onClicked:  listPage.changePage(16);
            }
        }
    }
    /*ListModel {
        id: pagesModel
        ListElement {
            pageId: 24
            title: "搜索"
            icon: "images/search.png"
        }
        ListElement {
            pageId: 17
            title: "设置"
            icon: "images/setting.png"
        }
        ListElement {
            pageId: 18
            title: "阅读模式"
            icon: "images/readmode.png"
        }
        ListElement {
            pageId: 19
            title: "账号管理"
            icon: "images/account.png"
        }
        ListElement {
            pageId: 16
            title: "关于"
            icon: "images/abou_icon.png"
        }
    }*/

    /*ListView {
        id: listView
        anchors.fill: parent
        anchors.topMargin: 65
        model: pagesModel

        delegate:  Item {
            id: listItem
            height: 80
            width: parent.width

            BorderImage {
                id: background
                anchors.fill: parent
                // Fill page porders
                anchors.leftMargin: -listPage.anchors.leftMargin
                anchors.rightMargin: -listPage.anchors.rightMargin
                visible: mouseArea.pressed
                source: "image://theme/meegotouch-list-background-pressed-center"
            }

            Row {
                anchors.fill: parent

                Column {
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle{
                        anchors.fill: parent
                        Image{
                            id: leftIcon
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            source: model.icon
                        }

                        Label {
                            id: mainText
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: leftIcon.right
                            anchors.leftMargin: 10
                            text: model.title
                            font.weight: Font.Bold
                            font.pixelSize: 26
                        }
                    }
                }
            }

            Image {
                source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id: mouseArea
                anchors.fill: background
                onClicked: {
                    listPage.changePage(pageId)
                }
            }
        }
    }*/
}
