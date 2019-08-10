import QtQuick 1.1
import "controls"

ListView
{
    id: itemlist
    property int readMode: 0
    property bool allowRefresh: false
    property bool needRefresh: !itemlist.model.isReadingDB

    signal itemlistscrolled(int type);
    signal itemSelected(int index);
    signal showStatusImage(int index);
    signal showForwardImage(int index);

    Rectangle {
        id: updateBanner
        height: 100;
        anchors.left: parent.left;
        anchors.right: parent.right
        visible: needRefresh
        y: itemlist.visibleArea.yPosition > 0 ? -height : -(itemlist.visibleArea.yPosition * Math.max(itemlist.height, itemlist.contentHeight)) - height
        color: "transparent";

        Image{
            id: img
            source: "images/Drop-down arrow.png"
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 50

            states: [
                State {
                    name: "rotated"
                    PropertyChanges { target: img; rotation: 180 }
                },
                State {
                    name: "rotatedBack"
                    PropertyChanges { target: img; rotation: 0 }
                }

            ]

            transitions: Transition {
                RotationAnimation { duration: 200; }
            }
        }

        // Text shown in the banner
        Text {
            id: topText;
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: img.right
            anchors.leftMargin: if(parent.width > 700) {280} else {100}

            text:  itemlist.allowRefresh ? "松开即可刷新..." : "下拉可以刷新...";
            font.pixelSize: 20
        }

        Image{
            id: line
            source: "images/Thread.png"
            smooth: true
            anchors.bottom: parent.bottom
            width: parent.width
        }

        onYChanged: {
            if (itemlist.flicking) return;
            var contentYPos = itemlist.visibleArea.yPosition * Math.max(itemlist.height, itemlist.contentHeight);
            if(itemlist.needRefresh) {
                if ( (contentYPos < funcContainer.listDragDistance) && itemlist.moving ) {
                    itemlist.allowRefresh = true;
                    img.state = "rotated";
                }
            }
        }
    }

    focus: true
    delegate:AccListSina
    {
        showPic: readMode
        onItemClicked:
        {
            itemlist.itemSelected(index);
        }

        onStatusImageClicked:{
            itemlist.showStatusImage(index);
        }

        onForwardImageClicked:{
            itemlist.showForwardImage(index);
        }
    }
    orientation: ListView.Vertical
    flickDeceleration: 1000

    onMovementEnded:
    {
        if(itemlist.model.count != 0)
        {
            if(itemlist.atYEnd)
            {
                if(needRefresh && itemlist.allowRefresh) {
                    img.state = "rotatedBack";
                    itemlist.allowRefresh = false;
                    itemlist.itemlistscrolled(0);
                }
                else {
                    console.log("itemlist.model.atYEnd");
                    itemlist.itemlistscrolled(2);
                }
            }
            else if (itemlist.atYBeginning) {
                if(needRefresh) {
                    img.state = "rotatedBack";
                    if(itemlist.allowRefresh) {
                        itemlist.allowRefresh = false;
                        itemlist.itemlistscrolled(0);
                    }
                }
                else {
                    itemlist.itemlistscrolled(1);
                }
            }
        }
        else {
            img.state = "rotatedBack";
            if(itemlist.allowRefresh) {
                itemlist.allowRefresh = false;
                itemlist.itemlistscrolled(0);
            }
        }
    }

    /*onContentYChanged: {
        if(needRefresh) {
            if(itemlist.contentY < funcContainer.listDragDistance) {
                itemlist.allowRefresh = true;
                img.state = "rotated";
            }
        }
    }*/
}

