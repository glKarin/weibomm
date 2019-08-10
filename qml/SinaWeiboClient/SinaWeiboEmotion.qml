import QtQuick 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Rectangle {
    id:emotion
    color: "lightgray"
     //color:"gray"
//    width: parent.width//parent.width
//    height: funcContainer.inPortrait ? 344:236
    property string path:emotionlist.getPath()
    property string emotionContent

    signal itemClick(string emotionString);

    //height:265
//    visible: false
    property int itemcountperpage: funcContainer.inPortrait ? 32:42


    ListView {
        id: view
        height: funcContainer.inPortrait ? 331:236
        width: parent.width

        model: emotionlist.getPageCount(itemcountperpage)//pages
        preferredHighlightBegin: 0; preferredHighlightEnd: 0
        highlightRangeMode: ListView.StrictlyEnforceRange
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem; flickDeceleration: 2000
        delegate: Item {
            height: view.height
            width: view.width
            property int myindex: index

            Image {
                id: bg
                anchors.fill: parent
                source: funcContainer.inPortrait ? "images/emotionbg_portrait.png" : "images/emotionbg_land.png"
            }

            GridView {
                id:emotionGridview
                anchors.fill: parent
                model:itemcountperpage
                cellWidth: (view.width) / (funcContainer.inPortrait ? 8:14)
                cellHeight: (view.height - 50) / (funcContainer.inPortrait ? 4 : 3)
                interactive:false

                delegate:Item{
                        width: emotionGridview.cellWidth
                        height:emotionGridview.cellHeight
                        Rectangle{
                            id: itembg
                            anchors.fill: parent
                            anchors.margins: 2
                            color: itemmouse.pressed ? "#f0f1f2" : "transparent"
                        }
                        Image {
                            id: emoitem
                            width: 22
                            height: 22
                            anchors.centerIn: parent
                            source:emotionlist.getIconPath(myindex, index, itemcountperpage)
                        }
                        MouseArea{
                            id: itemmouse
                            anchors.fill: parent
                            //emotionGridview.currentIndex
                            onClicked: {
                                //property string emotionpath: emotionlist.getIconPath(myindex, index, itemcountperpage)
                                switch(emotionlist.getIconPath(myindex, index, itemcountperpage))
                                {
                                    // 1~10
                                case "images/emotion_png/good.png":
                                emotionContent = "[good]"
                                break;
                                case "images/emotion_png/ok.png":
                                emotionContent = "[ok]";
                                break;
                                case "images/emotion_png/buyao.png":
                                emotionContent = "[不要]";
                                break;
                                case "images/emotion_png/ganbei.png":
                                emotionContent = "[乾杯]";
                                break;
                                case "images/emotion_png/hufen.png":
                                emotionContent = "[互粉]";
                                break;
                                case "images/emotion_png/qinqin.png":
                                emotionContent = "[亲亲]";
                                break;
                                case "images/emotion_png/shangxin.png":
                                emotionContent = "[伤心]";
                                break;
                                case "images/emotion_png/zhuoguilian.png":
                                emotionContent = "[做鬼脸]";
                                break;
                                case "images/emotion_png/touxiao.png":
                                emotionContent = "[偷笑]";
                                break;
                                case "images/emotion_png/tuzhi.png":
                                emotionContent = "[兔子]";
                                break;

                                // 11~20
                                case "images/emotion_png/kelian.png":
                                emotionContent = "[可怜]";

                                break;
                                case "images/emotion_png/keai.png":
                                emotionContent = "[可爱]";
                                break;
                                case "images/emotion_png/youhehe.png":
                                emotionContent = "[右哼哼]";

                                break;
                                case "images/emotion_png/chijing.png":
                                emotionContent = "[吃惊]";

                                break;
                                case "images/emotion_png/tu.png":
                                emotionContent = "[吐]";
                                break;
                                case "images/emotion_png/hehe.png":
                                emotionContent = "[呵呵]";
                                break;
                                case "images/emotion_png/kafei.png":
                                emotionContent = "[咖啡]";
                                break;
                                case "images/emotion_png/haha.png":
                                emotionContent = "[哈哈]";
                                break;
                                case "images/emotion_png/he.png":
                                emotionContent = "[哼]";
                                break;
                                case "images/emotion_png/xu.png":
                                emotionContent = "[嘘]";
                                break;


                                 //21~30
                                case "images/emotion_png/xixi.png":
                                emotionContent = "[嘻嘻]";

                                break;
                                case "images/emotion_png/weibo.png":
                                emotionContent = "[围脖]";
                                break;
                                case "images/emotion_png/weiguan.png":
                                emotionContent = "[围观]";

                                break;
                                case "images/emotion_png/taikaixin.png":
                                emotionContent = "[太开心]";

                                break;
                                case "images/emotion_png/taiyang.png":
                                emotionContent = "[太阳]";
                                break;
                                case "images/emotion_png/shiwang.png":
                                emotionContent = "[失望]";
                                break;
                                case "images/emotion_png/aoteman.png":
                                emotionContent = "[奥特曼]";
                                break;
                                case "images/emotion_png/weiqu.png":
                                emotionContent = "[委屈]";
                                break;
                                case "images/emotion_png/weiwu.png":
                                emotionContent = "[威武]";
                                break;
                                case "images/emotion_png/shixi.png":
                                emotionContent = "[实习]";
                                break;


                                //31~40
                                case "images/emotion_png/haixiu.png":
                                emotionContent = "[害羞]";

                                break;
                                case "images/emotion_png/zhuohehe.png":
                                emotionContent = "[左哼哼]";
                                break;
                                case "images/emotion_png/shuai.png":
                                emotionContent = "[帅]";

                                break;
                                case "images/emotion_png/ganbei2.png":
                                emotionContent = "[干杯]";

                                break;
                                case "images/emotion_png/ruo.png":
                                emotionContent = "[弱]";
                                break;
                                case "images/emotion_png/weifeng.png":
                                emotionContent = "[微风]";
                                break;
                                case "images/emotion_png/xin.png":
                                emotionContent = "[心]";
                                break;
                                case "images/emotion_png/nu.png":
                                emotionContent = "[怒]";
                                break;
                                case "images/emotion_png/numa.png":
                                emotionContent = "[怒骂]";
                                break;
                                case "images/emotion_png/shikao.png":
                                emotionContent = "[思考]";
                                break;

                                    //41~50


                                case "images/emotion_png/landelini.png":
                                emotionContent = "[懒得理你]";

                                break;
                                case "images/emotion_png/shoutao.png":
                                emotionContent = "[手套]";
                                break;
                                case "images/emotion_png/dahaqi.png":
                                emotionContent = "[打哈气]";

                                break;
                                case "images/emotion_png/zhuakuang.png":
                                emotionContent = "[抓狂]";

                                break;
                                case "images/emotion_png/wabishi.png":
                                emotionContent = "[挖鼻屎]";
                                break;
                                case "images/emotion_png/woshou.png":
                                emotionContent = "[握手]";
                                break;
                                case "images/emotion_png/yun.png":
                                emotionContent = "[晕]";
                                break;
                                case "images/emotion_png/yueliang.png":
                                emotionContent = "[月亮]";
                                break;
                                case "images/emotion_png/lai.png":
                                emotionContent = "[来]";
                                break;
                                case "images/emotion_png/han.png":
                                emotionContent = "[汗]";
                                break;


                             //51~60

                                case "images/emotion_png/qiche.png":
                                emotionContent = "[汽车]";

                                break;
                                case "images/emotion_png/shachenbao.png":
                                emotionContent = "[沙尘暴]";
                                break;
                                case "images/emotion_png/lei.png":
                                emotionContent = "[泪]";

                                break;
                                case "images/emotion_png/fuyun.png":
                                emotionContent = "[浮云]";

                                break;
                                case "images/emotion_png/wennuanmaozhi.png":
                                emotionContent = "[温暖帽子]";
                                break;
                                case "images/emotion_png/zhaoxiangji.png":
                                emotionContent = "[照相机]";
                                break;
                                case "images/emotion_png/xiongmao.png":
                                emotionContent = "[熊猫]";
                                break;
                                case "images/emotion_png/aini.png":
                                emotionContent = "[爱你]";
                                break;
                                case "images/emotion_png/aixinchuandi.png":
                                emotionContent = "[爱心传递]";
                                break;
                                case "images/emotion_png/zhutou.png":
                                emotionContent = "[猪头]";
                                break;

                                    //61~70

                                case "images/emotion_png/shengbing.png":
                                emotionContent = "[生病]";

                                break;
                                case "images/emotion_png/yiwen.png":
                                emotionContent = "[疑问]";
                                break;
                                case "images/emotion_png/shuijiao.png":
                                emotionContent = "[睡觉]";

                                break;
                                case "images/emotion_png/liwu.png":
                                emotionContent = "[礼物]";

                                break;
                                case "images/emotion_png/shenma.png":
                                emotionContent = "[神马]";
                                break;
                                case "images/emotion_png/zhi.png":
                                emotionContent = "[织]";
                                break;
                                case "images/emotion_png/geili.png":
                                emotionContent = "[给力]";
                                break;
                                case "images/emotion_png/lvshidai.png":
                                emotionContent = "[绿丝带]";
                                break;
                                case "images/emotion_png/ye.png":
                                emotionContent = "[耶]";
                                break;
                                case "images/emotion_png/zhixingche.png":
                                emotionContent = "[自行车]";
                                break;

                                //71~80

                                case "images/emotion_png/huaxin.png":
                                emotionContent = "[花心]";

                                break;
                                case "images/emotion_png/meng.png":
                                emotionContent = "[萌]";
                                break;
                                case "images/emotion_png/luoye.png":
                                emotionContent = "[落叶]";

                                break;
                                case "images/emotion_png/dangao.png":
                                emotionContent = "[蛋糕]";

                                break;
                                case "images/emotion_png/lazhu.png":
                                emotionContent = "[蜡烛]";
                                break;
                                case "images/emotion_png/shuai2.png":
                                emotionContent = "[衰]";
                                break;
                                case "images/emotion_png/huatong.png":
                                emotionContent = "[话筒]";
                                break;
                                case "images/emotion_png/zhan.png":
                                emotionContent = "[赞]";
                                break;
                                case "images/emotion_png/bishi.png":
                                emotionContent = "[鄙视]";
                                break;
                                case "images/emotion_png/ku.png":
                                emotionContent = "[酷]";
                                break;

                                 //81~89
                                case "images/emotion_png/zhong.png":
                                emotionContent = "[钟]";

                                break;
                                case "images/emotion_png/qian.png":
                                emotionContent = "[钱]";
                                break;
                                case "images/emotion_png/bizhui.png":
                                emotionContent = "[闭嘴]";

                                break;
                                case "images/emotion_png/xue.png":
                                emotionContent = "[雪]";

                                break;
                                case "images/emotion_png/xueren.png":
                                emotionContent = "[雪人]";
                                break;
                                case "images/emotion_png/ding.png":
                                emotionContent = "[顶]";
                                break;
                                case "images/emotion_png/feiji.png":
                                emotionContent = "[飞机]";
                                break;
                                case "images/emotion_png/chanzhui.png":
                                emotionContent = "[馋嘴]";
                                break;
                                case "images/emotion_png/guzhang.png":
                                emotionContent = "[鼓掌]";
                                break;

                                default:
                                emotionContent = "";
                                break;


                                }

                                emotion.itemClick (emotionContent);
                            }
                        }
                    }

            }
        }

    }

    Item {
        id: pageindicator
        width: parent.width;
        height: 49
        anchors.top: parent.top
        anchors.topMargin: emotion.height - pageindicator.height
        visible: emotion.height > (funcContainer.inPortrait ? 300 : 200) ? true : false

        Row {
            anchors.centerIn: parent
            spacing: 20

            Repeater {
                model: 3
                Rectangle {
                    width: 8; height: 8
                    radius: 8
                    color: view.currentIndex == index ? "white" : "gray"

                    MouseArea {
                        width: 20; height: 20
                        anchors.centerIn: parent
                        onClicked: view.currentIndex = index
                    }
                }
            }
        }
    }
}
