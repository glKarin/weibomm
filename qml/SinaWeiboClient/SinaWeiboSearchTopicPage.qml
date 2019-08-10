import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeFstPage

Page
{
    id:searchTopicPage
    anchors.fill:parent

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccSearchBar {
        id: searchBar
        width: parent.width
        height: 65
        myStyle: 1
        textContent: funcContainer.searchTopic
        z: searchlist.z + 1
        onClicked:{
            if(searchBar.textContent != "")
            {
                console.log("search text:", searchBar.textContent);
                searchTopicModel.searchTopicFromModel(searchBar.textContent);
            }
            else
            {
                setFocusActived();
            }
        }
        onSearchTextChanged: {
            console.log("search text:", searchBar.textContent);
            searchTopicModel.searchTopicFromModel(searchBar.textContent);
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
    }

    tools: toolbar


    SinaWeiboSearchTopicList{
        id: searchlist
        anchors.top: searchBar.bottom
        width: parent.width
        height: parent.height-toolbar.height
        myModel: searchTopicModel
        listCount:searchTopicModel.reflashCount
        onItemClicked:{
            console.log("==onItemClicked==  index = ",index);
            if(index == searchTopicModel.reflashCount - 1)
            {
                //jianhui
                funcContainer.showStatusOfTrend = false;
                listPage.changePage(32);
            }
            else
            {
                funcContainer.insertTopic = searchTopicModel.getTopicByIndex(index);

                settingModel.saveRecentTopic(loginModel.userID,funcContainer.insertTopic);

                console.log("add topic to database!");
                insertTopicModel.setRecentTopicToModel(funcContainer.insertTopic);


                //0--NewMicroBlog, 1--Comment, 2--Forword , 3--Message
                if(funcContainer.microBlogId == 0)
                    listPage.jumpPageTo(11);
                else if(funcContainer.microBlogId == 1)
                    listPage.jumpPageTo(9);
                else if(funcContainer.microBlogId == 2)
                    listPage.jumpPageTo(8);
                else if(funcContainer.microBlogId == 3)
                    listPage.jumpPageTo(25);
                else if(funcContainer.microBlogId == 4)
                    listPage.jumpPageTo(45);
                searchTopicModel.selectTopicItemFinished();
            }
        }
    }

    Component.onCompleted:
    {
        searchTopicModel.setListTailText("热门话题");
        searchTopicModel.searchTopicFromModel(funcContainer.searchTopic);
        console.log("list count: ",searchTopicModel.getCount());
    }

    Component.onDestruction:
    {
        funcContainer.searchTopic = "";
    }

}



