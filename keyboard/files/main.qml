import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.VirtualKeyboard 2.2

ApplicationWindow {
    visible: true
    width: 800
    height: 480
    title: "Qt5 Virtual Keyboard Example"

    Column {
        anchors.centerIn: parent
        spacing: 20

        TextField {
            width: 250
            placeholderText: "Tap to enter text"
            focus: true
        }
    }

    InputPanel {
        id: keyboard
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: Qt.inputMethod.visible
    }
}

