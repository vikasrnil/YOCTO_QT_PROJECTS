#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtCore/QCoreApplication>

int main(int argc, char *argv[])
{
    // MUST be set before QGuiApplication
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

