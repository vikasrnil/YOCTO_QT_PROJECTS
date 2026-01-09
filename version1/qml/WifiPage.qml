import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.VirtualKeyboard 2.1

Item {
    id: wifiPage
    anchors.fill: parent
    signal backRequested()

    // ---------------- Background ----------------
    Rectangle {
        anchors.fill: parent
        color: "#1C1C1C"
    }

    // ---------------- Layout ----------------
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        // --------------- HEADER -------------------
        Rectangle {
            Layout.fillWidth: true
            height: 70
            radius: 5
            color: "#2A2A2A"
            border.color: "#D2D2D2"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                spacing: 10

                // BACK BUTTON
                Button {
                    text: "Back"
                    font.pixelSize: 14
                    font.bold: true
                    background: Rectangle {
                        radius: 5
                        color: "#B9B9B9"
                    }

                    onClicked: {
                        wifiPage.backRequested();
                    }
                }

                // HEADER TEXT
                Text {
                    anchors.centerIn: parent
                    text: "Let's Connect to WI-FI"
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }

                // REFRESH BUTTON
                Button {
                    text: "Refresh"
                    font.pixelSize: 14
                    font.bold: true
                    background: Rectangle {
                        radius: 5
                        color: "#00CFDD"
                    }

                    onClicked: {
                        updateWifiList();
                    }
                }
            }
        }

        // -------------------- Main Row --------------------
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 24

            // ---------------- LEFT SIDE (Manual Input) ----------------
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 5
                color: "#2A2A2A"
                border.color: "#D2D2D2"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 20

                    // SSID Field
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: 5
                        color: "#2A2A2A"
                        border.color: "#F7FFFF"
                        border.width: 2

                        TextField {
                            id: ssidField
                            anchors.fill: parent
                            anchors.margins: 12
                            placeholderText: "SSID"
                            color: "#C9C2C2"
                            font.pixelSize: 14
                            background: Rectangle { color: "transparent" }
                        }
                    }

                    // Password Field
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: 5
                        color: "#2A2A2A"
                        border.color: "#F7FFFF"
                        border.width: 2

                        TextField {
                            id: passField
                            anchors.fill: parent
                            anchors.margins: 12
                            placeholderText: "Password"
                            echoMode: TextInput.Password
                            color: "#C9C2C2"
                            font.pixelSize: 14
                            background: Rectangle { color: "transparent" }
                        }
                    }

                    // Buttons
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        Button {
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 45
                            text: "Connect"
                            font.pixelSize: 14
                            font.bold: true
                            background: Rectangle {
                                radius: 5
                                color: "#00CFDD"
                            }
                            onClicked: {
                                if (ssidField.text === "" || passField.text === "") {
                                    statusText.text = "Please enter SSID and Password"
                                    return
                                }
                                // 🔗 call backend
                                wifi.connectToNetwork(ssidField.text, passField.text)
             

                            }
                        }

                        Button {
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 45
                            text: "Cancel"
                            font.pixelSize: 14
                            background: Rectangle {
                                radius: 5
                                color: "#B9B9B9"
                            }

                            onClicked: {
                                ssidField.text = ""
                                passField.text = ""
                               // statusText.text = ""
                            }
                        }
                    }

                    Text {
                        id: statusText
                        Layout.fillWidth: true
                        color: "yellow"
                        font.pixelSize: 18
                    }

                    // 🔗 This receives signal from backend
                    Connections {
                        target: wifi
                        function onConnectionResult(msg) { statusText.text = msg }
                    }
                }
            }

