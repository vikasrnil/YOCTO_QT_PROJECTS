TARGET = canwifigps
TEMPLATE = app

QT += quick core gui network serialport
CONFIG += c++17 release

SOURCES += main.cpp \
           canhandler.cpp \
           wifihandler.cpp \
           gpsreader.cpp

HEADERS += canhandler.h \
	   wifihandler.h \
	   gpsreader.h
	   

RESOURCES += qml.qrc
