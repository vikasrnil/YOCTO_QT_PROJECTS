#include "Connection.h"

#include <QProcess>
#include <QDebug>
#include <QStringList>
#include <QThread> 

Connection::Connection(QObject *parent)
    : QObject(parent)
{
}

// ------------------------------------------------
// Helper: run nmcli command and return output
// ------------------------------------------------
QString Connection::runNmcli(const QStringList &args)
{
    QProcess process;
    process.start("nmcli", args);
    process.waitForFinished(5000);

    QString output = process.readAllStandardOutput();
    QString error  = process.readAllStandardError();

    if (!error.isEmpty())
        qDebug() << "[nmcli error]" << error.trimmed();

    return output.trimmed();
}

// ------------------------------------------------
// CONNECT TO WIFI
// ------------------------------------------------
void Connection::connectToNetwork(const QString &ssid, const QString &pass)
{
    if (ssid.trimmed().isEmpty()) {
        emit connectionResult("SSID is empty", "");
        return;
    }

    qDebug() << "[WiFi] Connecting to:" << ssid;

    // Turn WiFi on
    runNmcli({"radio", "wifi", "on"});

    // Force rescan
    runNmcli({"device", "wifi", "rescan"});

    // Wait for a moment to ensure the network scan is completed
    QThread::sleep(2);  // Add a delay of 2 seconds to ensure WiFi networks are available

    QStringList args;
    args << "dev" << "wifi" << "connect" << ssid;

    if (!pass.isEmpty()) {
        args << "password" << pass;
    }

    QString output = runNmcli(args);

    // Get the IP address after attempting to connect
    QString ipAddress = currentIp();  // This will return "No IP" if the connection failed

    if (output.contains("successfully")) {
        emit connectionResult("Connected to " + ssid, ipAddress);
    } else {
        emit connectionResult("Failed to connect to " + ssid, "");
    }
}


// ------------------------------------------------
// DISCONNECT FROM CURRENT WIFI
// ------------------------------------------------
void Connection::disconnectFromNetwork()
{
    QString device = currentWifiDevice();
    if (device.isEmpty()) {
        emit connectionResult("No active WiFi device");
        return;
    }

    runNmcli({"device", "disconnect", device});
    emit connectionResult("Disconnected");
}

// ------------------------------------------------
// GET CURRENT WIFI DEVICE NAME
// ------------------------------------------------
QString Connection::currentWifiDevice()
{
    QString output = runNmcli({"-t", "-f", "DEVICE,TYPE,STATE", "device"});

    const QStringList lines = output.split('\n');
    for (const QString &line : lines) {
        QStringList parts = line.split(':');
        if (parts.size() >= 3) {
            if (parts[1] == "wifi" && parts[2] == "connected") {
                return parts[0];
            }
        }
    }
    return QString();
}

// ------------------------------------------------
// GET CURRENT IP ADDRESS
// ------------------------------------------------
QString Connection::currentIp()
{
    QString device = currentWifiDevice();
    if (device.isEmpty()) {
        return "Not Connected";
    }

    // Attempt to get the IP address
    QString output = runNmcli({"-t", "-f", "IP4.ADDRESS", "device", "show", device});
    
    if (output.isEmpty()) {
        qDebug() << "[WiFi] No IP address found for device:" << device;
        return "No IP";  // If no IP address is found, return "No IP"
    }

    // Example output format: "IP4.ADDRESS[1]:192.168.1.20/24"
    QString ip = output.section(':', 1).section('/', 0);
    
    if (ip.isEmpty()) {
        return "No IP";  // In case the IP section is empty
    }
    
    return ip;
}


// ------------------------------------------------
// GET CURRENT SIGNAL STRENGTH
// ------------------------------------------------
QString Connection::currentSignal()
{
    QString output = runNmcli({"-t", "-f", "IN-USE,SIGNAL", "device", "wifi", "list"});

    const QStringList lines = output.split('\n');
    for (const QString &line : lines) {
        if (line.startsWith("*")) {
            QStringList parts = line.split(':');
            if (parts.size() >= 2)
                return parts[1];  // signal strength
        }
    }
    return "0";
}

// ------------------------------------------------
// SCAN AND RETURN WIFI NETWORK LIST
// ------------------------------------------------
QVariantList Connection::wifiList1()
{
    QVariantList networks;

    // Force rescan
    runNmcli({"device", "wifi", "rescan"});

    QString output = runNmcli({
        "-t",
        "-f", "IN-USE,SSID,SIGNAL,SECURITY",
        "device", "wifi", "list"
    });

    const QStringList lines = output.split('\n');
    for (const QString &line : lines) {
        if (line.trimmed().isEmpty())
            continue;

        QStringList parts = line.split(':');
        if (parts.size() < 4)
            continue;

        QVariantMap entry;
        entry["connected"] = (parts[0] == "*");
        entry["ssid"]      = parts[1];
        entry["strength"]  = parts[2].toInt();
        entry["security"]  = parts[3];

        networks.append(entry);
    }

    return networks;
}

QVariantList Connection::wifiList()
{
    QVariantList networks;

    // Force rescan
    runNmcli({"device", "wifi", "rescan"});

    QString output = runNmcli({
        "-t",
        "-f", "IN-USE,SSID,SIGNAL,SECURITY",
        "device", "wifi", "list"
    });

    const QStringList lines = output.split('\n');
    for (const QString &line : lines) {
        if (line.trimmed().isEmpty())
            continue;

        QStringList parts = line.split(':');
        if (parts.size() < 4)
            continue;

        QVariantMap entry;
        entry["connected"] = (parts[0] == "*");
        entry["ssid"]      = parts[1];
        entry["strength"]  = parts[2].toInt();
        entry["security"]  = parts[3];

        // Determine if the network requires a password (WPA, WPA2, WEP, etc.)
        entry["requiresPassword"] = (parts[3].contains("WPA") || parts[3].contains("WEP") || parts[3].contains("WPA2"));

        networks.append(entry);
    }

    return networks;
}


