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
            height: 50
            property string section: name[0]
            BorderImage {
                id: background
                anchors.fill: parent
                visible: mouseArea.pressed
                source: "image://theme/meegotouch-list-background-pressed-center"
            }

            Text {
                width: parent.width-35
                elide: Text.ElideRight
                anchors.verticalCenter: parent.verticalCenter
                x: 25
                text: if(name != "") {"#" + name + "#"}
                font.pointSize: 18

            }

//            Image {
            Rectangle{
                anchors.left:  parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
//                source: "images/bg_comments_landscape.png"
                color: "#F0F1F2"
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
            color: "#ADDBE7"
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
