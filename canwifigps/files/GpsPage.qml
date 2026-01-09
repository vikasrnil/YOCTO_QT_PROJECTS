import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    anchors.fill: parent
    color: "#f0f0f0"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "📡 GPS Data"
            font.pixelSize: 32
            font.bold: true
            color: "#333333"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            id: gpsOutput
            text: gpsReader.connected ? gpsReader.rmcString : "❌ No Serial Connected"
            font.pixelSize: 20
            color: gpsReader.connected ? "#1565C0" : "red"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            text: "⬅ Back"
            onClicked: stackView.pop()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: gpsOutput.text = gpsReader.connected ? gpsReader.rmcString : "❌ No Serial Connected"
    }
}

