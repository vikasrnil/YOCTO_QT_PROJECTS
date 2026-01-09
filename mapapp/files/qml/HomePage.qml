import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    anchors.fill: parent
    property StackView stackView

    Column {
        anchors.centerIn: parent
        spacing: 20

        Button {
            width: 120
            height: 120
            text: "🗺️"
            font.pixelSize: 40

            onClicked: {
                stackView.push(Qt.resolvedUrl("MapPage.qml"), { stackView: stackView })
            }
        }

        Text {
            text: "Open Map"
            font.pixelSize: 18
            horizontalAlignment: Text.AlignHCenter
        }
    }
}

