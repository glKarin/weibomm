import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboQMLCommonMethod.js" as QMLCommonMethod
import com.nokia.extras 1.0
import QtMultimediaKit 1.1

PageStackWindow {
    id: funcContainer

    property string insertTopic;
    property string searchTopic;
    property string insertContact;
    property string searchContact;

    property string loginName;
    property string loginPw;
    property bool needRefresh: false;
    property bool needRefreshMsg: false
//    property bool needRelogin: false;
    property bool logined: false;
    property int listDragDistance: -120
    property string selectImageSrc: ""
    property string savedImageSrc: ""

    //used for swith view
    property variant replyRetweetedId;
    property variant statusIDInDetailPage;
    property string userIDInMyProfilePage;
    property string userNameInProfilePage;
    property variant repostStatusID;
    property string repostStatusText;
    property variant commentStatusID;
    property int profileId: 0 //0--my profile, 1--anther user profile
    property int microBlogId: 0 //0--NewMicroBlog, 1--Comment, 2--Forword
    property int hometabindex: 0
    property int readMode: 0
    property string searchContent;
    property string topicName;
    property bool showStatusOfTrend: true
    property bool showUserInfo: true
    property string senderScreenName;
    property int indexForMessageCenter:0
    property int contactsType: 0
    //property bool typeForMessage: false //0-message, 1-my friendlist, 2-my fan's friendlist
    property int typeForListContainer: 0 //0--my list, 1-my fan's list, 2-message
    property string myfansId;
    //property string userId;
    property bool listNeedRefresh: true
    property int listContainerTabIndex: 0

    //for picViewer
    property string picSource
    property bool isEditable: false
    property bool isPicDeleted: false

    //for web view
    property string webviewurl

    //for db cache
    property int pageNumforCache: 0

    property bool isshowmoreindicator: true

    property string commentHeader: ""
    //for detail image
//    property string smallPicForDetail
//    property string bigPicForDetail

//    platformStyle: defaultStyle;
//    ApplicationWindowStyle { id: defaultStyle }

    // ListPage is what we see when the app starts, it links to the component specific pages
    initialPage: PageList{}
//    showStatusBar : false
    function showBanner(contenttext){
        banner.text = contenttext;
        banner.show();
    }

    function makeWaitingDialogVisible(type){
        if(type){
            processing.start();
            waitingDialog.visible = true;
        }
        else{
            processing.stop();
            waitingDialog.visible = false;
        }
    }

    function showWaitingDialog(type){
        waitingDialog.visible = type;
    }

    function showPopup(showText){
        popup.popupContent = showText;
        popup.open();
    }

    Timer {
        id: processing
        interval: 45000; running: false; repeat: false;
        onTriggered: {
            processing.running = false;
            makeWaitingDialogVisible(false);
            funcContainer.showPopup("操作超时！");
        }
    }

    Item{
        id:waitingDialog
        visible: false
        anchors.fill: parent;
        z:100
        Rectangle{
            id:shaderLayer
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.height
            color: "darkgray"
            opacity: 0.5
            //radius: funcContainer.style.cornersVisible ? 13 : 0
            MouseArea {
                anchors.fill: parent
            }
        }
        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 100
            width: 100
            BusyIndicator {
                id: busyindicator
                style: BusyIndicatorStyle { size: "large" }
                running:  true
            }
        }

    }

    QueryDialog {
        id: popup
        property string popupContent

        message: popupContent
        acceptButtonText: "确定"
    }

    InfoBanner{
        id: banner
        z:100
        topMargin: 37
    }

    AccDetailPic{
        id:detailPic
        //anchors.fill:parent
        width: parent.width
        height: parent.height
        visible: false
//        smallSource: smallPicForDetail
//        bigSource: bigPicForDetail
        onImageClicked: {
            visible = false
        }
    }

    SoundEffect {
        id: soundEffect
        source: "qrc:msgcome"
    }

    function playnotification(){
        soundEffect.volume = qt_funcView.getSystemVolume() / 100;
        console.log("====soundEffect.volume====", soundEffect.volume);
        soundEffect.play()
    }

    function showDetailImage(smalladdr,bigaddr)
    {
        detailPic.smallSource = smalladdr;
        detailPic.bigSource = bigaddr;
        detailPic.visible = true;
    }
