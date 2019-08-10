import QtQuick 1.1
import com.nokia.meego 1.0
import "controls"
import "SinaWeiboErrorCode.js" as ErrorCodeDetailPage
import QtWebKit 1.0
import SinaWeiboTypeLib 1.0

Page {
    id: detailContainer
    property int pageWdith: parent.width
    property int pageHeight: parent.height
    property bool landscape: pageHeight < pageWdith
    property bool lodingStatusImage: false
    property bool loadimgFowardImage: false
    property bool isMyStatus: false
    property variant statusID

    Rectangle{
        anchors.fill: parent
        color: "#f0f1f2"
    }

    onVisibleChanged: {
        if(visible) {
            detailModel.connectModel();
            deleteModel.connectModel();
        }
        else {
            detailModel.disConnectModel();
            deleteModel.disConnectModel();
        }
    }

    MouseArea {
         anchors.fill: parent
    }

    Component.onCompleted:{

        statusID = funcContainer.statusIDInDetailPage;

        detailContainer.isMyStatus = false;

        //detailModel.getRequestResult.connect(detailContainer.getDetailFinished);
        detailModel.getSinaWeiboDetail(statusID);

       // deleteModel.getDeleteResult.connect(detailContainer.deleteFinish);
    }

    Component.onDestruction:{
        detailModel.clearData();
    }


    Rectangle{
        id: content
        anchors.top: parent.top
        anchors.topMargin: 135
        width: pageWdith
        height: pageHeight - 73
        color: "transparent"
        z: 0

        Flickable {
             id: flick
             anchors.fill: parent
             anchors.topMargin: 10
             anchors.bottomMargin: 10
             contentWidth: parent.width
             contentHeight: {
                 if(lodingStatusImage) {
                     if(forwardArea.height != 0) {
                         if(detailModel.hasMapFlag) {
                             weiboContent.height + statusImageLoading.paintedHeight+ forwardArea.height + 210 + weiboSource.paintedHeight + mapArea.height;
                         }
                         else
                         {
                             weiboContent.height + statusImageLoading.paintedHeight+ forwardArea.height + 200 + weiboSource.paintedHeight;
                         }
                     }
                     else {
                         if(detailModel.hasMapFlag) {
                             weiboContent.height + statusImageLoading.paintedHeight+ forwardArea.height + 180 + weiboSource.paintedHeight + mapArea.height;
                         }
                         else{
                             weiboContent.height + statusImageLoading.paintedHeight+ forwardArea.height + 170 + weiboSource.paintedHeight;
                         }
                     }
                 }
                 else {
                     if(forwardArea.height != 0) {
                         if(detailModel.hasMapFlag) {
                             weiboContent.height + weiboImage.paintedHeight+ forwardArea.height + 210 + weiboSource.paintedHeight + mapArea.height;
                         }
                         else
                         {
                             weiboContent.height + weiboImage.paintedHeight+ forwardArea.height + 200 + weiboSource.paintedHeight;
                         }
                     }
                     else {
                         if(detailModel.hasMapFlag) {
                             weiboContent.height + weiboImage.paintedHeight+ forwardArea.height + 180 + weiboSource.paintedHeight + mapArea.height;
                         }
                         else
                         {
                             weiboContent.height + weiboImage.paintedHeight+ forwardArea.height + 170 + weiboSource.paintedHeight;
                         }
                     }
                 }
             }

             flickableDirection: Flickable.VerticalFlick
             clip: true

             Text
             {
                 id: contentbase
                 opacity: 0
                 anchors.top:parent.top
                 anchors.topMargin: 10
                 anchors.left:parent.left
                 anchors.right:parent.right
                 anchors.rightMargin: 10
                 anchors.leftMargin: 10
                 text: detailModel.statusText
                 width: pageWdith - 20
                 color:"black";
                 smooth:true;
                 horizontalAlignment:Text.AlignLeft
                 verticalAlignment :Text.AlignTop
                 wrapMode:Text.WrapAtWordBoundaryOrAnywhere
                 font.pixelSize: 24
                 visible: "" != text ? true : false
             }

						 WebView {
                 id: weiboContent
                 visible: "" != contentbase.text ? true : false
                 preferredWidth :parent.width - 10;
                 preferredHeight:contentbase.paintedHeight
                 anchors.top:parent.top
                 anchors.left:parent.left
                 anchors.leftMargin:5
                 javaScriptWindowObjects: QtObject {
                     WebView.windowObjectName: "WeiboContentRect"
                     function contentClicked(content,index)
                     {
                         console.log("call detailContainer.linkClicked");
                         detailContainer.linkClicked(content, index);
                     }
                 }

                 settings.defaultFontSize :24
                 settings.zoomTextOnly: true
                 smooth: true
                 html:analyzeText(analyzeHttpText(detailModel.statusText));

                                 onUrlChanged: { if(url != "") { _HandleRawLinkClicked(url); html = analyzeText(analyzeHttpText(detailModel.statusText)); } } //k
             }

             //status image
             AnimatedImage{
                 id:weiboImage
                 anchors.top: weiboContent.bottom
                 anchors.topMargin: 10
                 anchors.horizontalCenter: parent.horizontalCenter
                 width: parent.width - 20
                 smooth:true
                 fillMode: Image.PreserveAspectFit
                 source: detailModel.statusImage

                 onStatusChanged: {
                     if (weiboImage.status == Image.Ready) {
                         statusImageLoading.visible = false
                         lodingStatusImage = false;
                     }
                     else if(weiboImage.status == Image.Loading) {
                         statusImageLoading.visible = true;
                         lodingStatusImage = true;
                     }
                 }
                 MouseArea{
                     anchors.fill: parent
                     onClicked: {
                         funcContainer.picSource = detailModel.statusImage;
                         funcContainer.isPicDeleted = false;
                         funcContainer.isEditable = false;
                         listPage.changePage(37);
                     }
                 }
             }

             //status loading
             Image {
                 id: statusImageLoading
                 anchors.top: weiboContent.bottom
                 anchors.topMargin: 10
                 anchors.horizontalCenter: parent.horizontalCenter
                 smooth:true
                 source: "images/image_loading.png";
                 visible: false      
             }

             //Repost area
             Rectangle
             {
                 id:forwardArea
                 anchors.right:parent.right
                 anchors.left:parent.left
                 color:"transparent"
                 visible: detailModel.retweetedID != ""
                 height:{
                     if(detailModel.retweetedID == ""){0}
                     else{forward_head.paintedHeight + forward_middle.paintedHeight + forward_end.paintedHeight}
                 }
                 anchors.top:if(lodingStatusImage){statusImageLoading.bottom}else{weiboImage.bottom}
                 //anchors.topMargin:10

                 //wholebg
                 Image{
                     id: bgtop
                     width: parent.width
                     anchors.top:parent.top;
                     anchors.right:parent.right
                     anchors.left:parent.left
                     smooth: true
                     source: "images/bg_comments_gray_top.png"
                     fillMode:Image.Stretch
                 }
                 Image{
                     id: bgbottom
                     width: parent.width
                     height: parent.height
                     anchors.top:bgtop.bottom
                     anchors.right:parent.right
                     anchors.left:parent.left
                     smooth: true
                     source: "images/comment_bg_bottom.png"
                     fillMode:Image.Stretch
                 }

                 Image
                 {
                     id: forward_head
                     anchors.top:parent.top
                     anchors.topMargin: 10
                     anchors.left: parent.left;
                     anchors.leftMargin: 10
                     source: {
                         if (landscape) {"images/bg_comments_landscape_top.png"; }
                         else {"images/bg_comments_top_01.png";}
                     }
                     width: parent.width - 20
                     fillMode:Image.Stretch
                 }

                 Image
                 {
                     id: forward_middle
                     anchors.top:forward_head.bottom
                     anchors.left: parent.left;
                     anchors.leftMargin: 10
                     source: {
                         if (landscape) {"images/bg_comments_landscape.png"; }
                         else {"images/bg_comments.png";}
                     }
                     width: parent.width - 20
                     height: if(loadimgFowardImage){forwardText.height + forwardImageLoading.height + repost.height + 20}else{forwardText.height + forwardImage.height + repost.height + 20}
                     fillMode:Image.Stretch

                     Text
                     {
                         id: forwardbase
                         opacity: 0
                         text: "@" + detailModel.retweetedUserName + ": " + detailModel.retweetedText
                         color:"black"
                         width:parent.width - 20;
                         anchors.horizontalCenter:parent.horizontalCenter
                         anchors.left:parent.left
                         anchors.leftMargin:10
                         smooth:true;
                         horizontalAlignment:Text.AlignLeft
                         verticalAlignment :Text.AlignTop
                         font.pixelSize: 24
                         wrapMode:Text.WrapAnywhere
                     }

                     WebView {
                         id: forwardText
                         preferredWidth :parent.width - 10;
                         preferredHeight:forwardbase.paintedHeight
                         anchors.top:parent.top
                         anchors.left:parent.left
                         anchors.leftMargin:5

                         javaScriptWindowObjects: QtObject {
                             WebView.windowObjectName: "WeiboContentRect"
                             function contentClicked(content,index)
                             {
                                 detailContainer.linkClicked(content, index);
                             }
                         }

                         settings.defaultFontSize :24
                         settings.zoomTextOnly: true
                         smooth: true
												 html:analyzeText(analyzeHttpText("@" + detailModel.retweetedUserName + ": " + detailModel.retweetedText));

                                                 onUrlChanged: { if(url != "") { _HandleRawLinkClicked(url); html = analyzeText(analyzeHttpText("@" + detailModel.retweetedUserName + ": " + detailModel.retweetedText)); } } //k
                     }

                     AnimatedImage{
                         id: forwardImage
                         anchors.top: forwardText.bottom
                         anchors.topMargin: 10
                         anchors.horizontalCenter: parent.horizontalCenter
                         width: parent.width - 40
                         smooth:true
                         fillMode: Image.PreserveAspectFit
                         source: detailModel.retweetedImage

                         onStatusChanged: {
                             if (forwardImage.status == Image.Ready) {
                                 forwardImageLoading.visible = false;
                                 loadimgFowardImage = false;
                             }
                             else if(forwardImage.status == Image.Loading) {
                                 forwardImageLoading.visible = true;
                                 loadimgFowardImage = true;
                             }
                         }
                         MouseArea{
                             anchors.fill: parent
                             onClicked: {
                                 console.log(detailModel.retweetedImage);
                                 funcContainer.picSource = detailModel.retweetedImage;
                                 funcContainer.isPicDeleted = false;
                                 funcContainer.isEditable = false;
                                 listPage.changePage(37);
                             }
                         }
                     }

                     Image {
                         id: forwardImageLoading
                         anchors.top: forwardText.bottom
                         anchors.topMargin: 10
                         anchors.horizontalCenter: parent.horizontalCenter
                         smooth:true
                         source: "images/image_loading.png";
                         visible: false
                     }

                     Button {
                         id: repost
                         anchors.right: comment.left
                         anchors.rightMargin: 10
                         anchors.top: if(loadimgFowardImage){forwardImageLoading.bottom}else{forwardImage.bottom}
                         anchors.topMargin: 10
                         width: 150
                         iconSource: "images/icon_forward_green.png"
                         text: detailModel.retweetedRepostCount
                         visible: detailModel.retweetedID != ""

                         onClicked: {
                             if(detailModel.statusText != ""){
                                 funcContainer.repostStatusID = detailModel.retweetedID;
                                 funcContainer.repostStatusText = "";
                                 listPage.changePage(8);
                             }
                         }
                     }

                     Button {
                         id: comment
                         anchors.right: parent.right
                         anchors.rightMargin: 10
                         anchors.top: if(loadimgFowardImage){forwardImageLoading.bottom}else{forwardImage.bottom}
                         anchors.topMargin: 10
                         width: 150
                         iconSource: "images/icon_comment_green.png"
                         text: detailModel.retweetedCommentCount
                         visible: detailModel.retweetedID != ""

                         onClicked: {
                             funcContainer.commentStatusID = detailModel.retweetedID;
                             if(detailModel.statusText != ""){
                                 if(detailModel.retweetedCommentCount == 0) {
                                     listPage.changePage(9);
                                 }
                                 else {
                                     listPage.changePage(10);
                                 }
                             }
                         }
                     }
                 }

                 Image
                 {
                     id: forward_end
                     anchors.top:forward_middle.bottom
                     anchors.left: parent.left;
                     anchors.leftMargin: 10
                     source: {
                         if (landscape)
                         {"images/bg_comments_landscape_bottom.png"}
                         else
                         {"images/bg_comments_bottom_01.png"}
                     }
                     width: parent.width - 20
                     fillMode:Image.Stretch
                 }
            }

            Rectangle {
                id: mapArea
                anchors.top: forwardArea.bottom
                anchors.topMargin: if(detailModel.retweetedID == "") {10} else {40}
                anchors.horizontalCenter: parent.horizontalCenter
                width: map.width
                height: map.height
                color: "transparent"
                visible: detailModel.hasMapFlag

                AccOviMap {
                    id: map
                    isHasMap: detailModel.hasMapFlag
                    anchors.fill: parent
                    width: 460
                    height: 345
                    latitude: detailModel.latitude
                    longitude: detailModel.longitude
                    zoom: 16
                }
//                Image {
//                    id: map
//                    anchors.fill: parent
//                    //anchors.verticalCenter: parent.verticalCenter
//                    //anchors.horizontalCenter: parent.horizontalCenter
//                    smooth: true
//                    source:detailModel.mapUrl
//                    //fillMode: Image.PreserveAspectFit

//                    onStatusChanged: if (map.status == Image.Ready) icon.visible = true

//                    Image{
//                        id: icon
//                        anchors.centerIn: parent
//                        smooth: true
//                        source: "images/map.png"
//                        fillMode: Image.PreserveAspectFit
//                        visible: false
//                    }
//                }
            }

             //forward button
             Button {
                 id: leftbtn
                 anchors.left: parent.left
                 anchors.leftMargin: 10
                 anchors.top: if(detailModel.hasMapFlag){mapArea.bottom} else{forwardArea.bottom}
                 anchors.topMargin: {
                     if(detailModel.hasMapFlag)
                         return 10;
                     else {
                         if(detailModel.retweetedID == "") {10} else {40}
                     }
                 }
                 width: (pageWdith - 45) / 2
                 text: "转发 " + detailModel.statusRepostCount
                 visible: detailModel.statusID != ""

                 onClicked: {
                     writeRepost();
                 }
             }

             //comment button
             Button {
                 id: rightbtn
                 anchors.right: parent.right
                 anchors.rightMargin: 10
                 anchors.top: if(detailModel.hasMapFlag){mapArea.bottom} else{forwardArea.bottom}
                 anchors.topMargin: {
                     if(detailModel.hasMapFlag)
                         return 10;
                     else {
                         if(detailModel.retweetedID == "") {10} else {40}
                     }
                 }
                 width: (pageWdith - 45) / 2
                 text: "评论 " + detailModel.statusCommentCount
                 visible: detailModel.statusID != ""

                 onClicked: {
                     if(detailModel.statusText != ""){
                         funcContainer.commentStatusID = detailModel.statusID;

                         if(detailModel.statusCommentCount == 0) {
                             listPage.changePage(9);
                         }
                         else {
                             listPage.changePage(10);
                         }
                     }
                 }
             }

             //extra info
             Text {
                 id: weiboSource
                 anchors.left: leftbtn.left
                 //anchors.leftMargin: 20
                 anchors.top: leftbtn.bottom
                 anchors.topMargin: 20
                 visible: detailModel.statusID != ""
                 text: "来自: "+detailModel.statusSource + "   " + changeTimeStyle(detailModel.statusCreateTime)
                 font.pixelSize: 16
             }
        }
    }

    //user info
    AccIntroductoryBar {
        id: introductoryBar
        anchors.left: detailContainer.left
        anchors.top: titleBar.bottom
        limitWord: if(parent.width > parent.height) {false} else {true}
        hasMark: true
        markPath: "../images/icon_arrow_gray.png"
        textX: 90
        textY: 30
        markWidth:9
        markHeight: 17
        markX: pageWdith - 50
        markY: 35
        vipWidth: 18
        vipHeight: 19
        isVip: detailModel.userVerified
        vipPath: "../images/icon_VIP.png"

        width: pageWdith
        height: 80
        fontSize: 24

        hasIcon: true
        bgPath: "../images/bg_item_user.png"
        iconPath: detailModel.userProfileImg
        content: detailModel.userName

        onClicked: {
            if(detailModel.userID != ""){
                funcContainer.userIDInMyProfilePage = detailModel.userID;
                funcContainer.userNameInProfilePage = "";
                listPage.changePage(7);
            }
        }
    }

    //title bar
    AccTitleBar{
        id: titleBar
        width: parent.width
        height: 65
        title:"微博正文"
        anchors.top: parent.top

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
    }

    //tool bar without delete button
    ToolBarLayout {
        id: toolbar
        visible: false
        ToolIcon {
            iconId: theme.inverted ? "icon-m-toolbar-back-white" : "icon-m-toolbar-back";
            onClicked: {
                listPage.viewBack();
            }
        }

        ToolIcon {
            iconSource: "images/icon_forward.png";
            onClicked: {
                if(detailModel.statusText != ""){
                    writeRepost();
                }
            }
        }

        ToolIcon {
            iconSource: "images/icon_comment.png";
            onClicked: {
                if(detailModel.statusText != ""){
                    funcContainer.commentStatusID = detailModel.statusID;
                    listPage.changePage(9);
                }
            }
        }

        ToolIcon {
            visible: isMyStatus;
            iconSource: "images/icon_delete.png";
            onClicked: {
                query.open();
            }
        }

        ToolIcon {
            iconSource: "images/icon_refresh.png";
            onClicked: {
                detailModel.getSinaWeiboDetail(statusID);
            }
        }
    }

    tools: toolbar

    DetailModel {
        id: detailModel

        onGetRequestResult: {
            detailContainer.getDetailFinished(errCode);
        }
    }

    DeleteModel {
        id: deleteModel

        onGetDeleteResult: {
            detailContainer.deleteFinish(errCode);
        }
    }

    //qurey popup
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
                text: "确定删除该条微博？"
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
                    deleteModel.deleteStatus(statusID);
                }
            }

            Button {id: b2; text: "取消"; onClicked: query.reject()}
        }
    }*/

    QueryDialog {
        id: query

        message: "是否删除该条微博？"
        acceptButtonText: "是"
        rejectButtonText: "否"
        onAccepted: {
            deleteModel.deleteStatus(statusID);
        }
    }

    function getDetailFinished(errCode) {
        console.log(errCode)
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if(200 != errCode) {
                if(40031 == errCode)
                {
                    detailpagepopup.message = ErrorCodeDetailPage.getErrorInfo(errCode);
                    detailpagepopup.open();
                }
                else
                {
                    funcContainer.showPopup(ErrorCodeDetailPage.getErrorInfo(errCode));
                }
            }
            else
            {
                if(loginModel.userID == detailModel.userID) {
                    detailContainer.isMyStatus = true;
                }
            }
        }
    }

    function deleteFinish(errCode) {
        console.log(errCode)
        if(-1 == errCode){
            funcContainer.makeWaitingDialogVisible(true);
        }
        else{
            funcContainer.makeWaitingDialogVisible(false);

            if(200 != errCode) {
                funcContainer.showPopup(ErrorCodeDetailPage.getErrorInfo(errCode))
            }
            else {
                /*if(listPage.getPreviousPageID() == 12) {
                    if(funcContainer.hometabindex == 0)
                        firstPageModel.deleteItemByStatusId(statusID);
                    else if(funcContainer.hometabindex == 2)
                        commentToMeModel.deleteItemByStatusId(statusID);
                }
                else if (listPage.getPreviousPageID() == 15) {
                    myWeiboModel.deleteItemByStatusId(statusID);
                }*/

                listPage.viewBack();
            }
        }
    }

    function writeRepost() {
        if(detailModel.retweetedID == "") {
            funcContainer.repostStatusID = detailModel.statusID;
            funcContainer.repostStatusText = "";
        }
        else {
            funcContainer.repostStatusID = detailModel.statusID;
            funcContainer.repostStatusText = "// @" + detailModel.userName + ": " + detailModel.statusText;
        }

        listPage.changePage(8);
    }

    //untilTime formaterr:"yyyy mm dd hh:mm:ss"
    function changeTimeStyle(timeString)
    {
			return timeString; //k
        var year = timeString.substr(0,4);
        var month = timeString.substr(5,3);
        var monthInt = tranferStringMonthToInt(month)
        var day = timeString.substr(9,2);
        var hour = timeString.substr(12,2);
        var min = timeString.substr(15,2);
//            var second = timeString.substr(17,2);
        var curr_time =  new Date();
        var curr_year = curr_time.getYear();
        if(curr_year < 200){
            curr_year = curr_year + 1900;
        }

        var curr_month = curr_time.getMonth()+1;
        var curr_day = curr_time.getDate();
        var curr_hour = curr_time.getHours();
        var curr_minute = curr_time.getMinutes();
//            var curr_second = curr_time.getSeconds();
        delete curr_time;

        var finalString;
        if(year == curr_year)
        {
            if(monthInt == curr_month)
            {
                if(day == curr_day)
                {
                    if(hour == curr_hour)
                    {
                        if (curr_minute - min > 0)
                        {
                            finalString = (curr_minute - min) + "分钟之前"
                        }
                        else
                        {
                            if(curr_minute - min == -1 )
                            {
                                finalString = 1 + "分钟之前"
                            }
                            else if(curr_minute - min == 0 )
                            {
                                finalString = 1 + "分钟之前"
                            }
                            else
                            {
                                finalString = monthInt + "-" + day + " " + hour + ":" + min;
                            }
                        }
                    }
                    else
                    {
                        if ((curr_hour - hour) > 0)
                        {
                            finalString =  (curr_hour - hour) + "小时之前";
                        }
                        else
                        {
                            finalString = monthInt + "-" + day + " " + hour + ":" + min;
                        }
                    }
                }
                else{
                    if ((curr_day - day) > 0 )
                    {
                        finalString = (curr_day - day) + "天之前";
                    }
                    else
                    {
                        finalString = monthInt + "-" + day + " " + hour + ":" + min;
                    }
                }

            }
            else
            {
                finalString = monthInt + "-" + day + " " + hour + ":" + min;
            }
        }
        else
        {
            finalString = year + "-" + monthInt + "-" + day;
        }
        return finalString;
    }

    function tranferStringMonthToInt(month)
    {
        if(month == "Jan")
        {
            return 1;
        }
        if(month == "Feb")
        {
            return 2;
        }
        if(month == "Mar")
        {
            return 3;
        }
        if(month == "Apr")
        {
            return 4;
        }
        if(month == "May")
        {
            return 5;
        }
        if(month == "Jun")
        {
            return 6;
        }
        if(month == "Jul")
        {
            return 7;
        }
        if(month == "Aug")
        {
            return 8;
        }
        if(month == "Sep")
        {
            return 9;
        }
        if(month == "Oct")
        {
            return 10;
        }
        if(month == "Nov")
        {
            return 11;
        }
        if(month == "Dec")
        {
            return 12;
        }
    }



    function analyzeText(info)
    {
        //1~10
        if(info.indexOf("[good]") != -1)
        {
            var pic = "\\[good\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/good.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[ok]") != -1)
        {
            var pic = "\\[ok\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/ok.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[不要]") != -1)
        {
            var pic = "\\[不要\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/buyao.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[乾杯]") != -1)
        {
            var pic = "\\[乾杯\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/ganbei.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[互粉]") != -1)
        {
            var pic = "\\[互粉\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/hufen.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[亲亲]") != -1)
        {
            var pic = "\\[亲亲\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/qinqin.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[伤心]") != -1)
        {
            var pic = "\\[伤心\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shangxin.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[做鬼脸]") != -1)
        {
            var pic = "\\[做鬼脸\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/zhuoguilian.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[偷笑]") != -1)
        {
            var pic = "\\[偷笑\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/touxiao.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[兔子]") != -1)
        {
            var pic = "\\[兔子\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/tuzhi.gif\">";
            info = replaceall(info,pic,path);
        }


 //       11~20
        if(info.indexOf("[可怜]") != -1)
        {
            var pic = "\\[可怜\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/keai.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[可爱]") != -1)
        {
            var pic = "\\[可爱\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/ok.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[右哼哼]") != -1)
        {
            var pic = "\\[右哼哼\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/youhehe.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[吃惊]") != -1)
        {
            var pic = "\\[吃惊\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/chijing.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[吐]") != -1)
        {
            var pic = "\\[吐\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/tu.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[呵呵]") != -1)
        {
            var pic = "\\[呵呵\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/hehe.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[咖啡]") != -1)
        {
            var pic = "\\[咖啡\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/kafei.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[哈哈]") != -1)
        {
            var pic = "\\[哈哈\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/haha.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[哼]") != -1)
        {
            var pic = "\\[哼\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/he.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[嘘]") != -1)
        {
            var pic = "\\[嘘\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/xu.gif\">";
            info = replaceall(info,pic,path);
        }


  //21~30

        if(info.indexOf("[嘻嘻]") != -1)
        {
            var pic = "\\[嘻嘻\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/xixi.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[围脖]") != -1)
        {
            var pic = "\\[围脖\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/weibo.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[围观]") != -1)
        {
            var pic = "\\[围观\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/weiguan.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[太开心]") != -1)
        {
            var pic = "\\[太开心\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/taikaixin.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[太阳]") != -1)
        {
            var pic = "\\[太阳\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/taiyang.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[失望]") != -1)
        {
            var pic = "\\[失望\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shiwang.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[实习]") != -1)
        {
            var pic = "\\[实习\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shixi.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[奥特曼]") != -1)
        {
            var pic = "\\[奥特曼\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/aoteman.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[委屈]") != -1)
        {
            var pic = "\\[委屈\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/weiqu.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[威武]") != -1)
        {
            var pic = "\\[威武\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/weiwu.gif\">";
            info = replaceall(info,pic,path);
        }

