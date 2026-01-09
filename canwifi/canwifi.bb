SUMMARY = "Splash+can+wifi"
LICENSE = "CLOSED"

SRC_URI = "file://canhandler.cpp \
	   file://canhandler.h \
           file://CanPage.qml \
           file://main.cpp \
           file://canwifi.pro \
           file://main.qml \
           file://qml.qrc \
           file://logo.png \
           file://Wifi.qml \
           file://wifihandler.h \
           file://canwifi.desktop \
           file://wifihandler.cpp \
           "

S = "${WORKDIR}"

#inherit qt6-qmake
inherit qmake5

DEPENDS += "qtbase qtdeclarative "

do_install() {
    # Install binary
    install -d ${D}${bindir}
    install -m 0755 canwifi ${D}${bindir}/
    
        # Install desktop autostart file
    install -d ${D}/etc/xdg/autostart
    install -m 0644 ${WORKDIR}/canwifi.desktop ${D}/etc/xdg/autostart/
}
