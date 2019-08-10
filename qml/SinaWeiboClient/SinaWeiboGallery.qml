import QtQuick 1.0
import com.nokia.meego 1.0
import QtMobility.gallery 1.1
import QtMultimediaKit 1.1


Page {
    id: gallaryPage
    anchors.fill:parent

    property bool inPortrait: parent.width < parent.height ? true: false
    property int imgSize: inPortrait ? (parent.width / 3 - 0.5) : (parent.width / 5 - 0.5)

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    GridView {
        anchors.fill: parent
        anchors.leftMargin: inPortrait ? 0 : 2
        cellWidth: imgSize
        cellHeight: imgSize
        cacheBuffer:  1024
        smooth: true

        model: DocumentGalleryModel {
            rootType: DocumentGallery.Image
            properties: [ "url" ]
            autoUpdate: true
        }

        delegate: Rectangle {
            width: imgSize
            height: imgSize

            Image {
                asynchronous: true
                source: url
                //fillMode: Image.PreserveAspectCrop
                smooth:  true
                anchors.centerIn: parent
                width: imgSize; height: imgSize
                sourceSize.width: width; sourceSize.height: height
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    funcContainer.selectImageSrc = url;
                    listPage.viewBack();
                }
            }
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: {
                listPage.viewBack();
            }
        }
    }
}
