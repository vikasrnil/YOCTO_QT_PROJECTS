SUMMARY = "map load"
LICENSE = "CLOSED"

SRC_URI = "file://html/map.html \
	   file://qml/HomePage.qml \
           file://qml/main.qml \
           file://qml/MapPage.qml \
           file://mapapp.pro \
           file://main.cpp \
           file://qml.qrc \
           "

S = "${WORKDIR}"

inherit qmake5

DEPENDS += "qtbase qtdeclarative qtquickcontrols2 qtwebengine"

do_install() {
    # Install binary
    install -d ${D}${bindir}
    install -m 0755 mapapp ${D}${bindir}/
    
}
