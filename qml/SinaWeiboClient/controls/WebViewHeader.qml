
import Qt 4.7
Image {
    id: header

    property alias editUrl: urlInput.url
    property bool urlChanged: false

   //source: "../images/WebView/titlebar-bg.png"; fillMode: Image.TileHorizontally
    source: "../images/titlebg_blue.png"; fillMode: Image.TileHorizontally
    x: webView.contentX < 0 ? -webView.contentX : webView.contentX > webView.contentWidth-webView.width
       ? -webView.contentX+webView.contentWidth-webView.width : 0
    y: {
        if (webView.progress < 1.0)
            return 0;
        else {
            webView.contentY < 0 ? -webView.contentY : webView.contentY > height ? -height : -webView.contentY
        }
    }
    Column {
        width: parent.width

        Item {
            width: parent.width; height: 20
            Text {
                anchors.centerIn: parent
                text: webView.title; font.pixelSize: 14; font.bold: true
                color: "white"; styleColor: "black"; style: Text.Sunken
            }
        }

        Item {
            width: parent.width; height: 40

            WebViewButton {
                id: backButton
                action: webView.back; image: "../images/WebView/go-previous-view.png"
                anchors { left: parent.left; bottom: parent.bottom }
            }

            WebViewButton {
                id: nextButton
                anchors.left: backButton.right
                action: webView.forward; image: "../images/WebView/go-next-view.png"
            }

            WebViewUrlInput {
                id: urlInput
                anchors { left: nextButton.right; right: reloadButton.left }
                image: "../images/WebView/display.png"
                onUrlEntered: {
                    webBrowser.urlString = url
                    webBrowser.focus = true
                    header.urlChanged = false
                }
                onUrlChanged: header.urlChanged = true
            }

            WebViewButton {
                id: reloadButton
                anchors { right: quitButton.left; rightMargin: 10 }
                action: webView.reload; image: "../images/WebView/view-refresh.png"
                visible: webView.progress == 1.0 && !header.urlChanged
            }
            Text {
                id: quitButton
                color: "white"
                style: Text.Sunken
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                width: 60
                text: "返回"
                MouseArea {
                    anchors.fill: parent
                    onClicked: listPage.viewBack()
                }
                Rectangle {
                    width: 1
                    y: 5
                    height: parent.height-10
                    anchors.right: parent.left
                    color: "darkgray"
                }
            }

            WebViewButton {
                id: stopButton
                anchors { right: quitButton.left; rightMargin: 10 }
                action: webView.stop; image: "../images/WebView/edit-delete.png"
                visible: webView.progress < 1.0 && !header.urlChanged
            }

            WebViewButton {
                id: goButton
                anchors { right: parent.right; rightMargin: 4 }
                onClicked: {
                    webBrowser.urlString = urlInput.url
                    webBrowser.focus = true
                    header.urlChanged = false
                }
                image: "../images/WebView/go-jump-locationbar.png"; visible: header.urlChanged
            }
        }
    }
}
