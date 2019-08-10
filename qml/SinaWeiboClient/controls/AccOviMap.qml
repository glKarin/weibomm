import QtQuick 1.0

Item {
    id: mapTile

    property real latitude
    property real longitude
    property int zoom
    property bool isHasMap: false

    function loadMap()
    {
	errorText.visible = false;
	mapImage.visible = false;
	loadingView.visible = true;

        if(isHasMap){
            mapImage.source = 'http://m.ovi.me/?c=' + latitude + ',' + longitude +
                '&z=' + zoom +
                    '&w=' + mapImage.width + '&h=' + mapImage.height + '&ml=chi&mv=chi&nord';
        }
    }

    Image {
	id: mapImage
	anchors.fill: parent
	onStatusChanged: {
	    if(mapImage.status == Image.Error)
	    {
		loadingView.visible = false;
		mapImage.visible = false;
		errorText.visible = true;
	    }
	    else if(mapImage.status == Image.Ready)
	    {
		errorText.visible = false;
		loadingView.visible = false;
		mapImage.visible = true;
	    }
	    else
	    {
		errorText.visible = false;
		mapImage.visible = false;
		loadingView.visible = true;
	    }
	}
    }
    Text {
	id: errorText
	anchors.centerIn: parent
	text: "Error loading the map"
    }

    Column
    {
	id: loadingView
	anchors.centerIn: parent

        Image{
            id: icon
            anchors.horizontalCenter: parent.horizontalCenter
            smooth: true
            source: "../images/addLocation.png"
            fillMode: Image.PreserveAspectFit
        }
    }

    Component.onCompleted: {

	mapTile.zoomChanged.connect(loadMap)
	mapTile.latitudeChanged.connect(loadMap)
	mapTile.longitudeChanged.connect(loadMap)

	loadMap()
    }
}
