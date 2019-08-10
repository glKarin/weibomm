import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeFstPage

Page
{
    id:insertTopicPage
    anchors.fill:parent

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

//    color: "transparent"
    property int pageWdith: parent.width

//    function refresh(){
//        console.log("insertTopicPage refresh");
//        firstPageModel.getSinaContentFromModel(0);
//    }
//    function activepage(){
//        funcContainer.hometabindex = 0;
//        //do nothing
//    }

    AccTitleBar{
        id: homepagetitle
        width: parent.width
        height: 65
        title:"插入话题"
        anchors.top: parent.top
        z: topiclist.z + 1
    }

    AccSearchBar {
        id: searchBar
        width: parent.width
        height: 65
        anchors.top: homepagetitle.bottom
        z: topiclist.z + 1
        onClicked:{
            console.log("search text:", searchBar.textContent);
            if(searchBar.textContent != "")
            {
                //insertTopicModel.setRecentTopicToModel(searchBar.textContent);
                //insertTopicModel.getRecentTopicFromModel();
                if(searchBar.textContent == "")
                {
                    popup.open();
                }
                else
                {
                    funcContainer.searchTopic = searchBar.textContent;
                    if(searchBar.textContent != "")
                        listPage.changePage(28);
                    searchBar.textContent = "";
                }
            }
            else
            {
                setFocusActived();
            }
        }

//        onSearchTextChanged: {
//            if(searchBar.textContent != "")
//            {
//                funcContainer.searchTopic = searchBar.textContent;
//                if(searchBar.textContent != "")
//                    listPage.changePage(28);
//                searchBar.textContent = "";
//            }
//        }
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
    }

    tools: toolbar


    SinaWeiboRecentTopicList{
        id: topiclist
        anchors.top: searchBar.bottom
        width: parent.width
        height: parent.height-homepagetitle.height-toolbar.height
        myModel: insertTopicModel
        onItemClicked:{
            console.log("==onItemClicked==  index = ",index);
            funcContainer.insertTopic = insertTopicModel.getTopicByIndex(index);
            settingModel.saveRecentTopic(loginModel.userID,funcContainer.insertTopic);
            listPage.viewBack();
            insertTopicModel.selectTopicItemFinished();
        }
    }

    Component.onCompleted:
    {
        insertTopicModel.setListHeaderText("最近使用");
        insertTopicModel.setListTailText("其它");
        insertTopicModel.setRecentTopic(settingModel.loadRecentTopic(loginModel.userID));
        insertTopicModel.getRecentTopicFromModel();


    }

    QueryDialog {
        id: popup

        message: "请输入搜索关键字"
        acceptButtonText: "确定"
    }
}



