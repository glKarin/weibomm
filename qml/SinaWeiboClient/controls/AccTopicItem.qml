import QtQuick 1.1


Item
{
    id: sina
    width: parent.width
    height: contentarea.height
    signal itemClicked(int index);

    MouseArea
    {
        id:contentArea
        anchors.fill: parent
        onReleased:
        {
            console.log("Item select" + index);
            parent.itemClicked(index);
        }
    }

    //content
    Item
    {
        id: contentarea
        anchors.left: parent.left
        anchors.top: parent.bottom

        width: parent.width
        height: content.height + 20;
        Text{
            id:content;
            anchors.left: parent.left; anchors.leftMargin: 10
            anchors.top: parent.top; anchors.topMargin: 10
            width: parent.width - 20;
            text: weibocontent//topicContent
            color:"black";
            smooth:true;
            horizontalAlignment:Text.AlignLeft
            wrapMode:Text.WrapAtWordBoundaryOrAnywhere
            font.pointSize: 18
        }

      }

}


