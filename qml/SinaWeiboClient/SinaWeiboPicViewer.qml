import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    anchors.fill: parent

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    Item{
        id: picviewer

        property real picscale: slider.value / 100

        height: parent.height > parent.width ? 854 : 480
        width: parent.width

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        function calcscale(){
            return pic.sourceSize.height/pic.sourceSize.width < picviewer.height/picviewer.width ?
                                             picviewer.width/pic.sourceSize.width : picviewer.height/pic.sourceSize.height
        }

        Flickable{
            id: flic
            maximumFlickVelocity:500
            property int oldContentHeight
            property int oldContentWidth

            width: Math.min(picviewer.width, pic.sourceSize.width * picviewer.picscale)
            height: Math.min(picviewer.height, pic.sourceSize.height * picviewer.picscale)

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: parent.height/2

            contentWidth: pic.sourceSize.width * picviewer.picscale
            contentHeight: pic.sourceSize.height * picviewer.picscale

            Image{
                id: pic
                anchors.centerIn: parent
                scale: picviewer.picscale
                source: funcContainer.picSource
                onStatusChanged: {
                    console.log("onStatusChanged Image.Ready == pic.status", pic.status);
                    console.log("pic.sourceSize.height = ", pic.sourceSize.height);
                    if(Image.Ready == pic.status){
                        slider.value = Math.floor(picviewer.calcscale() * 100);
                    }

                    if(Image.Loading != pic.status){
                        funcContainer.makeWaitingDialogVisible(false);
                    }
                }
            }

            onContentWidthChanged: {
                if((flic.contentWidth > picviewer.width)
                        && (0 !== flic.oldContentWidth)
                        && (0 !== picviewer.width) ){
                    flic.contentX += (flic.contentWidth - flic.oldContentWidth)/2;
                }

                flic.oldContentWidth = flic.contentWidth;
            }
            onContentHeightChanged: {
                if((flic.contentHeight > picviewer.height)
                        && (0 !== flic.oldContentHeight)
                        && (0 !== picviewer.height)) {
                    flic.contentY += (flic.contentHeight - flic.oldContentHeight)/2;
                }
                flic.oldContentHeight = flic.contentHeight;
            }
            MouseArea{
                anchors.centerIn: parent
                width: Math.max(flic.contentWidth, picviewer.width)
                height: Math.max(flic.contentHeight, picviewer.height)
                onClicked: {
                    funcContainer.showToolBar = !funcContainer.showToolBar;
                }

                onDoubleClicked: {
                    slider.value = Math.floor(picviewer.calcscale() * 100);
                }
            }
        }

    }

    tools: ToolBarLayout {
        id: toolbar
        ToolIcon { iconId: "icon-m-toolbar-back";
            onClicked: {
                funcContainer.showStatusBar = true;
                listPage.viewBack();
            }
        }
        Slider {
            id: slider
            width: parent.width * 0.72
            anchors.horizontalCenter: parent.horizontalCenter
   
            minimumValue: 1; maximumValue: 100; stepSize: 1
            valueIndicatorVisible: true
            valueIndicatorText: slider.value + "%"
            visible: Image.Ready == pic.status
        }

        ToolIcon {
            iconSource: "images/icon_cancel.png"
            visible: funcContainer.isEditable
            onClicked: {
                funcContainer.isPicDeleted = true;
                funcContainer.showStatusBar = true;
                listPage.viewBack();
            }
        }
    }

    Component.onCompleted: {
        funcContainer.showStatusBar = false;
        if(Image.Loading == pic.status){
            funcContainer.makeWaitingDialogVisible(true);
        }
    }
}

