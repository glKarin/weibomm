import QtQuick 1.1

Item
{
    id:introductory
    width: backGround.width
    height: backGround.height
    property bool hasIcon:false;
    property int fontSize: 20
    property string bgPath;
    property string iconPath;
    property string vipPath;
    property string markPath;
    property bool isVip:false
    property bool hasMark:false
    property string content;
    property string contentColor:"black"
    property string pressColor:"steelblue"
    property string pressImage
    property int iconWidth:64
    property int iconHeight: 64
    property int vipWidth:24
    property int vipHeight: 24
    property int markWidth:48
    property int markHeight: 48
    property int markX:300
    property int markY: 20
    property int textX:100
    property int textY: 30
    property bool limitWord: false
    signal clicked;
    Image
    {
        id: backGround
        width: parent.width
        height: parent.height
        fillMode:Image.Stretch
        source: bgPath
        smooth:true
    }

    Image
    {
        id: press
        width: parent.width
        height: parent.height
        fillMode:Image.Stretch
        source: pressImage
        smooth:true
        visible: mousefocus.pressed
    }

    Rectangle {
        id: highLight
        width:parent.width
        height:parent.height
        radius:10;
        color:pressColor
        opacity:if(pressImage == "") {0.4}else {0}
        visible: mousefocus.pressed
    }

    //Image
    Item{
        id: icon
        width: 80; height: 80
        anchors.top: parent.top;  anchors.left: parent.left
        visible:hasIcon
        Image {
            width: 64; height: 64
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
            source: iconPath;
            Image {
                id: mask
                anchors.fill: parent
                smooth: true
                source: "../images/mask_userimage_gradientbg.png"
            }

            Image{
                id:vipBadge
                anchors.right: parent.right; anchors.top: parent.top
                source: vipPath
                visible: isVip;
                smooth: true
            }
        }
    }


    Text
    {
        id:contentText
        x:textX;
        y:textY;
        width: if(limitWord) {200} else {parent.width}
        text:content;
        color:contentColor;
        smooth:true;
        font.pixelSize: fontSize;
        font.bold: true
        elide: Text.ElideRight
    }

    Image
    {
        id: mark
        x:markX
        y:markY
        width: markWidth
        height: markHeight
        visible:hasMark
        source: markPath
        smooth:true
    }

    MouseArea
    {
        id:mousefocus
        anchors.fill: parent;
        onClicked:
        {
            introductory.clicked();
        }
    }
}
