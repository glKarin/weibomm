import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    id: searchbar
    property string bgsource: "../images/refreshtimebg.png"
    property string textContent: ""
    property string textcolor: "white"
    property int textOffset: 16
    property int titlesize: 30
    property int myStyle: 0
    property int imgType: 0
    signal clicked
    signal searchTextChanged
    color: "#E7E7E7"
//    Image {
//        id: bg
//        anchors.fill: parent
//        fillMode:Image.Stretch
//        source: bgsource
//    }


    TextField {
        id: searchBox
        width: parent.width
        height: 50
        anchors {left: parent.left; leftMargin : 10; right: parent.right; rightMargin: 10;}
        anchors.verticalCenter: parent.verticalCenter
        inputMethodHints: Qt.ImhNoPredictiveText
        placeholderText: "搜索"
        text:textContent
        style: TextFieldStyle { paddingRight: searchButton.width; }
        enableSoftwareInputPanel: true
        function onActiveFocusChanged() {
            if (activeFocus) {
                platformOpenSoftwareInputPanel();
            } else {
                platformCloseSoftwareInputPanel();
            }
        }

        onTextChanged: {
            console.log("text changed!");
            textContent = searchBox.text;
            searchbar.searchTextChanged();
        }

        Item{
            width: 80
            height: 50
            anchors.right: parent.right
            Image {
                id: searchButton
                width:50
                height: 50
               // fillMode: Image.PreserveAspectFit
                scale: 0.8
                smooth: true
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                source: {
                    if(myStyle == 0)
                    {
                      imgType = 0;
                      return  "image://theme/icon-m-toolbar-search"
                    }
                    else if(myStyle == 1)
                    {
                        if(textContent == "")
                        {
                           imgType = 0;
                           return  "image://theme/icon-m-toolbar-search"
                        }
                        else
                        {
                           imgType = 1;
                           return  "image://theme/icon-m-input-clear"
                        }
                    }
                }

            }

            MouseArea {
                anchors.fill: parent
                onReleased: {
                    if(imgType == 0)
                    {
                    textContent = searchBox.text;
                    searchbar.clicked();
                    }
                    else
                    {
                        textContent = "";
                    }
                }
            }

        }
    }

    function setFocusActived()
    {
        searchBox.onActiveFocusChanged();
    }
}
