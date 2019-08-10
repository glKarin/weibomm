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
        textContent: funcContainer.searchContact
        z: searchlist.z + 1
        onClicked:{
            if(searchBar.textContent != "")
            {
                console.log("begin search text:", searchBar.textContent);

                if(funcContainer.contactsType == 0)
                {
                    searchContactModel.searchContactFromModel(funcContainer.searchContact, funcContainer.contactsType);
                }
                else if(funcContainer.contactsType == 1)
                {
                    searchContactModel.searchContactFromModel(funcContainer.searchContact, funcContainer.contactsType, "无结果");
                }
                console.log("end search text:", searchBar.textContent);
            }
            else
            {
                setFocusActived();
            }
        }
        onSearchTextChanged: {
            funcContainer.searchContact = searchBar.textContent;
            console.log("search text:", searchBar.textContent);
            if(funcContainer.contactsType == 0)
            {
                searchContactModel.searchContactFromModel(funcContainer.searchContact, funcContainer.contactsType);
            }
            else if(funcContainer.contactsType == 1)
            {
                searchContactModel.searchContactFromModel(funcContainer.searchContact, funcContainer.contactsType, "无结果");
            }
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


    SinaWeiboSearchContactsList{
        id: searchlist
        anchors.top: searchBar.bottom
        width: parent.width
        height: parent.height-toolbar.height
        myModel: searchContactModel
        listCount:searchContactModel.reflashCount
        onItemClicked:{
            console.log("==onItemClicked==  index = ",index);
            if(index == searchContactModel.reflashCount - 1)
            {
                if(funcContainer.contactsType == 0)
                {
                    if(searchBar.textContent == "")
                    {
                        popup.open();
                    }
                    else
                    {
                    //jianhui
                    funcContainer.showUserInfo = false;
                    funcContainer.searchContent = searchBar.textContent;
                    listPage.changePage(22);
                    }
                }
                else if(funcContainer.contactsType == 1)
                {
                    listPage.changePage(31);
                }

            }
            else
            {
                if(funcContainer.contactsType == 0)
                {
                    funcContainer.insertContact = searchContactModel.getContactByIndex(index);
                    console.log("==microBlogId: ",funcContainer.microBlogId);
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
                    searchContactModel.selectContactItemFinished();
                }
                else if(funcContainer.contactsType == 1)
                {
                    if(searchContactModel.getContactByIndex(index) == "无结果"
                            && searchContactModel.getContactGroupByIndex(index) == "@")
                    {
                    }
                    else
                    {
                        funcContainer.senderScreenName = searchContactModel.getContactByIndex(index);
                        funcContainer.userIDInMyProfilePage = searchContactModel.getContactIDByIndex(index);
                        if(funcContainer.microBlogId == 0)
                            listPage.jumpPageTo(11);
                        else if(funcContainer.microBlogId == 1)
                            listPage.jumpPageTo(9);
                        else if(funcContainer.microBlogId == 2)
                            listPage.jumpPageTo(8);
                        else if(funcContainer.microBlogId == 3)
                            listPage.jumpPageTo(25);
                    }
                }

            }
        }
    }

    Component.onCompleted:
    {
        if(funcContainer.contactsType == 0)
        {
            searchContactModel.setListTailText("在网络上搜索");
            searchContactModel.searchContactFromModel(funcContainer.searchContact, funcContainer.contactsType);
        }
        else if(funcContainer.contactsType == 1)
        {
            searchContactModel.setListTailText("从关注列表中添加");
            searchContactModel.searchContactFromModel(funcContainer.searchContact, funcContainer.contactsType, "无结果");
        }

        console.log("list count: ",searchContactModel.getCount());
    }

    Component.onDestruction:
    {
        funcContainer.searchContact = "";
    }

    QueryDialog {
        id: popup

        message: "请输入搜索关键字"
        acceptButtonText: "确定"
        //onAccepted: listPage.viewBack();
    }
}



