#ifndef GPSREADER_H
#define GPSREADER_H

#include <QObject>
#include <QSerialPort>

class GpsReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ isConnected NOTIFY connectionChanged)
    Q_PROPERTY(QString rmcString READ rmcString NOTIFY rmcUpdated)

public:
    explicit GpsReader(QObject *parent = nullptr);

    bool isConnected() const { return m_connected; }
    QString rmcString() const { return m_rmcString; }

signals:
    void connectionChanged();
    void rmcUpdated();

private slots:
    void handleReadyRead();

private:
    QSerialPort m_serial;
    bool m_connected = false;
    QString m_rmcString;
    QByteArray m_buffer;
};

#endif // GPSREADER_H

