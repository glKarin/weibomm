import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0

//WebView {

//id:sinaweiboweb

//url: emotionlist.GetLinkPath()
//preferredWidth: 490

//preferredHeight: 400

//scale: 0.5

//smooth: false

//}

import "controls"



Page {
    id: webBrowser

    property string urlString :funcContainer.webviewurl

    width: parent.width; height: parent.height

/*--------------------title bar and tool bar for IE-----------------------*/
    AccTitleBar{
        id: headerSpace
        width: parent.width
        height: 65
        title: "浏览器"
        anchors.top: parent.top
        z:webView.z+1

        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 20
            source: "images/icon_home_white_bluebg_50x50.png"
            MouseArea{
                id: changmsgbut
                anchors.fill: parent
                onClicked: {
                    funcContainer.hometabindex = 0;
                    listPage.changePage(12);
                }
            }
            Rectangle{
                anchors.fill: parent
                color: "blue"
                radius: 12
                opacity: 0.3
                visible: changmsgbut.pressed;
            }
        }
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.right: parent.right
            anchors.rightMargin: 50
            radius: 2
            height: 4
            color: "#CCCCFF"
            Rectangle{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * webView.progress
                height: parent.height
                radius: 2
                color: "#3399FF"
            }
            opacity: webView.progress == 1.0 ? 0.0 : 1.0
        }
    }

    //tool bar without delete button
    ToolBarLayout {
        id: toolbar
        visible: true
        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: {
                listPage.viewBack();
            }
        }

//        ToolIcon {
//            iconSource: "images/WebView/go-previous-view.png";
//            onClicked: {
//                console.log("previous");
//                webView.back.trigger();
//            }
//        }
        Item{
            height: 100
            width: funcContainer.inPortrait? 50:150
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ButtonRow {
            id: btnRow
            //width: 140
            //height:toolbar.height
            exclusive: false

            Button {
                id: btn1
                iconSource: "images/button-left.png"
                enabled:webView.back.enabled
                onClicked: {
                    webView.back.trigger();
                }
            }

            Button {
                id: btn2
                iconSource: "images/button-right.png"
                enabled:webView.forward.enabled
                onClicked: {
                    webView.forward.trigger();
                }
            }

        }
//        ToolIcon {
//            iconSource: "images/WebView/go-next-view.png";
//            onClicked: {
//                console.log("next");
//                webView.forward.trigger();
//            }
//        }
        Item{
            height: 100
            width: funcContainer.inPortrait? 50:150
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolIcon {
            iconSource: "images/icon_refresh.png";
            onClicked: {
                webView.reload.trigger();
            }
        }
    }

    tools:toolbar

/*--------------------title bar and tool bar for IE-----------------------*/


    WebViewFlickableWebView {
        id: webView
        url: webBrowser.urlString
        //onProgressChanged: header.urlChanged = false
        anchors { top: headerSpace.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }

    }

//    Item { id: headerSpace; width: parent.width; height: 62 }

//    WebViewHeader {
//        id: header
//        editUrl: webBrowser.urlString
//        width: headerSpace.width; height: headerSpace.height
//    }

//    WebViewScrollBar {
//        scrollArea: webView; width: 8
//        anchors { right: parent.right; top: headerSpace.bottom; bottom: parent.bottom }
//    }

//    WebViewScrollBar {
//        scrollArea: webView; height: 8; orientation: Qt.Horizontal
//        anchors { right: parent.right; rightMargin: 8; left: parent.left; bottom: parent.bottom }
//    }
}
