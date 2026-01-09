SUMMARY = "qt project version 1"
LICENSE = "CLOSED"

SRC_URI = "file://Connection.cpp \
	   file://Connection.h \
           file://Farmbackend.cpp \
           file://Farmbackend.h \
           file://GpsDataManager.cpp \
           file://GpsDataManager.h \
           file://GpsPathModel.cpp \
           file://GpsPathModel.h \
           file://implement.cpp \
           file://implement.h \
           file://operations.cpp \
           file://qml/AddFarmOptionalsPage.qml\
           file://qml/AddFarmPage.qml \
           file://qml/FarmPlotPage.qml \
           file://qml/FeatureButton.qml \
           file://qml/GeneratePathPage.qml \
           file://qml/HomePage.qml \
           file://qml/ImplementDetailsPopup.qml \
           file://qml/ImplementPage.qml \
           file://qml/Main.qml \
           file://qml/PlotFarmPage.qml \
           file://qml/SavedFarmPage.qml \
           file://qml/SavedImplementsPage.qml \
           file://qml/SavedTractorsPage.qml \
           file://qml/TraceFarmPage.qml \
           file://qml/TractorDetailsPopup.qml \
           file://qml/TractorPage.qml \
           file://qml/ViewFarmPage.qml \
           file://qml/WifiPage.qml \
           file://images/Farmland.png \
           file://images/implement.png \
           file://images/logo.png \
           file://images/Path.png \
           file://images/Settings.png \
           file://images/tractor.png \
	   file://images/frame1.png \
           file://images/frame2.png \
           file://images/frame3.png \
           file://images/frame4.png \
           file://images/frame5.png \
           file://images/lock.png \
           file://map.html \
           file://map_view.html \
           file://farmdb.json \
           file://implementdb.json \
           file://tractor.json \  
           "

S = "${WORKDIR}"

inherit qmake5

DEPENDS += "qtbase qtdeclarative qtquickcontrols2 gui network serialport webengine"

do_install() {
    # Install binary
    install -d ${D}${bindir}
    install -m 0755 version1 ${D}${bindir}/ 
}
