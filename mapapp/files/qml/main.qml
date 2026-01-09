import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Qt Leaflet Map App"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: HomePage {
            stackView: stackView
        }
    }
}

