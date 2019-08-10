import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    id: aboutPage

//    property bool inPortrait: parent.width < parent.height ? true: false

    Image {
        id: about
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        fillMode: Image.PreserveAspectCrop
//        anchors.fill: parent
        source: funcContainer.inPortrait ? "images/blog_loading.png" : "images/blog_loading_landscape.png"
    }

    Text{
        text: "新浪微博N9版"
        color: "#7b7b7b"
        font.pixelSize: 24
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
    }

    Text{
        text: "Copyright © 1996-2011 SINA 新浪公司版权所有"
        color: "#7b7b7b"
        font.pixelSize: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back"; onClicked: listPage.viewBack();
        }
    }

		//k
		property variant shader; Component.onCompleted: { var w = function() { _UT.ShowWhatIsPlusPlus(about); }; var a = _UT.PlayThemeMusic(aboutPage); a.play(); a.newloop.connect(w); var o = _UT.RenderPatchInfo(about); o.anchors.bottomMargin = funcContainer.platformToolBarHeight + funcContainer.__statusBarHeight; var f = function() { aboutPage.shader = _UT.RenderWaterWare(aboutPage, about); shader.z = -1; shader.clicked.connect(function(x, y){ o._HandleMouseClick(x, o.parent.height - y); }); }; /*screen.minimizedChanged*/Qt.application.activeChanged.connect(function(){ if(aboutPage.shader) { aboutPage.shader.destroy(); aboutPage.shader = null; } if(/*!screen.minimized*/Qt.application.active) { a.play(); f(); } else { a.pause(); } }); f(); _UT.CheckUpdate(true); w(); }
}
