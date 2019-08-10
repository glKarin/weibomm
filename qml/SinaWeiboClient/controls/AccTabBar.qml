import QtQuick 1.0

Rectangle {
    id:tabbar
    width: 300
    height: 50
    radius: 20

    property int count: 0
    property int commentCount : 0
    property int mentionCount : 0
    property int privateMsgCount : 0

    signal tabChanged
/*
    Image {
        id: bgsource
        anchors.fill: parent
        source: "../images/tabbg.png"
    }
    Image {
        id:hlsource
        width: parent.width/3
        height: parent.height
        x:tabbar.count*parent.width/3
        y:0
        source: "../images/tabbghl.png"
    }
    */
    Image {
        id:oneI
        anchors.left: parent.left
        height: parent.height
        width: parent.width/3
        source: tabbar.count==0? "../images/@ me_press.png":"../images/@ me.png"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                tabbar.count = 0;
                tabbar.tabChanged();
            }
        }

        Image {
            visible: mentionCount > 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset:  30
            source: "../images/Digital_Tips.png"

            Text{
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                text: {
                    if(mentionCount < 100) {
                        return mentionCount;
                    }
                    else {
                        return "..."
                    }
                }
            }
        }
    }
    Image {
        id:twoI
        anchors.left: oneI.right
        height: parent.height
        width: parent.width/3
        source: tabbar.count==1? "../images/Comment Box_press.png":"../images/Comment Box.png"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                tabbar.count = 1;
                tabbar.tabChanged();
            }
        }

        Image {
            visible: commentCount > 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset:  40
            source: "../images/Digital_Tips.png"

            Text{
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                text: {
                    if(commentCount < 100) {
                        return commentCount;
                    }
                    else {
                        return "..."
                    }
                }
            }
        }
    }
    Image {
        id:threeI
        anchors.left: twoI.right
        height: parent.height
        width: parent.width/3
        source: tabbar.count==2? "../images/Private letter_press.png":"../images/Private letter.png"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                tabbar.count = 2;
                tabbar.tabChanged();
            }
        }

        Image {
            visible: privateMsgCount > 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset:  30
            source: "../images/Digital_Tips.png"

            Text{
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                text: {
                    if(privateMsgCount < 100) {
                        return privateMsgCount;
                    }
                    else {
                        return "..."
                    }
                }
            }
        }
    }
//    AccTabBarItem{
//        id:oneI
//        anchors.left: parent.left
//        height: parent.height
//        width: parent.width/3
//        //currentOne: tabbar.count == 0? true:false
//        notRightOne: true
//        content: "@我"
//        onClickthis: {
//            tabbar.count = 0;
//            tabbar.tabChanged();
//        }
//    }

//    AccTabBarItem{
//        id:twoI
//        anchors.left: oneI.right
//        height: parent.height
//        width: parent.width/3
//        //currentOne: tabbar.count == 1? true:false
//        notRightOne: true
//        content: "评论箱"
//        onClickthis: {
//            tabbar.count = 1;
//            tabbar.tabChanged();
//        }
//    }
//    AccTabBarItem{
//        id:threeI
//        anchors.left: twoI.right
//        height: parent.height
//        width: parent.width/3
//        //currentOne: tabbar.count == 2? true:false
//        notRightOne: false
//        content: "私信"
//        onClickthis: {
//            tabbar.count = 2;
//            tabbar.tabChanged();
//        }
//    }
}
