import QtQuick 1.1
import Qt.labs.shaders 1.0

ShaderEffectItem{
	id: root;
	property bool mouse: true;
	property variant item; // 渲染元素
	property real waveFactory: 0.01; // 波纹晃动系数
	property variant center: Qt.point(0, 0); // 波纹中心点
	property real waveRollSpeed: 0.1; // 波纹摆动速度
	property color waterColor: "white"; // 水颜色
	property real radiusLimit: 400; // 波纹最大半径
	property real waveSpeed: 10; // 波纹扩散速度
	property real waveWidth: 18; // 每个波纹宽度
	property real waterIdentity: 0.4; // 水颜色浓度
	property alias interval: timer.interval;

	property variant texture0: ShaderEffectSource{ sourceItem: item; hideSource: true; }
	property real radius: 0;
	property real placeRadius: 0;
	property real offset: 0.0;

	anchors.fill: item;
	objectName: "karinWaterWaveShader";

	//vertexShader: "";
	fragmentShader: "
	#define M_PI 3.1415926

	precision mediump float;
	varying vec2 qt_TexCoord0;
	uniform sampler2D texture0;
	uniform float waveFactory;
	uniform vec2 center;
	uniform float radius;
	uniform float placeRadius;
	uniform float offset;
	uniform vec4 waterColor;
	uniform float waterIdentity;
	uniform float waveWidth;

	vec2 dir;
	float len;

	bool inEffect()
	{
		return(len < radius && len > placeRadius);
	}

	float effect()
	{
		float c = len / waveWidth;
		float per = sin(offset * M_PI + c * M_PI);
		return per / 2.0 + 0.5;
	}

	vec2 effectCoord(float per)
	{
		vec2 nor = normalize(dir);
		nor *= waveFactory * per;
		return clamp(qt_TexCoord0 + nor, 0.0, 1.0);
	}

	void main(){
		vec4 color = vec4(0.0);
		dir = gl_FragCoord.xy - center;
		len = sqrt(pow(dir.x, 2.0) + pow(dir.y, 2.0));
		if(inEffect()){
			float per = effect();
			color = mix(texture2D(texture0, effectCoord(per)), waterColor, per * waterIdentity);
		} else {
			color = texture2D(texture0, qt_TexCoord0);
		}
		gl_FragColor = color;
	}
	";

	Timer{
		id: timer;
		running: true;
		repeat: true;
		interval: 100;
		onTriggered: {
			root.offset -= root.waveRollSpeed;
			if(root.offset <= -2.0)
			{
				root.offset += 2.0;
			}
			if(root.radius > radiusLimit)
			{
			}
			else
			{
				root.radius += root.waveSpeed;
			}

			if(root.placeRadius > radiusLimit)
			{
				root.radius = 0;
				root.offset = 0.0;
				root.placeRadius = 0;
			}
		}
	}

	function toggle()
	{
		time.running ^= 1;
	}

	function setCenter(x, y)
	{
		root.center = Qt.point(y, x);
		root.placeRadius = 0;
		root.offset = 0.0;
	}

	function pause()
	{
		timer.stop();
	}

	function play()
	{
		timer.start();
	}

	function stop()
	{
		timer.stop();
		reset();
	}

	function reset()
	{
		root.radius = 0;
		root.placeRadius = 0;
		root.offset = 0.0;
	}

	MouseArea{
		id: mouseArea;
		anchors.fill: parent;
		enabled: root.mouse && root.item != null;
		onClicked: {
			setCenter(mouse.x, mouse.y);
			//mouse.accepted = false;
		}
	}

}
