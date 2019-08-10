import QtQuick 1.0
import com.nokia.meego 1.0

Rectangle {
    id:mainRec
    anchors.fill: parent
    property string smallSource
    property string bigSource
    signal imageClicked
    color: "transparent"
    Rectangle{
        color: "black"
        anchors.fill: parent
        opacity: 0.4
    }
    Rectangle {
        id:picRec
        color: "white"
        border.width: 5
        border.color: "gray"
        radius: 10
        anchors.centerIn: parent
//        width: {
//            if(bigPic.status != Image.Ready) return smallPic.sourceSize.width+20;
//            if(bigPic.sourceSize.width/bigPic.sourceSize.height >= mainRec.width/mainRec.height) return mainRec.width>bigPic.sourceSize.width+40? bigPic.sourceSize.width+20:mainRec.width-20;
//            else return
//        }
        width: bigPic.status == Image.Ready? bigPic.paintedWidth+20:smallPic.sourceSize.width+20
        height: bigPic.status == Image.Ready? bigPic.paintedHeight+20:smallPic.sourceSize.height+20
        Image {
            id: smallPic
            anchors.top: picRec.top
            anchors.topMargin: 10
            anchors.left: picRec.left
            anchors.leftMargin: 10
            source: smallSource
            visible: bigPic.status != Image.Ready
                BusyIndicator {
                    anchors.centerIn: smallPic
                    running: true
                }
        }
//        ParallelAnimation {
//            id:bigger
//            running: false
//            //NumberAnimation { target: picRec; property: "width"; to: mainRec.width > bigPic.sourceSize.width+40? bigPic.sourceSize.width+20:mainRec.width-20; duration: 200 }
//            //NumberAnimation { target: picRec; property: "height"; to:  mainRec.height > bigPic.sourceSize.height+40? bigPic.sourceSize.height+20:mainRec.height-20; duration: 200 }
//            //NumberAnimation { target: bigPic; property: "width"; to: mainRec.width > bigPic.sourceSize.width+40? bigPic.sourceSize.width:mainRec.width-40; duration: 200 }
//            //NumberAnimation { target: bigPic; property: "height"; to: mainRec.height > bigPic.sourceSize.height+40? bigPic.sourceSize.height:mainRec.height-40; duration: 200 }
//            NumberAnimation { target: bigPic; property: "width"; to: mainRec.width-40; duration: 200 }
//            NumberAnimation { target: bigPic; property: "height"; to: mainRec.height-100; duration: 200 }
//        }
    }
    Image {
        id: bigPic
        fillMode: Image.PreserveAspectFit
        width: {
            if(mainRec.width-40 > bigPic.sourceSize.width && mainRec.height-100 > bigPic.sourceSize.height && bigPic.status == Image.Ready) return bigPic.sourceSize.width
            else return bigPic.status == Image.Ready? mainRec.width-40:smallPic.sourceSize.width
        }
        height: {
            if(mainRec.width-40 > bigPic.sourceSize.width && mainRec.height-100 > bigPic.sourceSize.height && bigPic.status == Image.Ready) return bigPic.sourceSize.height
            else return bigPic.status == Image.Ready? mainRec.height-100:smallPic.sourceSize.height
        }
//            anchors.top: picRec.top
//            anchors.topMargin: 10
//            anchors.left: picRec.left
//            anchors.leftMargin: 10
        anchors.centerIn: picRec
        source: bigSource
//            State { name: 'loaded'; when: bigPic.status = Image.Ready }
//            onStatusChanged: {
//                if (bigPic.status == Image.Ready){
//                    bigger.running = true;
////                    console.log("width:"+mainRec.width);
////                    console.log("height:"+mainRec.height);
////                    console.log("sourceWidth:"+bigPic.sourceSize.width);
////                    console.log("sourceHeight:"+bigPic.sourceSize.height);
//                }
//            }
        Behavior on width{
            NumberAnimation{duration: 200}
        }
        Behavior on height{
            NumberAnimation{duration: 200}
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            imageClicked();
        }
    }
}