// ---------------- RIGHT SIDE (Available Networks) ----------------
Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 12
    color: "#2A2A2A"
    border.color: "#D2D2D2"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Header Text
        Text {
            text: "Available Networks"
            font.pixelSize: 18
            font.bold: true
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }

        // Scrollable List
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: wifiListView
                anchors.fill: parent
                spacing: 12
                clip: true

                // Model for ListView
                ListModel { id: wifiModel }

                // ListView Model Binding
                model: wifiModel

                // Delegate for each List Item
                delegate: Rectangle {
                    width: wifiListView.width
                    height: model.ssid && model.strength !== undefined && model.strength !== null && model.ssid !== "" ? 60 : 0 // Dynamically adjusting height
                    radius: 8
                    color: "#3A3A3A"  // Darker background for each network item
                    border.color: "#D2D2D2"
                    border.width: 1

                    // Row layout for each network item
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 16

                        // Signal Strength Icon (Image)
                        Image {
                            width: 34
                            height: 34
                            fillMode: Image.PreserveAspectFit
                            source: {
                                if (model.strength > 75)  "qrc:/images/frame1.png"
                                else if (model.strength > 50) "qrc:/images/frame2.png"
                                else if (model.strength > 25) "qrc:/images/frame3.png"
                                else if (model.strength > 0)  "qrc:/images/frame4.png"
                                else "qrc:/images/frame5.png"
                            }
                        }

                        // SSID Text (Network Name)
                        Text {
                            Layout.fillWidth: true
                            text: model.ssid
                            font.pixelSize: 16
                            color: "white"
                            verticalAlignment: Text.AlignVCenter
                        }

                        // Lock Icon (Password Required)
                        Image {
                            width: 24
                            height: 24
                            visible: model.requiresPassword
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/images/lock.png"

                            // Adding a transparent background to make the lock icon stand out
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"
                                border.color: "transparent"
                            }
                        }
                    }

                    // Mouse Area for Click Events
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            wifiPopup.selectedSSID = model.ssid
                            wifiPopup.signalStrength = model.strength
                            wifiPopup.visible = true
                        }
                    }
                }
            }
        }
    }
}


        }
    }
    
    

