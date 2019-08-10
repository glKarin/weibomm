import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    id: sectionScrollerPage
    property variant myModel
    signal itemClicked(int index);

    ListView {
        id: list
        anchors.fill: parent
        delegate:  Rectangle {
            width: parent.width
            height: 80
            property string section: name[0]
            BorderImage {
                id: background
                anchors.fill: parent
                visible: mouseArea.pressed
                source: "image://theme/meegotouch-list-background-pressed-center"
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
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    smooth: true
                    source: portrait
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
                        visible: isVip
                        smooth: true
                    }
                }
            }

            Text {
                width: parent.width - userphotoarea.width; //height: 30
                elide: Text.ElideRight
                anchors.left: userphotoarea.right
                anchors.verticalCenter: parent.verticalCenter

                x: 25
                text: name
                smooth:true;
                font.pointSize: 18
            }

            Image {
                anchors.left:  parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                source: "images/bg_comments_landscape.png"
                visible: true
            }

            MouseArea
            {
                id:mouseArea
                anchors.fill: parent
                onReleased:
                {
                    console.log("Item select : " + index);
                    sectionScrollerPage.itemClicked(index);
                }
            }
        }

        model: myModel
        section.property: "alphabet"
        section.criteria: ViewSection.FullString
        section.delegate: Rectangle {
            width: list.width
            height: 30
            color: "lightblue" //"#888"
            Text {
                anchors.verticalCenter: parent.verticalCenter
                x: 5
                text: section
                font.pointSize: 22
                color: "lightcyan"
             }
        }
    }


    SectionScroller {
        listView: list
    }
    ScrollDecorator {
        flickableItem: list
    }

}
