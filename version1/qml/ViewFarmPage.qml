// ViewFarmPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine 1.9

Page {
    id: viewPage
    width: 760
    height: 440

    signal backPressed()
    property string farmJson: ""

    Rectangle { anchors.fill: parent; color: "#1E1E1E" }

    Row {
        height: 45
        Rectangle {
            anchors.fill: parent
            color: "#111"
        }

        Button {
            text: "<"
            width: 40
            onClicked: backPressed()
        }

        Text {
            text: "Farm Preview"
            color: "white"
            font.pixelSize: 18
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
        }
    }

    WebEngineView {
        id: web
        anchors {
            top: parent.top
            topMargin: 50
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 12
        }
        url: "qrc:map_view.html"
        settings.localContentCanAccessRemoteUrls: true
    }

    function showFarmOnMap() {
        if(farmJson === "") return;
        let safeJson = JSON.stringify(farmJson)
        web.runJavaScript("showSavedFarm(" + safeJson + ")")
    }

    Component.onCompleted: showFarmOnMap()
    onFarmJsonChanged: showFarmOnMap()
}

