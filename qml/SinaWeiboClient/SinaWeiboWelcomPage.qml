import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"

Page {
    id: welcomeContainer

    property int pageWdith: parent.width
    property int pageHeight: parent.height
    property bool landscape: pageHeight < pageWdith

    // Styling for the Button
    property Style style: ButtonStyle{}

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: 65
        //anchors.leftMargin: 30
        //anchors.rightMargin: 30
        anchors.bottomMargin: 6
        //contentWidth: col.width
        //contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick
        interactive: false

        Rectangle{
            id: welcome
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 15
            height: text1.paintedHeight + text2.paintedHeight + 40
            color: "#303030"
            radius: 10

            Text{
                id: text1
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: landscape ? 260 : 110
                font.pixelSize: 24
                text: "恭喜您成功注册新浪微博"
                color: "white"
            }

            Text{
                id: text2
                anchors.top: text1.bottom
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pixelSize:20
                wrapMode: Text.Wrap
                width: pageWdith - 40
                text: "浏览<font color = #D89F16>微博广场</font color>，寻找并<font color = #D89F16>关注</font color>你感兴趣的<font color = #D89F16>人</font color>和<font color = #D89F16>话题</font color>，一起体验精彩的<font color = #D89F16>微博</font color>世界。"
                color: "white"
            }
        }

        AccIntroductoryBar {
            id: updateProfile
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: welcome.bottom
            anchors.topMargin: 15

            hasMark: true
            markPath: "../images/icon_arrow_gray.png"
            textX: 15
            textY: 13
            markWidth:9
            markHeight: 17
            markX: pageWdith - 50
            markY: 15
            width: pageWdith - 20
            height: 52
            fontSize: 24
            pressColor: "#1C53BB"

            bgPath: if(landscape){"../images/bg_item_info_single_landscape.png"}else{"../images/bg_item_info_single.png"}
            pressImage: if(landscape){"../images/bg_item_info_single_landscape_blue.png"}else{"../images/bg_item_info_single_blue.png"}
            content: "完善资料"

            onClicked: {
                listPage.changePage(4);
            }
        }

        Rectangle{
            id: gap
            anchors.top: updateProfile.bottom
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.right: parent.right
            height: image.paintedHeight + 40

            Image {
                id: image
                anchors.left: parent.left
                anchors.right: parent.right
                source: "images/line.png"
                smooth: true
            }

            AccTitleBar{
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: image.bottom
                height: 40
                title:"微博广场"
                bgsource: "../images/refreshtimebg.png"
                textcolor: "black"
                textOffset: pageWdith - 150
            }
        }

        AccIntroductoryBar {
            id: browse
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: gap.bottom
            anchors.topMargin: 15

            hasMark: true
            markPath: "../images/icon_arrow_gray.png"
            textX: 15
            textY: 13
            markWidth:9
            markHeight: 17
            markX: pageWdith - 50
            markY: 15
            width: pageWdith - 20
            height: 52
            fontSize: 24
            pressColor: "#1C53BB"

            bgPath: if(landscape){"../images/bg_item_info_single_landscape.png"}else{"../images/bg_item_info_single.png"}
            pressImage: if(landscape){"../images/bg_item_info_single_landscape_blue.png"}else{"../images/bg_item_info_single_blue.png"}

            content: "随便看看"

            onClicked: {
                listPage.changePage(5);
            }
        }
    }

    AccTitleBar{
        width: parent.width
        height: 65
        textcolor: "black"
        title:"欢迎"
        anchors.top: parent.top
        bgsource: "../images/titlebg_gray.png"

        Button {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 16
            width: 120
            text: "跳过"

            onClicked: {
                funcContainer.hometabindex = 0;
                listPage.changePage(12);
            }
        }
    }

    /*tools: ToolBarLayout {

        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back"; onClicked: listPage.viewBack();
        }
    }*/
}
