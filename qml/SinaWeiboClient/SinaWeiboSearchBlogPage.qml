import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeSearchBlogPage

Page
{
    id:searchBlogPage
    anchors.fill:parent
    property int pageWdith: parent.width

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccTitleBar{
        id: searchBlogPageTitle
        width: parent.width
        height: 65
        title:"搜索微博"
        anchors.top: parent.top
        z: searchBlogPageList.z + 1
    }

    SinaWeiboItemList{
        id: searchBlogPageList
        anchors.top: searchBlogPageTitle.bottom
        width: parent.width
        height: parent.height-searchBlogPageTitle.height
        model: searchBlogModel
        onItemlistscrolled:{
            console.log("==onItemlistscrolled==  type = ", type);
            searchBlogModel.searchBlogFromModel(type, funcContainer.searchContent);
        }
        onItemSelected:{
            console.log("==onItemSelected==  index = ",index);
            funcContainer.statusIDInDetailPage = searchBlogModel.getStudusId(index);
            listPage.changePage(6);
        }
        onShowStatusImage:{
            funcContainer.showDetailImage(searchBlogModel.getImageAddress(0,index),searchBlogModel.getImageAddress(1,index));
            //funcContainer.showStateImage(4,index);
        }
        onShowForwardImage:{
            funcContainer.showDetailImage(searchBlogModel.getImageAddress(2,index),searchBlogModel.getImageAddress(3,index));
            //funcContainer.showForwardImage(4,index);
        }
    }

    Component.onCompleted:
    {
        searchBlogModel.searchBlogResult.connect(searchBlogPage.searchBlogResult);
        searchBlogModel.searchBlogFromModel(0, funcContainer.searchContent);
    }

    Component.onDestruction:{
        if(null === searchBlogModel){
            console.log("=======searchBlogModel has been deleted======");
        }
        else{
            searchBlogModel.clearData();
            searchBlogModel.searchBlogResult.disconnect(searchBlogPage.searchBlogResult);
        }
    }

    function searchBlogResult(errCode)
    {
        console.log("ListFinished.qml errCode:", errCode)
        //Processing
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if(200 != errCode) {
                funcContainer.showPopup(ErrorCodeSearchBlogPage.getErrorInfo(errCode));
            }
            else{
                if(searchBlogModel.hasData() == false) {
                    popup.open();
                }
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
    }

    tools: toolbar

    QueryDialog {
        id: popup

        message: "无记录"
        acceptButtonText: "确定"
        onAccepted: listPage.viewBack();
    }
}
