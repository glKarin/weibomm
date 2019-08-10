function createContainer(qmlFilePath, parent) {
    var component;
    var dynamicObject
    component = Qt.createComponent(qmlFilePath);
    // Note that if Block.qml was not a local file, component.status would be
    // Loading and we should wait for the component's statusChanged() signal to
    // know when the file is downloaded and ready before calling createObject().
    if (component.status == Component.Ready) {
        dynamicObject = component.createObject(parent);
        if (dynamicObject == null) {
            console.log("error creating createWidgets");
            console.log(component.errorString());
        }
    } else {
        console.log("error loading Widgets component");
        console.log(component.errorString());
    }
    return dynamicObject;
}

function releaseObject(parobject){
    parobject.destroy();
}