//31~40

        if(info.indexOf("[害羞]") != -1)
        {
            var pic = "\\[害羞\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/haixiu.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[左哼哼]") != -1)
        {
            var pic = "\\[左哼哼\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/zhuohehe.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[帅]") != -1)
        {
            var pic = "\\[帅\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shuai.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[干杯]") != -1)
        {
            var pic = "\\[干杯\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/ganbei2.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[弱]") != -1)
        {
            var pic = "\\[弱\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/ruo.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[微风]") != -1)
        {
            var pic = "\\[微风\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/weifeng.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[心]") != -1)
        {
            var pic = "\\[心\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/xin.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[怒]") != -1)
        {
            var pic = "\\[怒\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/nu.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[怒骂]") != -1)
        {
            var pic = "\\[怒骂\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/numa.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[思考]") != -1)
        {
            var pic = "\\[思考\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shikao.gif\">";
            info = replaceall(info,pic,path);
        }

        //41~50


        if(info.indexOf("[懒得理你]") != -1)
        {
            var pic = "\\[懒得理你\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/landelini.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[手套]") != -1)
        {
            var pic = "\\[手套\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shoutao.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[打哈气]") != -1)
        {
            var pic = "\\[打哈气\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/dahaqi.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[抓狂]") != -1)
        {
            var pic = "\\[抓狂\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/zhuakuang.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[挖鼻屎]") != -1)
        {
            var pic = "\\[挖鼻屎\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/wabishi.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[握手]") != -1)
        {
            var pic = "\\[握手\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/woshou.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[晕]") != -1)
        {
            var pic = "\\[晕\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/yun.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[月亮]") != -1)
        {
            var pic = "\\[月亮\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/yueliang.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[来]") != -1)
        {
            var pic = "\\[来\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/lai.gif\">";
            info = replaceall(info,pic,path);
        }
        if(info.indexOf("[汗]") != -1)
        {
            var pic = "\\[汗\\]";
            var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/han.gif\">";
            info = replaceall(info,pic,path);
        }

        //51~60

           if(info.indexOf("[汽车]") != -1)
           {
               var pic = "\\[汽车\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/qiche.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[沙尘暴]") != -1)
           {
               var pic = "\\[沙尘暴\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shachenbao.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[泪]") != -1)
           {
               var pic = "\\[泪\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/lei.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[浮云]") != -1)
           {
               var pic = "\\[浮云\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/fuyun.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[温暖帽子]") != -1)
           {
               var pic = "\\[温暖帽子\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/wennuanmaozhi.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[照相机]") != -1)
           {
               var pic = "\\[照相机\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/zhaoxiangji.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[熊猫]") != -1)
           {
               var pic = "\\[熊猫\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/xiongmao.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[爱你]") != -1)
           {
               var pic = "\\[爱你\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/aini.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[爱心传递]") != -1)
           {
               var pic = "\\[爱心传递\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/aixinchuandi.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[猪头]") != -1)
           {
               var pic = "\\[猪头\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/zhutou.gif\">";
               info = replaceall(info,pic,path);
           }



           //61~70

           if(info.indexOf("[生病]") != -1)
           {
               var pic = "\\[生病\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shengbing.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[疑问]") != -1)
           {
               var pic = "\\[疑问\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/yiwen.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[睡觉]") != -1)
           {
               var pic = "\\[睡觉\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shuijiao.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[礼物]") != -1)
           {
               var pic = "\\[礼物\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/liwu.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[神马]") != -1)
           {
               var pic = "\\[神马\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shenma.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[织]") != -1)
           {
               var pic = "\\[织\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/zhi.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[给力]") != -1)
           {
               var pic = "\\[给力\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/geili.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[绿丝带]") != -1)
           {
               var pic = "\\[绿丝带\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/lvshidai.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[耶]") != -1)
           {
               var pic = "\\[耶\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/ye.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[自行车]") != -1)
           {
               var pic = "\\[自行车\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/zhixingche.gif\">";
               info = replaceall(info,pic,path);
           }


           //71~80
           if(info.indexOf("[花心]") != -1)
           {
               var pic = "\\[花心\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/huaxin.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[萌]") != -1)
           {
               var pic = "\\[萌\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/meng.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[落叶]") != -1)
           {
               var pic = "\\[落叶\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/luoye.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[蛋糕]") != -1)
           {
               var pic = "\\[蛋糕\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/dangao.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[蜡烛]") != -1)
           {
               var pic = "\\[蜡烛\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/lazhu.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[衰]") != -1)
           {
               var pic = "\\[衰\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/shuai2.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[话筒]") != -1)
           {
               var pic = "\\[话筒\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/huatong.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[赞]") != -1)
           {
               var pic = "\\[赞\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/zhan.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[鄙视]") != -1)
           {
               var pic = "\\[鄙视\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/bishi.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[酷]") != -1)
           {
               var pic = "\\[酷\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/ku.gif\">";
               info = replaceall(info,pic,path);
           }



           if(info.indexOf("[钟]") != -1)
           {
               var pic = "\\[钟\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/zhong.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[钱]") != -1)
           {
               var pic = "\\[钱\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/qian.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[闭嘴]") != -1)
           {
               var pic = "\\[闭嘴\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/bizhui.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[雪]") != -1)
           {
               var pic = "\\[雪\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/xue.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[雪人]") != -1)
           {
               var pic = "\\[雪人\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/xueren.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[顶]") != -1)
           {
               var pic = "\\[顶\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/ding.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[飞机]") != -1)
           {
               var pic = "\\[飞机\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/feiji.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[馋嘴]") != -1)
           {
               var pic = "\\[馋嘴\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/chanzhui.gif\">";
               info = replaceall(info,pic,path);
           }
           if(info.indexOf("[鼓掌]") != -1)
           {
               var pic = "\\[鼓掌\\]";
               var path = "<img src=\"qrc:/qml/SinaWeiboClient/images/emotion/guzhang.gif\">";
               info = replaceall(info,pic,path);
           }

        return info;
    }

    function replaceall(sall,s1,s2)
    {
        return sall.replace(new RegExp(s1,"gm"),s2);
    }

    ListModel{
        id: speccharlist
        ListElement {specchar : ":"}
        ListElement {specchar : "："}
        ListElement {specchar : "!"}
        ListElement {specchar : "！"}
        ListElement {specchar : "@"}
        ListElement {specchar : "·"}
        ListElement {specchar : "#"}
        ListElement {specchar : "$"}
        ListElement {specchar : "￥"}
        ListElement {specchar : "%"}
        ListElement {specchar : "^"}
        ListElement {specchar : "……"}
        ListElement {specchar : "&"}
        ListElement {specchar : "*"}
        ListElement {specchar : "("}
        ListElement {specchar : "（"}
        ListElement {specchar : ")"}
        ListElement {specchar : "）"}
        ListElement {specchar : "——"}
        ListElement {specchar : "+"}
        ListElement {specchar : "="}
        ListElement {specchar : "\\"}
        ListElement {specchar : "<"}
        ListElement {specchar : "《"}
        ListElement {specchar : ">"}
        ListElement {specchar : "》"}
        ListElement {specchar : "〉"}
        ListElement {specchar : "?"}
        ListElement {specchar : "？"}
        ListElement {specchar : "/"}
        ListElement {specchar : "~"}
        ListElement {specchar : "`"}
        ListElement {specchar : "http://"}
        ListElement {specchar : ","}
        ListElement {specchar : "，"}
        ListElement {specchar : "."}
        ListElement {specchar : "。"}
        ListElement {specchar : "["}
        ListElement {specchar : "]"}
        ListElement {specchar : "|"}
        ListElement {specchar : ";"}
        ListElement {specchar : "::"}
        ListElement {specchar : "{"}
        ListElement {specchar : "}"}
        ListElement {specchar : "\'"}
        ListElement {specchar : "\""}
        ListElement {specchar : ","}
        ListElement {specchar : "～"}
        ListElement {specchar : "•"}
        ListElement {specchar : "※"}
        ListElement {specchar : "§"}
        ListElement {specchar : "】"}
        ListElement {specchar : "【"}
        ListElement {specchar : "『"}
        ListElement {specchar : "』"}

        ListElement {specchar : "‘"}
        ListElement {specchar : "’"}
        ListElement {specchar : "“"}
        ListElement {specchar : "”"}
        ListElement {specchar : "；"}

        ListElement {specchar : "、"}

        ListElement {specchar : " "}
        ListElement {specchar : "   "}
        ListElement {specchar : " "}

    }

    QueryDialog {
        id: detailpagepopup
        acceptButtonText: "确定"
        onAccepted: {
            listPage.viewBack();
        }
        onRejected:{
            listPage.viewBack();
        }
    }

    property string colorstart : "<font color=\"#043198\">"
    property string colorend : "</font>"
    property string httpstart : "<a href=\""
    property string middle : "\">";
    property string url : "http://"
    property string space : " "
    property string clickstart : "<a onclick='window.WeiboContentRect.contentClicked(\""
    property string clickmid1 : "\",\""
    property string clickmid2 : "\")'"
    property string clickend : "</a>"
    //;this.style.background = \"yellow\"
    function lookForEndPos(str, beginPos)
    {
        var res = str.length - 1;

        for(var i = 0; i < speccharlist.count; i++)
        {
            var temp = str.indexOf(speccharlist.get(i).specchar, beginPos);
            if(-1 != temp)
            {
                res = (res < temp) ? res : temp;
            }
        }
        return res;
    }

    function analyzeHttpText(weibostring)
    {

        if ("" == weibostring)
        {
            return "";
        }

        var temptext = weibostring + " ";
        var finaltext;
        var indexstart = 0;
        var indexend = 0;

        var charactor;
        var orgstr;
        var replacestr;
        var strtype;

        while(indexstart < temptext.length)
        {
            charactor = temptext.substr(indexstart, 1);

            if(charactor == "@")
            {
                indexend = lookForEndPos( temptext, indexstart + 1 ) - 1;
                strtype = "@";
            }
            else if(charactor == "#")
            {
                indexend = temptext.indexOf("#",indexstart+ 1);
                strtype = "#";
            }
						else if(charactor == "h"
						&& 0 //k
					)
            {
                if(url == temptext.substr(indexstart, 7))
                {
                    indexend = temptext.indexOf(space, indexstart) - 1;
                    strtype = "http";
                }
            }

            if(indexend > indexstart)
            {
                orgstr = temptext.substr(indexstart,(indexend - indexstart + 1));

                if(charactor == "#")
                {
                    var temp =  orgstr;
                    temp = replaceall(temp," ","");

                    if(temp == "##")
                    {
                        indexstart = indexstart + orgstr.length;
                        continue;
                    }
                }



                replacestr = clickstart + getContent(orgstr) + clickmid1 + strtype +clickmid2 + middle + colorstart+ orgstr + colorend + clickend;
                temptext = temptext.substr(0, indexstart) + replacestr + temptext.substr(indexend + 1, temptext.length - indexend);
                indexstart = indexstart + replacestr.length;
                continue;
            }
            else
            {
                indexstart++;
            }
        }

        finaltext = "<body bgcolor=#f0f1f2>" + temptext + "</body>";

        console.log("finaltext = ", finaltext);
        return finaltext;
    }

    function getContent(str)
    {
        var character = str.substr(0, 1);
        if("#" == character)
        {
            str = str.substr(1, str.length - 2);
        }
        else if("@" == character)
        {
            str = str.substr(1, str.length - 1);
        }
        return str;
    }

    function linkClicked(content,index)
    {
        console.log("index = ", index);
        console.log("content = ", content);
        if("#" == index)
        {
            funcContainer.topicName = content;
            listPage.changePage(26);
            console.log(content);
            //
        }
        else if("@" == index)
        {
            funcContainer.userNameInProfilePage = content;
            funcContainer.userIDInMyProfilePage = "";
            listPage.changePage(7);
            console.log(content);
        }
        else if("http" == index)
        {
            var openUrl = "http://3g.sina.com.cn/dpool/ttt/sinaurlc.php?vt=3&u=" + content + "&from=10132400";
            qt_funcView.openUrlInSysBrowser(openUrl);
            //listPage.changePage(38);
            //console.log(content);

        }
    }

		//k
        function _HandleRawLinkClicked(link) { var handled = false; var url = link.toString(); var pageInfo = detailModel.GetPageInfo(); if(pageInfo) { var p = /^(https?:)?(\/\/)?video\.weibo\.com\/show\?fid=(\S+)$/; p = /^(https?:)?(\/\/)?m\.weibo\.cn\/status\/\S+\?fid=([a-zA-Z0-9:]+).*$/; var arr = url.match(p); if(arr) { var object_id = arr[3]; for(var i in pageInfo) { if(pageInfo[i].object_id == object_id) { var url = pageInfo[i].media_info.stream_url; console.log("[Qml]: Play video -> " + url); _UT.OpenPlayer(url); return; } } } } if(!handled) qt_funcView.openUrlInSysBrowser(url); } //https://video.weibo.com/show?fid=1034:4403283394283582
}
