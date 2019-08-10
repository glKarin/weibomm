import QtQuick 1.0
import com.nokia.meego 1.0
import "controls"

Page {
    id: readModePage

    //property bool inPortrait: parent.width < parent.height ? true: false

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccTitleBar{
        id: readModePagetitle
        width: parent.width
        height: 65
        title:"阅读模式"
        anchors.top: parent.top
    }

    ButtonColumn {
        anchors.fill: parent
        anchors.topMargin: 100
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Button {
            id: btn1
            text: "预览图模式"
            checkable: true
            checked: if(funcContainer.readMode == 0) {true} else {false}

            onClicked: {
                funcContainer.readMode = 0;
                settingModel.saveReadMode(0);
            }
        }
        Button {
            id: btn2
            text: "文字模式"
            checkable: true
            checked: if(funcContainer.readMode == 1) {true} else {false}

            onClicked: {
                funcContainer.readMode = 1;
                settingModel.saveReadMode(1);
            }
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back"; onClicked: listPage.viewBack();
        }
    }
}
