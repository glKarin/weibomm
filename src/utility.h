#ifndef UTILITY_H
#define UTILITY_H

#include <QObject>
#include <QVariant>
#include <QUrl>
#include <QSize>

class QDeclarativeEngine;

class idUtility : public QObject
{
    Q_OBJECT
			Q_PROPERTY(int dev READ Dev WRITE SetDev NOTIFY devChanged)
			Q_PROPERTY(QSize screenSize READ ScreenSize FINAL)

public:
    virtual ~idUtility();
    static idUtility * Instance();
    void SetEngine(QDeclarativeEngine *e);
    QDeclarativeEngine * Engine();
		int Dev() const;
		void SetDev(int d);
		QSize ScreenSize() const;
		bool EvaluteScriptv(const QString &src, QObject *scope, QVariant *r = 0);

    Q_INVOKABLE void OpenPlayer(const QString &url, int t = 0) const;
    Q_INVOKABLE void CopyToClipboard(const QString &text) const;
    Q_INVOKABLE void Print_r(const QVariant &v) const;
    Q_INVOKABLE void SetRequestHeaders(const QVariant &v);
    Q_INVOKABLE void SetRequestHeader(const QString &k, const QString &v);
    Q_INVOKABLE QString Sign(const QVariantMap &args, const QString &suffix = QString(), const QVariantMap &sysArgs = QVariantMap()) const;
		Q_INVOKABLE QVariant Get(const QString &name = QString()) const;
		Q_INVOKABLE QVariant Changelog(const QString &version = QString()) const;
		Q_INVOKABLE QString Uncompress(const QString &src, int windowbits = 32 + 15) const;
		Q_INVOKABLE QVariant XML_Parse(const QString &xml) const;
		Q_INVOKABLE QString FormatUrl(const QString &u) const;
		Q_INVOKABLE qint64 System(const QString &path, const QVariant &args = QVariant(), bool async = false) const;
		Q_INVOKABLE QVariant ParseUrl(const QString &url, const QString &part = QString()) const;
		Q_INVOKABLE QVariant GetCookie(const QString &url, const QString &name = QString()) const;
		Q_INVOKABLE QString CacheFile(const QString &b64, const QString &name = QString()) const;
		Q_INVOKABLE QObject * RenderPatchInfo(QObject *parent);
		Q_INVOKABLE QObject * RenderWaterWare(QObject *p, QObject *item = 0);
		Q_INVOKABLE QObject * PlayThemeMusic(QObject *p);
		Q_INVOKABLE QObject * ShowWhatIsPlusPlus(QObject *p);
		Q_INVOKABLE QObject * CreateQmlObject(const QString &src, QObject *parent, const QUrl &url = QUrl(), const QVariantMap &props = QVariantMap());
		Q_INVOKABLE QVariant EvaluteScript(const QString &src, QObject *scope);
		Q_INVOKABLE void CheckUpdate(bool open = false);
    
Q_SIGNALS:
		void devChanged(int dev);

private Q_SLOTS:
	void CheckUpdateResult(const QString &name, int err, const QString &value);

private:
    explicit idUtility(QObject *parent = 0);

private:
    QDeclarativeEngine *oEngine;
		int iDev;

    Q_DISABLE_COPY(idUtility)
    
};
#endif
