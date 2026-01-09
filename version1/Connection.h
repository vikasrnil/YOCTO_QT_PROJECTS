#ifndef CONNECTION_H
#define CONNECTION_H

#include <QObject>
#include <QVariantList>
#include <QStringList>

class Connection : public QObject
{
    Q_OBJECT

public:
    explicit Connection(QObject *parent = nullptr);

    // Called from QML
    Q_INVOKABLE void connectToNetwork(const QString &ssid, const QString &pass);
    Q_INVOKABLE void disconnectFromNetwork();
    Q_INVOKABLE QVariantList wifiList1();   // SSID + strength + security + connected
    Q_INVOKABLE QVariantList wifiList(); 
    Q_INVOKABLE QString currentIp();
    Q_INVOKABLE QString currentSignal();

signals:
    // Used by QML (onConnectionResult)
    void connectionResult(const QString &message);
    void connectionResult(const QString &message, const QString &ipAddress);


private:
    // nmcli helpers
    QString runNmcli(const QStringList &args);
    QString currentWifiDevice();
};

#endif // CONNECTION_H