/*
    function showStateImage(cata,index)
    {
        switch(cata)
        {
            case 0:     //for first page
            {
                detailPic.smallSource = firstPageModel.getImageAddress(0,index);
                detailPic.bigSource = firstPageModel.getImageAddress(1,index);
                break;
            }
            case 1:     //for msg page
            {
                detailPic.smallSource = atMeModel.getImageAddress(0,index);
                detailPic.bigSource = atMeModel.getImageAddress(1,index);
                break;
            }
            case 2:     //for my WeiBo list page
            {
                detailPic.smallSource = myWeiboModel.getImageAddress(0,index);
                detailPic.bigSource = myWeiboModel.getImageAddress(1,index);
                break;
            }
            case 3:     //for SuiBianKanKan page
            {
                detailPic.smallSource = suiBianKanModel.getImageAddress(0,index);
                detailPic.bigSource = suiBianKanModel.getImageAddress(1,index);
                break;
            }
            case 4:     //for SearchBlog page
            {
                detailPic.smallSource = searchBlogModel.getImageAddress(0,index);
                detailPic.bigSource = searchBlogModel.getImageAddress(1,index);
                break;
            }
            case 5:     //for TrendsStatus page
            {
                detailPic.smallSource = trendBlogModel.getImageAddress(0,index);
                detailPic.bigSource = trendBlogModel.getImageAddress(1,index);
                break;
            }
            case 6:     //for my Favorites list page
            {
                detailPic.smallSource = myFavoritesModel.getImageAddress(0,index);
                detailPic.bigSource = myFavoritesModel.getImageAddress(1,index);
                break;
            }
            default:
            {
                detailPic.smallSource = "";
                detailPic.bigSource = "";
            }
        }
        detailPic.visible = true;
    }
    function showForwardImage(cata,index)
    {
        switch(cata)
        {
            case 0:     //for first page
            {
                detailPic.smallSource = firstPageModel.getImageAddress(2,index);
                detailPic.bigSource = firstPageModel.getImageAddress(3,index);
                break;
            }
            case 1:     //for msg page
            {
                detailPic.smallSource = atMeModel.getImageAddress(2,index);
                detailPic.bigSource = atMeModel.getImageAddress(3,index);
                break;
            }
            case 2:     //for my WeiBo list page
            {
                detailPic.smallSource = myWeiboModel.getImageAddress(2,index);
                detailPic.bigSource = myWeiboModel.getImageAddress(3,index);
                break;
            }
            case 3:     //for SuiBianKanKan page
            {
                detailPic.smallSource = suiBianKanModel.getImageAddress(2,index);
                detailPic.bigSource = suiBianKanModel.getImageAddress(3,index);
                break;
            }
            case 4:     //for SearchBlog page
            {
                detailPic.smallSource = searchBlogModel.getImageAddress(2,index);
                detailPic.bigSource = searchBlogModel.getImageAddress(3,index);
                break;
            }
            case 5:     //for TrendsStatus page
            {
                detailPic.smallSource = trendBlogModel.getImageAddress(2,index);
                detailPic.bigSource = trendBlogModel.getImageAddress(3,index);
                break;
            }
            case 6:     //for my Favorites list page
            {
                detailPic.smallSource = myFavoritesModel.getImageAddress(2,index);
                detailPic.bigSource = myFavoritesModel.getImageAddress(3,index);
                break;
            }
            default:
            {
                detailPic.smallSource = "";
                detailPic.bigSource = "";
            }
        }
        detailPic.visible = true;
    }
*/
    function tranferStringMonthToInt(month)
    {
        if(month == "Jan")
        {
            return "01";
        }
        if(month == "Feb")
        {
            return "02";
        }
        if(month == "Mar")
        {
            return "03";
        }
        if(month == "Apr")
        {
            return "04";
        }
        if(month == "May")
        {
            return "05";
        }
        if(month == "Jun")
        {
            return "06";
        }
        if(month == "Jul")
        {
            return "07";
        }
        if(month == "Aug")
        {
            return "08";
        }
        if(month == "Sep")
        {
            return "09";
        }
        if(month == "Oct")
        {
            return "10";
        }
        if(month == "Nov")
        {
            return "11";
        }
        if(month == "Dec")
        {
            return "12";
        }
    }
}
