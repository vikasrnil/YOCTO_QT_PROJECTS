SUMMARY = "Splash+can+wifi+gps"
LICENSE = "CLOSED"

SRC_URI = "file://canhandler.cpp \
	   file://canhandler.h \
           file://CanPage.qml \
           file://Wifi.qml \
           file://wifihandler.h \
           file://wifihandler.cpp \
           file://GpsPage.qml \
           file://gpsreader.h \
           file://gpsreader.cpp \
           file://main.cpp \
           file://canwifigps.pro \
           file://main.qml \
           file://qml.qrc \
           file://logo.png \
           "

S = "${WORKDIR}"

#inherit qt6-qmake
inherit qmake5

DEPENDS += "qtbase qtdeclarative qtserialport "

do_install() {
    # Install binary
    install -d ${D}${bindir}
    install -m 0755 canwifigps ${D}${bindir}/
}
