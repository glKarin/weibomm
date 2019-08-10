import QtQuick 1.0
import com.nokia.meego 1.0
import "controls"

Page {
    id: settingPage

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccTitleBar{
        id: settingPageTitle
        width: parent.width
        height: 65
        title:"设置"
        anchors.top: parent.top
    }

    Rectangle{
        id: setItem
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 40

        anchors.top: settingPageTitle.bottom
        anchors.topMargin: 40
        height: 80
        color: "transparent"

        Row {
            id: col
            spacing: parent.width - 170
            width:  parent.width

            Component.onCompleted: {
                var count = children.length;
                for (var i = 0; i < count; i++) {
                    var item = children[i];
                    item.anchors.verticalCenter = item.parent.verticalCenter;
                }
            }
            Label {
                text: "提示声音"
                font.pixelSize: 26
            }

            Switch {
                id: switchBtn
                checked: settingModel.readAudioMode() ? true : false

                onCheckedChanged: {
                    settingModel.saveAudioMode(switchBtn.checked);
                }
            }
        }
    }

    Image {
        id: image
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: setItem.bottom
        source: "images/Thread.png"
        smooth: true
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: {
                listPage.viewBack();
            }
        }
    }
}
