import QtQuick 1.1


Item
{
    id: sina
    width: parent.width
    height: /*userphotoarea.height*/nametimearea.height + contentarea.height + forwardarea.height + extraarea.height + line.height
//            userphotoarea > nametimearea.height + contentarea.height ? userphotoarea : nametimearea.height + contentarea.height
    signal itemClicked(int index);
    signal statusImageClicked(int index);
    signal forwardImageClicked(int index);

    property int showPic: 0

    /*Rectangle
    {
        //id:marginfoucus
        anchors.fill:parent
        border.color: "darkgray"
        color: "transparent"
        radius: 10
        smooth:  true
        visible: !showPic
    }*/

    MouseArea
    {
        id:contentMouseArea
        anchors.fill: parent
        onReleased:
        {
            console.log("Item select" + index);
            parent.itemClicked(index);
        }
    }

    //userphoto
    Item{
        id: userphotoarea
        width: 80; height: 80
        anchors.top: parent.top;  anchors.left: parent.left
//        color: "green"
//        border.color:"red"; border.width: 1
        Image {
            width: 64; height: 64
            anchors.top: parent.top; anchors.topMargin: (parent.height - height)/2
            anchors.left: parent.left; anchors.leftMargin: (parent.width - width)/2
            smooth: true
            source: image;
            Image {
                id: mask
                anchors.fill: parent
                smooth: true
                source: "../images/mask_userimage.png"
            }

            Image{
                id:vipBadge
                anchors.right: parent.right; anchors.top: parent.top
                source: "../images/icon_VIP.png"
                visible: isVip;
                smooth: true
            }
        }
        opacity: imagemouse.pressed ? 0.6 : 1.0
        MouseArea{
            id:imagemouse
            anchors.fill: parent
            onClicked: {
                if(username.text != ""){
                    funcContainer.userNameInProfilePage = username.text;
                    funcContainer.userIDInMyProfilePage = userId; //k "";
                    listPage.changePage(7);
                }
            }
        }
    }

    //Name&Time
    Item{
        id: nametimearea
        width: parent.width - userphotoarea.width; height: 50
        anchors.left: userphotoarea.right
//        color: "blue"
//        border.color:"yellow"; border.width: 1
        //UserName
        Text {
            id: username
            width: parent.width * 3 / 5;
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left; anchors.leftMargin: 10
            text: userNickName
            smooth:true;
            font.pointSize: 18;
        }

        //Time
        Text {
            id: weibotime
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 10
            text: {changeTimeStyle(untilTime);}
            color: "#646464"
            smooth:true;
            font.pointSize: 16;
        }

        //isHasImage
        Image{
            id: picBadge
            anchors.right: weibotime.left; anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
            visible:hasPic && showPic
            source: "../images/icon_picture_blue.png"
        }

        //isHasMapSSS
        Image{
            id: locBadge
            anchors.right: if(hasPic && showPic) {picBadge.left} else {weibotime.left;}
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
            visible:hasMap
            source: "../images/located.png"
        }
    }
    //content
    Item {
        id: contentarea
        anchors.left: nametimearea.left; anchors.top: nametimearea.bottom
//        color: "gray"
//        border.color:"black"; border.width: 1
        width: parent.width - userphotoarea.width;
        height: content.height + (statusPic.source == "" ? 15 :
                (statusImageLoading.visible ? statusImageLoading.height +10 : statusPic.height + 40))
        Text{
            id:content;
            anchors.left: parent.left; anchors.leftMargin: 10
            anchors.top: parent.top; anchors.topMargin: 10
            width: parent.width - 20;
            text: weibocontent
            color:"black";
            smooth:true;
            horizontalAlignment:Text.AlignLeft
            wrapMode:Text.WrapAtWordBoundaryOrAnywhere
            font.pointSize: 18;
        }

        //status image
        Rectangle{
            id:statusRec
//            anchors.left: parent.left; anchors.leftMargin: 20
//            anchors.top: content.bottom; anchors.topMargin: 5
            anchors.centerIn: statusPic
            width: statusPic.paintedWidth+10
            height: statusPic.paintedHeight+10
            border.color: "gray"
            border.width: 2
            visible: !statusImageLoading.visible && statusPic.height != 0 && showPic == 0
        }
        Image{
            id:statusPic
            anchors.left: parent.left; anchors.leftMargin: 35
            anchors.top: content.bottom; anchors.topMargin: 20
            //anchors.centerIn: statusRec
            width: Math.max(60, Math.min((funcContainer.inPortrait ? 330 : 680) , statusPic.sourceSize.width))
            height: width * (statusPic.sourceSize.height / statusPic.sourceSize.width)
            smooth:true
            fillMode: Image.PreserveAspectFit
            source: if(showPic == 0) {statusThumbnailPic}else {""}

            onStatusChanged: {
                if (statusPic.status == Image.Ready) {
                    statusImageLoading.visible = false
                }
                else if(statusPic.status == Image.Loading) {
                    statusImageLoading.visible = true;
                }  
            }

            MouseArea
            {
                anchors.fill: parent
                onReleased:
                {
                    sina.statusImageClicked(index);
                }
            }
        }

        //status loading
        Image {
            id: statusImageLoading
            anchors.top: content.bottom
            anchors.topMargin: 5
            anchors.left: parent.left;
            anchors.leftMargin: 20
            width: 120
            height: if(showPic == 0 && statusThumbnailPic != ""){70}else{0}
            smooth:true
            fillMode: Image.PreserveAspectFit
            source: "../images/image_loading.png";
            visible: false
        }
    }

    //forward
    Item{
        id: forwardarea
        width: parent.width - 70
        height: visible? forward_head.height + forward_middle.height + forward_end.height + 10: 0;
        anchors.left: nametimearea.left;
        anchors.leftMargin: -10
        anchors.top: contentarea.bottom
//        color: "gray"
//        border.color:"lightgray"; border.width: 1
        visible: forwardcontent != "" ? true : false

        //wholebg
        /*Image{
            id: bgtop
            width: parent.width
            anchors.top:parent.top;
            smooth: true
            source: "../images/bg_comments_gray_top.png"
            fillMode:Image.Stretch
        }
        Image{
            id: bgbottom
            width: parent.width
            height: parent.height - bgtop.height > 0 ? parent.height - bgtop.height : 0
            anchors.top:bgtop.bottom
            smooth: true
            source: "../images/comment_bg_bottom.png"
            fillMode:Image.Stretch
        }*/

        //topbg
        Image{
            id: forward_head
            width: parent.width - 10;
            anchors.top:parent.top; //anchors.topMargin: 5
            anchors.left: parent.left; anchors.leftMargin: 5
            smooth: true
            source: funcContainer.inPortrait ? "../images/topic_box_top.png" : "../images/topic_box_top(wide).png"
            fillMode:Image.Stretch
        }

        Image{
            id: forward_middle
            anchors.top:forward_head.bottom
            anchors.left: parent.left; anchors.leftMargin: 5
            smooth: true
            source: funcContainer.inPortrait ? "../images/topic_box_central.png" : "../images/topic_box_central(wide).png"
            width: forward_head.width
            height: forwardText.height + (forwardPic.source == "" ? 0 :
                    (forwardImageLoading.visible ? forwardImageLoading.height + 25 : forwardPic.height + 20))
            fillMode:Image.Stretch
            Text{
                id: forwardText
                width:parent.width - 30;
                anchors.left: parent.left; anchors.leftMargin: 15
                anchors.top: parent.top;
                text: forwardcontent
                color:"#4e4e4f"
                smooth:true;
                horizontalAlignment:Text.AlignLeft
                font.pointSize: 18
                wrapMode:Text.WrapAnywhere
            }

            Rectangle{
                id:forwardRec
                anchors.centerIn: forwardPic
                width: forwardPic.paintedWidth+10
                height: forwardPic.paintedHeight+10
                //z:forwardPic.z-1
                border.color: "gray"
                border.width: 2
                visible: !forwardImageLoading.visible && forwardPic.height != 0  && showPic == 0
            }

            Image{
                id: forwardPic
                anchors.left: parent.left; anchors.leftMargin: 40
                anchors.top: forwardText.bottom; anchors.topMargin: 10
                //anchors.centerIn: forwardRec
                width: Math.max(60, Math.min((funcContainer.inPortrait ? 350 : 700) , forwardPic.sourceSize.width))
                height: width * (forwardPic.sourceSize.height / forwardPic.sourceSize.width)
                smooth:true
                fillMode: Image.PreserveAspectFit
                source: if(showPic == 0) {forwardThumbnailPic}else {""}

                onStatusChanged: {
                    if (forwardPic.status == Image.Ready) {
                        forwardImageLoading.visible = false;
                    }
                    else if(forwardPic.status == Image.Loading) {
                        forwardImageLoading.visible = true;
                    }
                }

                MouseArea
                {
                    anchors.fill: parent
                    onReleased:
                    {
                        sina.forwardImageClicked(index);
                    }
                }
            }

            Image {
                id: forwardImageLoading
                anchors.left: parent.left; anchors.leftMargin: 35
                anchors.top: forwardText.bottom; anchors.topMargin: 10
                width: 120
                height: if(showPic == 0 && forwardThumbnailPic != ""){70}else{0}
                smooth:true
                fillMode: Image.PreserveAspectFit
                source: "../images/image_loading.png";
                visible: false
            }
        }
        Image{
            id: forward_end
            anchors.top:forward_middle.bottom
            anchors.left: parent.left; anchors.leftMargin: 5
            smooth: true
            source: funcContainer.inPortrait ? "../images/topic_box_bottom.png" : "../images/topic_box_bottom(wide).png"
            width: forward_head.width
            fillMode:Image.Stretch
        }
    }
    Item{
        id:extraarea
        width: parent.width
        height: (fromPlat === "" && 0 === commentCount && 0 === forwardCount) ? 0 : 40
        anchors.left: parent.left;
        anchors.top: forwardarea.visible ? forwardarea.bottom : contentarea.bottom
//        color: "green"
//        border.color:"red"; border.width: 1
        //form
        Text{
            id: frominfo
            anchors.left: parent.left; anchors.leftMargin: 90
            anchors.verticalCenter: parent.verticalCenter
            text: if(fromPlat == ""){fromPlat}else{"来自:"+fromPlat}
            color: "#646464"
            smooth:true;
            horizontalAlignment:Text.AlignLeft
            font.pointSize: 16
            wrapMode:Text.WrapAnywhere
        }
        //comment
        Text {
            id: comcount
            anchors.right: parent.right; anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: commentCount
            color: "green"
            font.pointSize: 16
            visible: commentCount > 0 ? true : false
        }
        Image {
            id: comicon
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: comcount.left; anchors.rightMargin: 5
            smooth: true
            source: "../images/icon_comment_green.png"
            visible:comcount.visible
        }
        //forward
        Text {
            id: forcount
            anchors.right: comicon.visible ? comicon.left : parent.right; anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: forwardCount
            color: "green"
            font.pointSize: 16
            visible: forwardCount > 0 ? true : false
        }
        Image {
            id: foricon
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: forcount.left; anchors.rightMargin: 5
            smooth: true
            source: "../images/icon_forward_green.png"
            visible:forcount.visible
        }
    }
    Image {
        id: line
        anchors.top: extraarea.bottom
        width: parent.width
        height: 8//if(showPic == 0) {0} else {8}
        smooth: true
        source: "../images/line.png"
        fillMode:Image.Stretch
    }

    Rectangle
    {
        id:marginfoucus
        anchors.fill:parent
        color: "lightsteelblue";
        opacity: 0.3
        z:parent.z + 1;
        visible: contentMouseArea.pressed;
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
        var curr_time = new Date();
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
}


