import QtQuick 2.12
import QtQuick.Controls 2.5
import QtWebEngine 1.7
import QtQuick.Layouts 1.12

Item {
    anchors.fill: parent
    property StackView stackView

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Button {
            text: "← Back"
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            onClicked: stackView.pop()
        }

        WebEngineView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            url: "qrc:/html/map.html"
        }
    }
}

