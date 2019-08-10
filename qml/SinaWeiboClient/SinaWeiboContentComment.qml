import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeCommentPage


Page
{
    id:contentCommentPage
    anchors.fill:parent
    property int pageWdith: parent.width

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccTitleBar{
        id: contentCommenttitle
        width: parent.width
        height: 65
        title:"微博评论"
        anchors.top: parent.top
        z: cententCommentList.z + 1
    }

    AccTitleBar{
        id: timearea
        width: parent.width
        height: 40
        title: "最后更新:" + contentCommentModel.reflashTime
        textcolor: "black"
        titlesize: 18
        bgsource: "../images/refreshtimebg.png"
        anchors.top: contentCommenttitle.bottom
        z: cententCommentList.z + 1
    }

    SinaWeiboItemList{
        id: cententCommentList
        anchors.top: timearea.bottom
        width: parent.width
        height: parent.height-contentCommenttitle.height-timearea.height
        model: contentCommentModel
        readMode: funcContainer.readMode
        onItemlistscrolled:{
            console.log("==begin onItemlistscrolled==  type = ", type);
            contentCommentModel.getContentCommentFromModel(funcContainer.commentStatusID,type);
            console.log("==end onItemlistscrolled==  type = ", type);
        }
    }

    Component.onCompleted:
    {
        contentCommentModel.getContentCommentResult.connect(contentCommentPage.contentCommentFinished);
        contentCommentModel.getContentCommentFromModel(funcContainer.commentStatusID,0);
    }

    Component.onDestruction:{
        if(null === contentCommentModel){
            console.log("=======contentCommentModel has been deleted======");
        }
        else{
            contentCommentModel.removeAllItemList();
            contentCommentModel.getContentCommentResult.disconnect(contentCommentPage.contentCommentFinished);
        }
    }

    function contentCommentFinished(errCode)
    {
        console.log("getContentCommentResult.qml errCode:", errCode)
        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if((errCode != 40018) && (200 != errCode)) {
                funcContainer.showPopup(ErrorCodeCommentPage.getErrorInfo(errCode));
            }
        }
    }

    //tool bar without delete button
    ToolBarLayout
    {
        id: toolbar
        visible: false
        ToolIcon
        {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: {listPage.viewBack();}
        }

        ToolIcon {
            iconSource: "images/icon_comment.png";
            onClicked: {
                listPage.changePage(9);
            }
        }

        ToolIcon {
            iconSource: "images/icon_refresh.png";
            onClicked: {
                contentCommentModel.getContentCommentFromModel(funcContainer.commentStatusID,0);
            }
        }
    }

    tools: toolbar
}
