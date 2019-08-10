import QtQuick 1.1
import com.nokia.meego 1.0
import "SinaWeiboErrorCode.js" as SinaWeiboMainErrorCode

Page {
    id: listPage

    property int findTimes: 0
    property int viewBackCount: 0
    visible: false
    ListModel{
        id: pageIdList;
    }

    function openFile(file, pageId) {
        var component = Qt.createComponent(file)

        if (component.status == Component.Ready) {
            pageStack.push(component);
            pageIdList.append( {"id": pageId} );
        }
        else
            console.log("Error loading component:", component.errorString());
    }

    function changePage(pageNum) {
        console.log("listPage changePage, pageNum: ", pageNum);

        //if you want to change to the exist page, only need to jump to the exist page.
        if (pageNum == 12) {
            var exist = false;
            for (var i = pageIdList.count - 1; i >= 0; i--) {
                if (pageIdList.get(i).id == pageNum) {
                    exist = true;
                    break;
                }
            }

            //if exist, jump.
            if(exist == true) {
                funcContainer.pageNumforCache = 0;
                jumpPageTo(pageNum);
                return;
            }
        }
        //if doesn't exist, open.
        switch(pageNum){
        //登陆
        case 1:
            openFile("SinaWeiboLoginPage.qml", pageNum);
            break;
        //注册
        case 2:
            openFile("SinaWeiboRegisterPage.qml", pageNum);
            break;
        //欢迎
        case 3:
            openFile("SinaWeiboWelcomPage.qml", pageNum);
            break;
        //完善资料
        case 4:
            openFile("SinaWeiboUpdateProfile.qml", pageNum);
            break;
        //随便看看
        case 5:
            openFile("SinaWeiboSuibianKanKan.qml", pageNum);
            break;
        //正文
        case 6:
            openFile("SinaWeiboContentDetailPage.qml", pageNum);
            break;
        //用户信息
        case 7:
            openFile("SinaWeiboUserProfilePage.qml", pageNum);
            break;
        //转发
        case 8:
            funcContainer.microBlogId=2;
            openFile("SinaWeiboNewBlog.qml", pageNum);
            break;
        //评论
        case 9:
            funcContainer.microBlogId=1;
            openFile("SinaWeiboNewBlog.qml", pageNum);
            break;
        //评论列表
        case 10:
            openFile("SinaWeiboContentComment.qml", pageNum);
            break
        //发表新微博
        case 11:
            funcContainer.microBlogId=0;
            openFile("SinaWeiboNewBlog.qml", pageNum);
            break;
        //主页面
        case 12:
            openFile("SinaWeiboMainContainer.qml", pageNum);
            break;
        //消息/@我
        case 13:
            break;
        //我的资料
        case 14:
            break;
        //我的微博
        case 15:
            openFile("SinaWeiboMyWeiboList.qml", pageNum);
            break;
        //关于
        case 16:
            openFile("SinaWeiboAboutPage.qml", pageNum);
            break;
        //设置
        case 17:
            openFile("SinaWeiboSettingPage.qml", pageNum);
            break;
        //阅读模式
        case 18:
            openFile("SinaWeiboReadMode.qml", pageNum);
            break;
        //账号管理
        case 19:
            openFile("SinaWeiboAccount.qml", pageNum);
            break;
        //热门话题
        case 20:
            openFile("SinaWeiboHotTrend.qml", pageNum);
            break;
        //搜索微博
        case 21:
            openFile("SinaWeiboSearchBlogPage.qml", pageNum);
            break;
        //搜人
        case 22:
            openFile("SinaWeiboSearchUserPage.qml", pageNum);
            break;
        //搜索
        case 24:
            openFile("SinaWeiboSearchPage.qml", pageNum);
            break;
        //发私信
        case 25:
            funcContainer.microBlogId=3;
            openFile("SinaWeiboNewBlog.qml", pageNum);
              break;
        //话题下微博列表
        case 26:
            openFile("SinaWeiboTrendsBlogPage.qml", pageNum);
            break;
        //插入话题
        case 27:
            openFile("SinaWeiboInsertTopicPage.qml", pageNum);
            break;
        //搜索话题
        case 28:
            openFile("SinaWeiboSearchTopicPage.qml", pageNum);
            break;
        //常用联系人
        case 29:
            openFile("SinaWeiboFrequentContactsPage.qml", pageNum);
            break;
        //搜索联系人
        case 30:
            openFile("SinaWeiboSearchContactsPage.qml", pageNum);
            break;
        //关注列表
        case 31:
            funcContainer.typeForListContainer = 2;
            openFile("SinaWeiboFriendList.qml", pageNum);
            break;
        //热门话题_插入话题
        case 32:
            openFile("SinaWeiboHotTrend.qml", pageNum);
            break;
        //私信详细信息
        case 33:
            openFile("SinaWeiboMessageDetail.qml", pageNum);
            break;
        //我关注的话题
        case 34:
            openFile("SinaWeiboMyTrendTopic.qml", pageNum);
            break;
        //添加帐户
        case 35:
            openFile("SinaWeiboAddAccount.qml", pageNum);
            break;
        case 36:
            openFile("SinaWeiboMyFavoritesList.qml", pageNum);
            break;
        //PicViewer
        case 37:
            openFile("SinaWeiboPicViewer.qml", pageNum);
            break;

//        //for Webview
//        case 38:
//            openFile("SinaWeiboWebview.qml", pageNum);
//            break;
        case 40:
            funcContainer.typeForListContainer = 1;
            funcContainer.listNeedRefresh = true;
            openFile("SinaWeiboListContainer.qml", pageNum);
            break;
        case 41:
            funcContainer.typeForListContainer = 0;
            funcContainer.listNeedRefresh = true;
            openFile("SinaWeiboListContainer.qml", pageNum);
            break;
        case 42:
            openFile("SinaWeiboGallery.qml", pageNum);
            break;
        case 43:
            openFile("SinaWeiboCamera.qml", pageNum);
            break;
        case 44:
            openFile("SinaWeiboPhotoPreview.qml", pageNum);
            break;
        case 45:
            funcContainer.microBlogId=4;
            openFile("SinaWeiboNewBlog.qml", pageNum);
            break;
        default:
            break;
        }

        funcContainer.pageNumforCache++;
    }

    //back to the previous view.
    function viewBack() {
        pageStack.pop();
        pageIdList.remove(pageIdList.count - 1);
    }

    //jump to the specify page.
    function jumpPageTo(pageNum) {
        viewBackCount = 0;
        for (var i = pageIdList.count - 1; i >= 0; i--) {
            if (pageIdList.get(i).id == pageNum) {
                break;
            }
            else {
                viewBackCount++;
            }
        }

        if(viewBackCount > 0){
            findTimes = 0;
            var page = pageStack.find(findPage);

            pageStack.pop(page);

            for (var i = 0; i < viewBackCount; i++) {
                pageIdList.remove(pageIdList.count - 1);
            }
        }
    }

    //callback function. used for pageStack.find.
    function findPage(page) {
        if(findTimes == viewBackCount) {
            findTimes++;
            return true;
        }
        else{
            findTimes++;
            return false;
        }
    }

    //get the previous page id.
    function getPreviousPageID() {
        if(pageIdList.count < 2)
            return -1;
        else {
            console.log(pageIdList.get(pageIdList.count - 2).id);
            return pageIdList.get(pageIdList.count - 2).id;
        }
    }

    Image {
        id: loadingpic
        anchors.fill: parent
        source: {
            if(loadingpic.height > loadingpic.width )
            {"images/blog_loading.png"}
            else
            {"images/blog_loading_landscape.png"}
        }
        onStatusChanged: {
            if(loadingpic.status == Image.Ready){
                qt_funcView.printCurrentTime("=======Image.Ready========");
            }
        }
    }

    Timer {
        id: loadingtimer
        interval: 10; running: false; repeat: false;
        onTriggered: {
            qt_funcView.printCurrentTime("=======init begin========");

            funcContainer.readMode = settingModel.readMode;
            qt_funcView.printCurrentTime("=======init end========");

            //
            console.log("newMsgNotification.newMsgCome.connect");
            newMsgNotification.newMsgCome.connect(funcContainer.playnotification);
            console.log("newMsgNotification.newMsgCome.connect end");

            loadingtimer.running = false;
//            funcContainer.showStatusBar = true;
            if(accountModel.getAccountCount() == 0) {
                changePage(1);
            }
            else {
                //accountModel.login();
                changePage(12);
            }

						//k
						_UT.CheckUpdate(false);
        }
    }

    Component.onCompleted:{
//        funcContainer.showStatusBar = false;
        qt_funcView.init();
        loadingtimer.running = true;

				//k
				_UT.RenderPatchInfo(loadingpic);

        //accountModel.loginFinish.connect(listPage.loginFinished);
    }

  /*  function loginFinished(errCode) {
        console.log(errCode)
        if(errCode == -1) {
            funcContainer.makeWaitingDialogVisible(true);
        }
        else {
            funcContainer.makeWaitingDialogVisible(false);

            if(errCode == 200){
                listPage.changePage(12);
            }
            else {
                if(errCode == 403 || errCode == 202) {
                    funcContainer.showPopup("用户名或密码错误.");
                }
                else if(errCode == 99) {
                    popup.popupContent = "网络异常，请重试！";
                    popup.open();
                }
                else
                    funcContainer.showPopup(SinaWeiboMainErrorCode.getErrorInfo(errCode));
            }
        }
    }

    QueryDialog {
        id: popup
        property string popupContent

        titleText: "提示"
        icon: "images/icon_popup.png"
        message: "\n"+popupContent+"\n"
        acceptButtonText: "确定"

        onAccepted:{
            accountModel.login();
        }
    }
*/

}