// --------------------- POPUP WINDOW ---------------------
Rectangle {
    id: wifiPopup
    visible: false
    anchors.centerIn: parent
    width: 420
    height: 350
    radius: 12
    color: "white"
    z: 200

    // Border around the popup
    border.color: "#00CFDD"
    border.width: 3

    // Shadow effect for better elevation
    Rectangle {
        anchors.fill: parent
        color: "#00000088"
        radius: 12
        z: -1
    }

    property string selectedSSID: ""
    property int signalStrength: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 18

        // WiFi Signal and SSID Display
        RowLayout {
            spacing: 15
            Image {
                width: 40  // Adjusted width to make the image fit properly
                height: 40  // Same height to maintain aspect ratio
                source: {
                    if (wifiPopup.signalStrength > 75)  "qrc:/images/frame1.png"
                    else if (wifiPopup.signalStrength > 50) "qrc:/images/frame2.png"
                    else if (wifiPopup.signalStrength > 25) "qrc:/images/frame3.png"
                    else "qrc:/images/frame4.png"
                }
                fillMode: Image.PreserveAspectFit  // Ensures the aspect ratio is preserved
            }
            Text {
                text: wifiPopup.selectedSSID
                font.pixelSize: 22
                font.bold: true
                color: "#2A2A2A"
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Password Input Field with border
        Rectangle {
            Layout.fillWidth: true
            height: 50
            radius: 10
            color: "#F5F5F5"
            border.color: "#00CFDD"
            border.width: 2

            TextField {
                id: popupPassField
                anchors.fill: parent
                anchors.margins: 12
                placeholderText: "Enter Password"
                color: "#333333"
                font.pixelSize: 16
                echoMode: showPasswordCheck.checked ? TextInput.Normal : TextInput.Password
                background: Rectangle { color: "transparent" }
            }
        }

        // Show Password Checkbox
        RowLayout {
            spacing: 12
            anchors.left: parent.left
            anchors.leftMargin: 12

            CheckBox {
                id: showPasswordCheck
                width: 30; height: 30
                indicator: Rectangle {
                    width: 24; height: 24
                    border.width: 2
                    border.color: showPasswordCheck.checked ? "#00CFDD" : "#888888"
                    color: showPasswordCheck.checked ? "green" : "white"
                }
            }

            Text {
                text: "Show Password"
                font.pixelSize: 16
                color: "#333333"
            }
        }

        // Buttons Row (Cancel & Connect)
        RowLayout {
            Layout.fillWidth: true
            spacing: 24
            Layout.alignment: Qt.AlignHCenter

            // Cancel Button with border and rounded corners
            Button {
                Layout.preferredWidth: 160
                Layout.preferredHeight: 45
                text: "Cancel"
                font.pixelSize: 16
                font.bold: true
                background: Rectangle {
                    radius: 8
                    color: "#B9B9B9"
                    border.color: "#888888"
                    border.width: 1
                }
                onClicked: {
                    wifiPopup.visible = false
                    popupPassField.text = ""
                }
            }

            // Connect Button with border and rounded corners
            Button {
                Layout.preferredWidth: 160
                Layout.preferredHeight: 45
                text: "Connect"
                font.pixelSize: 16
                font.bold: true
                background: Rectangle {
                    radius: 8
                    color: "#00CFDD"
                    border.color: "#00CFDD"
                    border.width: 1
                }
                onClicked: {
                    if (popupPassField.text === "") {
                        statusText.text = "Please enter password"
                        return
                    }
                    // 🔗 backend connect using selected SSID
                    wifi.connectToNetwork(wifiPopup.selectedSSID, popupPassField.text)
                    connectedPage.ssidName = wifiPopup.selectedSSID
                    connectedPage.visible = true
                    wifiPopup.visible = false
                    popupPassField.text = ""
                }
            }
        }
    }
}



Connections {
    target: wifi
    function onConnectionResult(msg, ipAddress) {
        if (msg.startsWith("Connected to")) {
            connectedPage.ssidName = msg.split(" ")[2];  // Extract SSID from the message
            connectedPage.ipAddress = ipAddress;  // Set the IP address
            connectedPage.visible = true;  // Show the connected page
        } else {
            connectedPage.visible = false;  // Hide connected page if connection failed
        }
    }
}
// ----------------- ALREADY CONNECTED PAGE -----------------
Rectangle {
    id: connectedPage
    visible: false  // Initially hidden
    anchors.fill: parent
    color: "#1C1C1C"
    z: 300

    property string ssidName: ""
    property string ipAddress: ""

    Rectangle {
        anchors {
            top: parent.top; topMargin: 40
            bottom: parent.bottom; bottomMargin: 40
            left: parent.left; leftMargin: 40
            right: parent.right; rightMargin: 40
        }
        radius: 12
        color: "#2A2A2A"
        border.width: 1
        border.color: "#444444"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 40
            spacing: 40

            Text {
                text: "You are now connected to " + connectedPage.ssidName
                font.pixelSize: 30
                font.bold: true
                color: "white"
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "IPv4 Address: " + connectedPage.ipAddress
                font.pixelSize: 20
                font.bold: true
                color: "#00CFDD"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 40
                Layout.alignment: Qt.AlignHCenter

                Button {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 45

                    contentItem: Text {
                        text: "Change WiFi"
                        color: "#FFFFFF"
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: 5
                        color: "#B9B9B9"
                    }

                    onClicked: {
                        connectedPage.visible = false
                        wifiPopup.visible = true
                    }
                }

                Button {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 45

                    contentItem: Text {
                        text: "Go Ahead"
                        color: "#FFFFFF"
                        font.pixelSize: 18
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: 5
                        color: "#00CFDD"
                    }

                    onClicked: {
                        // Hide connected page
                        connectedPage.visible = false

                        // Notify Main.qml to go back to Home Screen
                        wifiPage.backRequested()
                    }
                }
            }
        }
    }
}
    // Update Wi-Fi List
    function updateWifiList() {
        var networks = wifi.wifiList();
        wifiModel.clear();
        for (var i = 0; i < networks.length; i++) {
            wifiModel.append(networks[i]);
        }
    }

    // Initial load of Wi-Fi list
    Component.onCompleted: {
        updateWifiList();
    }
}

