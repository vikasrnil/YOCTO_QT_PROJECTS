SUMMARY = "keyboard project"
LICENSE = "CLOSED"

SRC_URI = "file://keyboard.pro \
           file://main.cpp \
           file://main.qml \
           file://qml.qrc \
           "

S = "${WORKDIR}"

inherit qmake5

DEPENDS += " \
    qtbase \
    qtdeclarative \
    qtvirtualkeyboard \
"

do_install() {
    # Install binary
    install -d ${D}${bindir}
    install -m 0755 keyboard ${D}${bindir}/
    
}
