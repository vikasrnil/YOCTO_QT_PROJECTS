#include "gpsreader.h"
#include <QDebug>

GpsReader::GpsReader(QObject *parent) : QObject(parent)
{
    m_serial.setPortName("/dev/ttyUSB0");   // adjust for your Pi
    m_serial.setBaudRate(QSerialPort::Baud9600);
    m_serial.setDataBits(QSerialPort::Data8);
    m_serial.setParity(QSerialPort::NoParity);
    m_serial.setStopBits(QSerialPort::OneStop);
    m_serial.setFlowControl(QSerialPort::NoFlowControl);
    
    if (m_serial.open(QIODevice::ReadOnly)) {
    qDebug() << "GPS connected!";
    m_connected = true;
    emit connectionChanged();
    connect(&m_serial, &QSerialPort::readyRead, this, &GpsReader::handleReadyRead);
} else {
    qWarning() << "GPS serial not connected! Error:" << m_serial.errorString();
    m_connected = false;
    emit connectionChanged();
}

    
    
}

void GpsReader::handleReadyRead()
{
    m_buffer.append(m_serial.readAll());

    QList<QByteArray> lines = m_buffer.split('\n');
    if (lines.size() > 1) {
        for (const QByteArray &line : lines) {
            if (line.startsWith("$GPRMC")) {
                m_rmcString = QString::fromLatin1(line).trimmed();
                emit rmcUpdated();
                break;
            }
        }
        m_buffer.clear();
    }
}

