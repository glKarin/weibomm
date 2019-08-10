import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"

Page{
    id:previewPage
    anchors.fill:parent

    orientationLock: PageOrientation.LockLandscape

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    Image {
        id: preview
        //anchors.fill : parent
        anchors.centerIn: parent
        width: parent.width;
        height: parent.height + 5
        sourceSize.width: width;
        sourceSize.height: height
        //fillMode: Image.PreserveAspectFit
        source: funcContainer.savedImageSrc;
        smooth: true
    }

    Button {
        text:"使用"
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        height: 60
        width: 140
        opacity: 0.5
        onClicked: {
            funcContainer.showStatusBar = true;
            funcContainer.selectImageSrc = funcContainer.savedImageSrc;
            console.log("onClicked:  "+funcContainer.selectImageSrc);
            listPage.jumpPageTo(11);
        }
    }

    Button {
        text:"重拍"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        height: 60
        width: 140
        opacity: 0.5
        onClicked:{
            listPage.viewBack();
            funcContainer.savedImageSrc = "";
        }
    }
}
