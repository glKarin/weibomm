import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeFstPage

Page
{
    id:frequentContactsPage
    anchors.fill:parent
//    color: "transparent"
    property int pageWdith: parent.width

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    AccTitleBar{
        id: homepagetitle
        width: parent.width
        height: 65
        title:"常用联系人"
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
                funcContainer.searchContact = searchBar.textContent;
                if(searchBar.textContent != "")
                    listPage.changePage(30);
                searchBar.textContent = "";
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
//                    listPage.changePage(30);
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


    SinaWeiboFrequentContactsList{
        id: topiclist
        anchors.top: searchBar.bottom
        width: parent.width
        height: parent.height-homepagetitle.height-toolbar.height
        myModel: frequentContactModel
        onItemClicked:{
            console.log("==onItemClicked==  index = ",index);
            if(funcContainer.contactsType == 0)
            {
            funcContainer.insertContact = frequentContactModel.getContactByIndex(index);
            listPage.viewBack();
            frequentContactModel.selectContactItemFinished();
            }
            else if(funcContainer.contactsType == 1)
            {
                funcContainer.senderScreenName = frequentContactModel.getContactByIndex(index);
                funcContainer.userIDInMyProfilePage = frequentContactModel.getContactIDByIndex(index);
                listPage.viewBack();
            }
        }
    }

    Component.onCompleted:
    {
       // frequentContactModel.setListHeaderText("最近使用");
        frequentContactModel.setListTailText("其它");
       // frequentContactModel.setRecentContact(settingModel.loadRecentTopic());
        frequentContactModel.getFrequentContactsFromModel();


    }

}



