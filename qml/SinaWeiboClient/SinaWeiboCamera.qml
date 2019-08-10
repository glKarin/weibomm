import QtQuick 1.0
import com.nokia.meego 1.0
import QtMultimediaKit 1.1

Page {
    id : cameraUI
    anchors.fill: parent
//    orientationLock: PageOrientation.LockLandscape

    property int flashType: 0
    property real cameraScale: slider.value / 100
    property bool showSlider: false

    MouseArea{
        anchors.fill: parent

        onReleased: {
            showSlider = true;
        }
    }

    Camera {
        id: camera
//        anchors.fill: parent
//        anchors.top: parent.top
//        anchors.left: parent.left
        rotation: funcContainer.inPortrait ? 90 : 0
        anchors.centerIn: parent
        width: 854
        height:  480
        focus: visible
        flashMode: {
            if(flashType == 0) {
                return Camera.FlashAuto;
            }
            else if(flashType == 1) {
                return Camera.FlashOn;
            }
            else if(flashType == 2) {
                return Camera.FlashOff;
            }
        }
        digitalZoom: cameraScale
        whiteBalanceMode: Camera.WhiteBalanceAuto
        exposureCompensation: -1.0
        captureResolution: Qt.size(854, 480)

        onImageSaved: {
            console.log("onImageSaved:  " + path);
            funcContainer.savedImageSrc = path;
        }

        onImageCaptured: {
            listPage.changePage(44);
        }
    }

    ButtonRow {
        id: btnRow
        width: 140
        opacity: 0.7
        exclusive: false
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        Button {
            id: btn1
            height: 60
            iconSource: "images/flash.png"
            text: "自动"

            onClicked: {
                if(btn2.visible && btn3.visible) {
                    btn2.visible = false;
                    btn3.visible = false;
                    btnRow.width = 140;
                }
                else {
                    btn2.visible = true;
                    btn3.visible = true;
                    btnRow.width = 400;

                    btn1.text = "自动";
                }
            }

            onTextChanged: {
                if(btn1.text == "自动") {
                    cameraUI.flashType = 0;
                }
                else if(btn1.text == "打开") {
                    cameraUI.flashType = 1;
                }
                else if(btn1.text == "关闭") {
                    cameraUI.flashType = 2;
                }
            }
        }

        Button {
            id: btn2
            height: 60
            text: "打开"
            visible: false;

            onClicked: {
                btn2.visible = false;
                btn3.visible = false;
                btnRow.width = 140;

                btn1.text = btn2.text;
            }
        }


        Button {
            id: btn3
            height: 60
            text: "关闭"
            visible: false;

            onClicked: {
                btn2.visible = false;
                btn3.visible = false;
                btnRow.width = 140;

                btn1.text = btn3.text;
            }
        }

        Behavior on width{
            NumberAnimation{duration: 100}
        }
    }

    Rectangle {
        id: sliderContainer
        opacity: 0.5
        width: parent.width * 0.7
        height: 25
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -50
        visible: showSlider
        color:  "transparent"

        Image{
            id:leftBtn
            source: "images/Zoombar 1.png"
            smooth: true
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: 30
            MouseArea {
                anchors.fill: parent

                onReleased: {
                    slider.value -= 10;
                    timer2.running = false;
                }

                onPressAndHold: {
                    slider.value -= 10;
                    timer2.running = true;
                }
            }
        }

        Image{
            id:rightBtn
            source: "images/Zoombar 2.png"
            smooth: true
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 30
            MouseArea {
                anchors.fill: parent

                onReleased: {
                    slider.value += 10;
                    timer1.running = false;
                }

                onPressAndHold: {
                    timer1.running = true;
                }
            }
        }

        Timer {
            id: timer1
            interval: 200;
            running: false;
            repeat: true;
            onTriggered: {
                slider.value += 10;
            }
        }
        Timer {
            id: timer2
            interval: 200;
            running: false;
            repeat: true;
            onTriggered: {
                slider.value -= 10;
            }
        }

        Slider {
            id: slider

            anchors.left: leftBtn.right
            anchors.leftMargin: -15
            anchors.right: rightBtn.left
            anchors.rightMargin: -15
            anchors.verticalCenter: parent.verticalCenter

            minimumValue: 100; maximumValue: 400; stepSize: 1
            valueIndicatorVisible: false


            __handleItem: Image {
                source: "images/handleItem.png"
                width: 30
                height: 30
            }

            __grooveItem: BorderImage {
                source: "images/Zoombar 3.png"
                border { left: 6; top: 4; right: 6; bottom: 4 }
                height: 30

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
            }

            __valueTrackItem: BorderImage {
                source: "images/Zoombar 3.png"
                border { left: 6; top: 4; right: 6; bottom: 4 }
                height: 0

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }

    Button{
        id: captureBtn
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20

        width: 48
        height: 46

        opacity: 0.5

        iconSource: "images/camera.png"

        onClicked: {
            camera.captureImage();
        }
    }

    Button{
        id: backBtn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 20

        width: 48
        height: 46

        opacity: 0.5

        iconSource: "images/x.png"

        onClicked: {
//            funcContainer.showStatusBar = true;
            listPage.viewBack();
        }
    }

    Component.onCompleted: {
        funcContainer.showStatusBar = false;
        funcContainer.savedImageSrc = "";
    }
}
