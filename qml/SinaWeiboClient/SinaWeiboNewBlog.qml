import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as SinaWeiboErrorCode
import QtMobility.location 1.1

Page {
    id: microBlogContainer
    property alias context: editbox.text
    property string forwardText
    property int pageId: funcContainer.microBlogId //0--NewMicroBlog, 1--Comment, 2--Forword , 3--Message 4--commentReply
    property bool yesReturn: false
//    property string funcContainer.selectImageSrc: funcContainer.selectImageSrc
    property int typeFlag: 0//0--clear text,1--return the last page
    property bool showLocationImg: false
    property bool addingLocation: false
    property bool enableSoftkeyInputPanel: true
    property bool inPortrait: funcContainer.inPortrait
    property int chartotalnum: 3 != pageId ? 140 : 300
    property bool hasforward: false

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    onInPortraitChanged: {
        console.log("onOrientationLockChanged");
        if(visible){
            funcContainer.showStatusBar = microBlogContainer.inPortrait;
        }
    }

    onVisibleChanged: {
        if(visible){
            funcContainer.showStatusBar = microBlogContainer.inPortrait;
        }
    }

    anchors.fill:parent

    PositionSource {
        id: positionSource
        active: false

        onPositionChanged: {
            console.log("onPositionChanged------"+position.latitudeValid);
            console.log("onPositionChanged------"+position.longitudeValid);

            positionSource.active = false;
            gpstimer.running = false;

            if(position.latitudeValid && position.longitudeValid) {
                microBlog.reqGeoAddress(position.coordinate.latitude, position.coordinate.longitude);
            }
        }
    }

    Timer {
        id: gpstimer
        interval: 24000; running: false; repeat: false;
        onTriggered: {
            if(positionSource.active ){
                addingLocation = false;
                positionSource.active = false;
                funcContainer.showPopup("位置信息取得失败！");
            }
        }
    }

    function showWaitDialog(type)
    {
        if(type)
        {
            console.log("timer start")
            uploadtimer.start();
        }
        else
        {
            console.log("timer stop")
            uploadtimer.stop();
        }

        funcContainer.showWaitingDialog(type);
    }

    Timer {
        id: uploadtimer
        interval: 300000; running: false; repeat: false;
        onTriggered: {
            uploadtimer.running = false;
            microBlog.handleTimeout();
            showWaitingDialog(false);
            funcContainer.showPopup("操作超时！");
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {

        }
    }

    Component.onCompleted:
    {
        funcContainer.isshowmoreindicator = false;
        if(pageId == 0) {
            microBlog.readyFinishNew.connect(microBlogContainer.sinaWeiBoMicroFinished);
            //microBlog.getPosFromGPS.connect(microBlogContainer.getPosFromGpsFinished);
        }
        else if(pageId == 1) {
            microBlog.readyFinishComment.connect(microBlogContainer.sinaWeiBoMicroFinished);
            microBlog.readyFinishForword.connect(microBlogContainer.sinaWeiBoMicroFinished);
        }
        else if(pageId == 2) {
            microBlog.readyFinishForword.connect(microBlogContainer.sinaWeiBoMicroFinished);
        }
        else if(pageId == 3)
        {
            messageCenterModel.sendMessageFinished.connect(microBlogContainer.sinaWeiBoMicroFinished);
        }
        else if(pageId == 4){
            microBlog.readyFinishCommentReply.connect(microBlogContainer.sinaWeiBoMicroFinished);
            microBlog.readyFinishForword.connect(microBlogContainer.sinaWeiBoMicroFinished);
        }

        microBlog.readyFinishGeoAddress.connect(microBlogContainer.getGeoToAddressFinished);

        insertTopicModel.selectTopicItem.connect(microBlogContainer.insertTopic);
        searchTopicModel.selectTopicItem.connect(microBlogContainer.insertTopic);
        hotTrendModel.selectTopicItem.connect(microBlogContainer.insertTopic);
        frequentContactModel.selectContactItem.connect(microBlogContainer.insertAt);
        searchContactModel.selectContactItem.connect(microBlogContainer.insertAt);

        //microBlog.reqGeoAddress(38.885296,121.543443);

    }
    Component.onDestruction:{
        funcContainer.commentHeader = "";
        funcContainer.selectImageSrc = "";

        if(null === microBlog){
            console.log("=======microBlog has been deleted========");
        }
        else{

            if(pageId == 0) {
                microBlog.readyFinishNew.disconnect(microBlogContainer.sinaWeiBoMicroFinished);
                //microBlog.getPosFromGPS.disconnect(microBlogContainer.getPosFromGpsFinished);
            }
            else if(pageId == 1) {
                microBlog.readyFinishComment.disconnect(microBlogContainer.sinaWeiBoMicroFinished);
                microBlog.readyFinishForword.disconnect(microBlogContainer.sinaWeiBoMicroFinished);
            }
            else if(pageId == 2) {
                microBlog.readyFinishForword.disconnect(microBlogContainer.sinaWeiBoMicroFinished);
            }
            else if(pageId == 3) {
                messageCenterModel.sendMessageFinished.disconnect(microBlogContainer.sinaWeiBoMicroFinished);
            }
            else if(pageId == 4){
                microBlog.readyFinishCommentReply.disconnect(microBlogContainer.sinaWeiBoMicroFinished);
                microBlog.readyFinishForword.disconnect(microBlogContainer.sinaWeiBoMicroFinished);
            }

            microBlog.readyFinishGeoAddress.disconnect(microBlogContainer.getGeoToAddressFinished);
        }

        if(null === insertTopicModel){
            console.log("=======insertTopicModel has been deleted========");
        }
        else{
            insertTopicModel.selectTopicItem.disconnect(microBlogContainer.insertTopic);
        }

        if(null === searchTopicModel){
            console.log("=======searchTopicModel has been deleted========");
        }
        else{
            searchTopicModel.selectTopicItem.disconnect(microBlogContainer.insertTopic);
        }

        if(null === hotTrendModel){
            console.log("=======hotTrendModel has been deleted========");
        }
        else{
            hotTrendModel.selectTopicItem.disconnect(microBlogContainer.insertTopic);
        }

        if(null === frequentContactModel){
            console.log("=======frequentContactModel has been deleted========");
        }
        else{
            frequentContactModel.selectContactItem.disconnect(microBlogContainer.insertAt);
        }

        if(null === searchContactModel){
            console.log("=======searchContactModel has been deleted========");
        }
        else{
            searchContactModel.selectContactItem.disconnect(microBlogContainer.insertAt);
        }

        funcContainer.isshowmoreindicator = true;
    }

    function getGeoToAddressFinished(errCode)
    {
        if(-1 == errCode)
        {

        }
        else if(200 == errCode)
        {
            addingLocation = false;
            showLocationImg = true;
            //microBlog.addLocation(positionSource.position.coordinate.latitude, positionSource.position.coordinate.longitude);
            var address = microBlog.getGeoAddress();
            if(address !== "")
            {
                funcContainer.insertTopic = address;
                insertTopic();
            }
        }
        else{
            funcContainer.showPopup("位置信息取得失败！");
        }
    }

    function sinaWeiBoMicroFinished(errCode){
        console.log("$$$"+errCode);
        //Processing
        if(-1 == errCode){
            //funcContainer.makeWaitingDialogVisible(true);
            showWaitDialog(true);
        }
        else if(200 == errCode)
        {
            if((4 == pageId) && (checkBox.checked) && (!hasforward)){
                hasforward = true;
                microBlog.sendForwordMicroBlog(context, funcContainer.replyRetweetedId, false);
            }
            else{
                showLocationImg = false;
                addingLocation = false;
                positionSource.active = false;
                microBlog.removeLocation();

                //funcContainer.makeWaitingDialogVisible(false);
                showWaitDialog(false);

                var temptext;

                if(pageId == 0)
                    temptext = "微博发送成功！"
                else if(pageId == 1)
                    temptext = "评论发表成功！"
                else if(pageId == 2)
                    temptext = "转发成功！"
                else if(pageId == 3)
                    temptext = "发送成功！"
                else if(pageId == 4)
                    temptext = "评论发表成功！"

                funcContainer.showBanner(temptext);
                returnLastView();
            }
        }
        else if(-2 == errCode)
        {
            //funcContainer.makeWaitingDialogVisible(false);
            showWaitDialog(false);
            funcContainer.showPopup("图片大小不能超过5MB！");
        }

        else{
            //funcContainer.makeWaitingDialogVisible(false);
            showWaitDialog(false);
            if(40016 == errCode)
            {
                if((pageId == 1) || (pageId == 4))
                    funcContainer.showPopup("被评论的微博不存在！");
                else if(pageId == 2)
                    funcContainer.showPopup("被转发的微博不存在！");
            }
            else
            {
                funcContainer.showPopup(SinaWeiboErrorCode.getErrorInfo(errCode));
            }
        }
    }

    function returnLastView(){
        closeThePanel();
        showLocationImg = false;
        addingLocation = false;
        positionSource.active = false;
        funcContainer.showStatusBar = true;
        microBlog.removeLocation();
        listPage.viewBack();
    }
    function closeThePanel()
    {
        editbox.platformCloseSoftwareInputPanel();
    }

    function insertTopic()
    {
        var textLength = editbox.text.length;

        var textCursorPos = editbox.cursorPosition;
        var textContentPre = editbox.text.substring(0, textCursorPos);
        var textContent = "#" + funcContainer.insertTopic + "#";//"#请插入话题名称#";
        var textContentNxt = editbox.text.substring(textCursorPos, textLength);
        //var textCursorPos = editbox.cursorPosition;

        editbox.text = textContentPre + textContent + textContentNxt;
        editbox.cursorPosition = textCursorPos+textContent.length;
        //editbox.select(editbox.cursorPosition , editbox.cursorPosition +textContent.length - 1);


    }

    function insertAt()
    {
        var textLength = editbox.text.length;
        var textCursorPos = editbox.cursorPosition;
        var textContentPre = editbox.text.substring(0, textCursorPos);
        var textContent = "@" + funcContainer.insertContact + " "//"@请输入用户名";
        var textContentNxt = editbox.text.substring(textCursorPos, textLength);

        editbox.text = textContentPre + textContent + textContentNxt;
        editbox.cursorPosition = textCursorPos + textContent.length;
//        editbox.cursorPosition = textCursorPos+1;
//        editbox.select(editbox.cursorPosition , editbox.cursorPosition +textContent.length - 1);
    }

    Flickable {
        id: flickable
//        height: parent.height - titlebar.height - funcbar.height - delButton.height - emotionInputPanel.height - 5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: funcbar.top
        anchors.bottomMargin:5
        contentWidth: col.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick
        Column{
            id:col
            width: flickable.width

            AccTitleBar{
                id:titlebar
                width: parent.width
                height: 65
                isTexthorizontalCenter: true
                textcolor: "black"
                title:{
                    var temp;
                    if(0 == pageId)
                        temp = "发布新微博";
                    else if(1 == pageId)
                        temp = "评论微博";
                    else if(2 == pageId)
                        temp = "转发微博";
                    else if(3 == pageId)
                        temp = "发私信";
                    else if(4 == pageId)
                        temp = "回复评论";
                    return temp /*+ "(" + numindicator + ")"*/
                }

                bgsource: "../images/titlebg_gray.png"

                SheetButton {
                    id: cancelBtn
                    width: 81
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    text: "取消"
                    onClicked: {
                        if((0 < editbox.text.length) ||
                                ((funcContainer.selectImageSrc !== "") && 0 == pageId)){
                            typeFlag = 1;
                            query.open();
                        }
                        else {
                            returnLastView();
                        }
                    }
                }

                SheetButton{
                    id: sendButton
                    width: 81
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    platformStyle: SheetButtonAccentStyle { }
                    text: pageId == 3? "发送":"发布"
                    onClicked: {
                        console.log("pageid ================== ", pageId);
//                        editbox.forceActiveFocus();
                        if((0< context.length) || (pageId == 0 && funcContainer.selectImageSrc != "")){
                            if(microBlogContainer.chartotalnum < context.length){
                                funcContainer.showPopup("发送内容不能超过" + microBlogContainer.chartotalnum + "个字！");
                            }
                            else{
                                if(pageId == 0){
                                    if((0 === context.length) && (funcContainer.selectImageSrc !== ""))
                                    {
                                        context = "分享图片";
                                    }
                                    microBlog.sendNewMicroBlog(context, funcContainer.selectImageSrc);
                                }
                                else if(pageId == 1){
                                    console.log("==================", funcContainer.commentStatusID, context, checkBox.checked);
                                    microBlog.sendCommentMicroBlog(funcContainer.commentStatusID, context, checkBox.checked);
                                }
                                else if(pageId == 2){
                                    microBlog.sendForwordMicroBlog(context, funcContainer.repostStatusID, checkBox.checked);
                                }
                                else if(pageId == 3){
                                    if(sendPerson.text.length > 0){
                                        messageCenterModel.sendMessageContent(funcContainer.userIDInMyProfilePage, context);
                                    }
                                    else{
                                        funcContainer.showPopup("请选择一个收件人！");
                                    }
                                }
                                else if(pageId == 4){
                                    console.log("funcContainer.commentStatusID = ",funcContainer.commentStatusID);
                                    console.log("funcContainer.statusIDInDetailPage = ",funcContainer.replyRetweetedId);
                                    if((funcContainer.replyRetweetedId == "") || (funcContainer.replyRetweetedId == 0))
                                    {
                                        funcContainer.replyRetweetedId = funcContainer.statusIDInDetailPage;
                                        console.log("rest replyRetweetedId = ", funcContainer.replyRetweetedId);
                                    }
                                    microBlog.sendCommentReply(funcContainer.commentStatusID, context, funcContainer.replyRetweetedId, true);
//                                microBlog.sendForwordMicroBlog(context,funcContainer.statusIDInDetailPage, false);
//                                    microBlog.sendCommentMicroBlog(funcContainer.statusIDInDetailPage, context, true);
                                    /*202110921708730925*//*3360094618179905*//*3350485881320561*/  /*3350632666710490*//*2121109225396289*//*3360413070954871*//*funcContainer.statusIDInDetailPage*/
                                }
                            }
                        }
                        else if((0 == context.length) && (pageId == 2)) {
                            microBlog.sendForwordMicroBlog("转发微博。", funcContainer.repostStatusID, checkBox.checked);
                        }
                        else{
                            funcContainer.showPopup("发送内容不能为空！");
                        }
                    }
                }
            }

            TextField {
                id: sendPerson
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.leftMargin:5
                anchors.rightMargin:5
                visible: microBlogContainer.pageId == 3
                placeholderText: "收信人"
                platformStyle: TextFieldStyle { paddingLeft:5;paddingRight: searchfriend.width }
                //text: funcContainer.senderScreenName.length>12? funcContainer.senderScreenName.substring(0, 10) + "..." : funcContainer.senderScreenName
                text:funcContainer.senderScreenName
                readOnly: true

                Image {
                    id:searchfriend
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/add.png"
                }
                MouseArea {
                    width: parent.height
                    height: parent.height
                    anchors.centerIn: searchfriend
                    onClicked: {
                        funcContainer.contactsType = 1;
                        closeThePanel();
                        if(frequentContactModel.getFrequentContactsCount() > 0){
                            funcContainer.showStatusBar = true;
                            listPage.changePage(29);
                        }
                        else{
                            funcContainer.showStatusBar = true;
                            listPage.changePage(31);
                        }
                    }
                }
            }

            TextArea {
                id:editbox
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin:5
                anchors.rightMargin:5
                placeholderText:"说点什么吧......"
                enableSoftwareInputPanel: microBlogContainer.enableSoftkeyInputPanel
                text:{
                    if(pageId == 2)
                        return funcContainer.repostStatusText;
                    else if(pageId == 0 && funcContainer.newBlogWithTopic)
                        return "#"+ funcContainer.topicName + "#"
                    else
                        return "";
                }
                height: Math.max(editbox.implicitHeight + (funcContainer.inPortrait ? 20 : 0),
                                 flickable.height - titlebar.height - (sendPerson.visible ? sendPerson.height : 0))


                Text {
                    visible: funcContainer.inPortrait
                    font.pixelSize: numindicator.font.pixelSize
                    text: chartotalnum - editbox.text.length
                    color: "gray"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                }
                onVisibleChanged: {
                    if(editbox.visible){
                        editbox.forceActiveFocus();
                    }
                }
            }
        }
    }

    Rectangle{
        id: funcbar
        color: "#f0f1f2"
        anchors.bottom: emotionInputPanel.top
        height: 60
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        state: {
            var temp;
            if(0 == pageId) {temp = "newblog";}
            else if((1 == pageId) || (2 == pageId) || (4 == pageId)) {temp = "commentforward";}
            else if(3 == pageId) {temp = "privatemsg";}
            return temp;
        }
        property int iconareawidth: 480
        states: [
            State {
                 name: "newblog"
                 //gps
                 AnchorChanges {
                     target: gpsicon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: gpsicon
                     anchors.horizontalCenterOffset: (funcbar.iconareawidth/12)
                 }
                 //topic
                 AnchorChanges {
                     target: topicicon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: topicicon
                     anchors.horizontalCenterOffset: (funcbar.iconareawidth * 3 /12)
                 }
                 //at
                 AnchorChanges {
                     target: aticon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: aticon
                     anchors.horizontalCenterOffset: (funcbar.iconareawidth *5/12)
                 }
                 //emotion
                 AnchorChanges {
                     target: emotionicon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: emotionicon
                     anchors.horizontalCenterOffset: funcbar.iconareawidth *7/12
                 }
                 //picicon
                 AnchorChanges {
                     target: picicon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: picicon
                     anchors.horizontalCenterOffset: funcbar.iconareawidth * 9/12
                 }
                 //pic
                 AnchorChanges {
                     target: pic
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: pic
                     anchors.horizontalCenterOffset: funcbar.iconareawidth * 11/12
                 }
             },
            State {
                 name: "commentforward"
                 //checkbox
                 AnchorChanges {
                     target: checkBox
                     anchors.right: funcbar.right
                 }
                 PropertyChanges {
                     target: checkBox
                     anchors.rightMargin: funcContainer.inPortrait ? 10 : 100
                 }
                 //topic
                 AnchorChanges {
                     target: topicicon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: topicicon
                     anchors.horizontalCenterOffset: (funcbar.iconareawidth - checkBox.width - 10)/7
                 }
                 //at
                 AnchorChanges {
                     target: aticon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: aticon
                     anchors.horizontalCenterOffset: (funcbar.iconareawidth - checkBox.width - 10)*3/7
                 }
                 //emotion
                 AnchorChanges {
                     target: emotionicon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: emotionicon
                     anchors.horizontalCenterOffset: (funcbar.iconareawidth - checkBox.width - 10)*5/7
                 }
             },
            State {
                 name: "privatemsg"
                 //topic
                 AnchorChanges {
                     target: topicicon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: topicicon
                     anchors.horizontalCenterOffset: funcbar.iconareawidth/12
                 }
                 //at
                 AnchorChanges {
                     target: aticon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: aticon
                     anchors.horizontalCenterOffset: funcbar.iconareawidth/4
                 }
                 //emotion
                 AnchorChanges {
                     target: emotionicon
                     anchors.horizontalCenter: funcbar.left
                 }
                 PropertyChanges {
                     target: emotionicon
                     anchors.horizontalCenterOffset: funcbar.iconareawidth*5/12
                 }
             }
        ]

        ToolIcon{
            id: gpsicon
            iconSource: if(!showLocationImg){"images/addLocation.png"}else{"images/located.png"}
            visible: !addingLocation && (pageId == 0)

            onClicked: {

                if (showLocationImg) {
                    cancelLocationPopop.open();
                }
                else {
                    //microBlog.addLocation();
                    addingLocation = true;
                    positionSource.active = true;
                    gpstimer.running = true;
                }
            }
        }

        BusyIndicator {
            anchors.centerIn: gpsicon
            visible: addingLocation
            running: addingLocation
        }

        ToolIcon {
            id: topicicon
            anchors.verticalCenter: parent.verticalCenter
            iconSource: "images/icon_numbersign.png" ;
            onClicked: {
                console.log("=================================", funcbar.height);
                closeThePanel();
                if(insertTopicModel.getRecentTopicCount()>0){
                    funcContainer.showStatusBar = true;
                    listPage.changePage(27);
                }
                else{
                    funcContainer.showStatusBar = true;
                    listPage.changePage(28);
                }
                console.log("change to insert topic page")
                //insertTopic() ;
                //console.log("current:"+ editbox.cursorPosition)
            }
        }

        ToolIcon {
            id: aticon
            anchors.verticalCenter: parent.verticalCenter
            iconSource: "images/icon_at.png" ;
            onClicked: {
                closeThePanel();
                //insertAt();
                funcContainer.contactsType = 0;
                if(frequentContactModel.getFrequentContactsCount() > 0){
                    funcContainer.showStatusBar = true;
                    listPage.changePage(29);
                }
                else{
                    funcContainer.showStatusBar = true;
                    listPage.changePage(30);
                }

                console.log("change to insert contact page")
            }
        }

        ToolIcon {
            id: emotionicon
            anchors.verticalCenter: parent.verticalCenter
            iconSource: microBlogContainer.enableSoftkeyInputPanel ? "images/emotion.png" : "images/keyboard.png"
            onClicked: {
                console.log("onClicked", microBlogContainer.height);
                if(microBlogContainer.enableSoftkeyInputPanel){
                    closeThePanel();
                    microBlogContainer.enableSoftkeyInputPanel = !microBlogContainer.enableSoftkeyInputPanel
                }
                else{
                    editbox.forceActiveFocus();
                    microBlogContainer.enableSoftkeyInputPanel = !microBlogContainer.enableSoftkeyInputPanel
                    editbox.openSoftwareInputPanel();
                }
                console.log("onClicked", microBlogContainer.height);
            }
        }

        ToolIcon {
            id: picicon
            anchors.verticalCenter: parent.verticalCenter
            iconSource: "images/icon_picture.png" ;
            visible: {
                if(pageId == 0)
                    return true
                else
                    return false
            }
            onClicked: {
                singleSelectionDialog.open();
            }
        }

        Image {
            id: pic
            height: pic.width - 10
            width: (funcContainer.selectImageSrc == "") ? 0 : parent.height - 10
            source: funcContainer.selectImageSrc

            anchors.verticalCenter: parent.verticalCenter

//            fillMode: Image.PreserveAspectFit
            visible: {
                if(0 == pageId ){
                    return true;
                }
                else{
                    return false;
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    funcContainer.picSource = funcContainer.selectImageSrc;
                    funcContainer.isPicDeleted = false;
                    funcContainer.isEditable = true;
                    funcContainer.showStatusBar = true;
                    listPage.changePage(37);
                }
            }
            onVisibleChanged: {
                console.log("=========================",funcContainer.selectImageSrc);
                console.log(funcContainer.isPicDeleted);
                if(funcContainer.isPicDeleted){
                    funcContainer.selectImageSrc = "";
                    funcContainer.isPicDeleted = false;
                }
            }
        }
        CheckBox {
            id: checkBox
            checked: false
            anchors.verticalCenter: parent.verticalCenter
            visible: if(pageId == 0 || pageId == 3){false}else{true}
            text: {
                if((pageId == 1)||(4 == pageId)){
                    return "同时转发到我的微博";
                }
                else if (pageId == 2){
                    return "同时评论给该微博";
                }
                else
                {
                    return "";
                }
            }
        }

        Text {
            id: numindicator
            visible: !funcContainer.inPortrait
            text: chartotalnum - editbox.text.length
            color: "gray"
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
        }
    }

    SinaWeiboEmotion{
        id:emotionInputPanel
        visible: (!microBlogContainer.enableSoftkeyInputPanel)
        anchors.bottom: parent.bottom
        width: parent.width
        height: visible ? microBlogContainer.height - (funcContainer.inPortrait ? 497 : 250) : 0
        onItemClick: {
            var textLength = editbox.text.length;
            var textCursorPos = editbox.cursorPosition;
            var textContentPre = editbox.text.substring(0, textCursorPos);
            var textContentNxt = editbox.text.substring(textCursorPos, textLength);

            editbox.text = textContentPre + emotionString + textContentNxt;
            editbox.cursorPosition = textCursorPos + emotionString.length;
        }
    }


    QueryDialog {
        id: popupSingle
        property string popupContent

        message: popupContent
        acceptButtonText: "确定"
        onAccepted: {
            returnLastView();
        }
        onRejected:{
            returnLastView();
        }
    }

    QueryDialog {
        id: query

        message: {
            if(typeFlag == 0)
                return "是否清除文字？"
            else
                return "是否取消？"
        }
        acceptButtonText: "是"
        rejectButtonText: "否"
        onAccepted: {
            if(typeFlag == 0) {
                editbox.text = "";
                flickable.contentY = 0;
            }
            else
                returnLastView();
        }
    }
    /*Dialog {
        id: query
        title: Item {
            id: titleField
            height: query.style.titleBarHeight
            width: parent.width
            Image {
                id: supplement
                source: "images/icon_popup.png"
                height: parent.height - 10
                width: 75
                fillMode: Image.PreserveAspectFit
                anchors.leftMargin: 5
                anchors.rightMargin: 5
            }

            Label {
                id: titleLabel
                anchors.left: supplement.right
                anchors.verticalCenter: titleField.verticalCenter
                font.capitalization: Font.MixedCase
                color: "white"
                text: "询问"
            }

            Image {
                id: closeButton
                anchors.verticalCenter: titleField.verticalCenter
                anchors.right: titleField.right

                source: "image://theme/icon-m-framework-close"

                MouseArea {
                    id: closeButtonArea
                    anchors.fill: parent
                    onClicked:  { query.reject(); }
                }
            }
        }

        content:Item {
            id: name
            height: childrenRect.height
            Text {
                id: text
                font.pixelSize: 22
                color: "white"
                text: {
                    if(typeFlag == 0)
                        return "确定清除文字？"
                    else
                        return "确定返回？"
                }

            }
        }

        buttons: ButtonRow {
            style: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: b1;
                text: "确定";
                onClicked: {
                    query.accept();
                    if(typeFlag == 0) {
                        editbox.text = "";
                        flickable.contentY = 0;
                    }
                    else
                        returnLastView();

                }
            }

            Button {id: b2; text: "取消"; onClicked: query.reject()}
        }
    }*/

    QueryDialog {
        id: popupHint

        message: "是否返回？"
        acceptButtonText: "是"
        rejectButtonText: "否"
        onAccepted: {
            returnLastView();
        }
    }

    QueryDialog {
        id: cancelLocationPopop

        message: "是否取消定位信息？"
        acceptButtonText: "是"
        rejectButtonText: "否"
        onAccepted: {
            microBlog.removeLocation();
            showLocationImg = false;
        }
    }

    ContextMenu {
        id: singleSelectionDialog
        icon: "image://theme/icon-l-contacts"
        titleText: "图片选择"
        MenuLayout {
            MenuItem {
                text: "用户相册";
                onClicked: {
                    closeThePanel();
                    funcContainer.showStatusBar = true;
                    listPage.changePage(42);
                }
            }
            MenuItem {
                text: "拍照";
                onClicked: {
                    closeThePanel();
                    funcContainer.showStatusBar = true;
                    listPage.changePage(43);
                }
            }
        }
    }
}
