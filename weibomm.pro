# Add more folders to ship with the application, here
folder_01.source = qml/SinaWeiboClient
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE58A237F

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components


QT += declarative network sql webkit xml
CONFIG += mobility
MOBILITY += multimedia systeminfo location
INCLUDEPATH += . src src/qtm
DEFINES += _KARIN_MM_EXTENSIONS
MOC_DIR = .moc
OBJECTS_DIR = .obj
#DEFINES += _DBG
RESOURCES += weibomm.qrc
TARGET = weibo++
TARGET_PKG=weibomm

contains(DEFINES, _KARIN_MM_EXTENSIONS) {
HEADERS += \
src/qtm/qdeclarativemediabase_p.h \
src/qtm/qdeclarativevideo_p.h \
src/qtm/qdeclarativemediametadata_p.h \
src/qtm/qpaintervideosurface_p.h

SOURCES += \
src/qtm/qdeclarativemediabase.cpp \
src/qtm/qdeclarativevideo.cpp \
src/qtm/qpaintervideosurface.cpp
}

contains(MEEGO_EDITION,harmattan){
PKGCONFIG += zlib
QT += dbus
DEFINES += _HARMATTAN
DEFINES += _MAEMO_MEEGOTOUCH_INTERFACES_DEV
CONFIG += videosuiteinterface-maemo-meegotouch meegotouch
#DEFINES += _VHAS_LIBQJSON_DEV

eventtype.files = misc/weibomm.conf
eventtype.path = /usr/share/meegotouch/notifications/eventtypes
INSTALLS += eventtype
LIBS += -lcrypto
}

simulator {
DEFINES += _SIMULATOR
INCLUDEPATH += libs/include
LIBS += D:\q_proj\m\weibo++\libs\lib\zdll.lib
}

symbian {
}

!contains(DEFINES, _VHAS_LIBQJSON_DEV) {
include(qjson/qjson.pro)
DEFINES += _LOCAL_QJSON_DEV
INCLUDEPATH += $${QJSON_BASEDIR}
} else {
LIBS += -lqjson
}

theme_music.files = misc/theme_music.mp3
theme_music.path = /opt/$${TARGET_PKG}/misc/
INSTALLS += theme_music

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    src/utility.cpp \
    src/networkmanager.cpp \
    src/networkconnector.cpp \
                src/id_std.cpp \
                src/pipeline.cpp \
                src/qt_funcview.cpp \
                src/settingmodel.cpp \
                src/newmsgnotification.cpp \
                src/accountmodel.cpp \
                src/commenttomemodel.cpp \
                src/atmemodel.cpp \
                src/crypt.cpp \
                src/loginmodel.cpp \
                src/messagecentermodel.cpp \
                src/firstpagemodel.cpp \
                src/searchblogmodel.cpp \
                src/searchusermodel.cpp \
                src/searchcontactmodel.cpp \
                src/searchtopicmodel.cpp \
                src/suibiankanmodel.cpp \
                src/favoritesmodel.cpp \
                src/fanlistmodel.cpp \
                src/friendlistmodel.cpp \
                src/trendtopicmodel.cpp \
                src/myweibolistmodel.cpp \
                src/qmlmodel_base.cpp \
                src/pagedqmlmodel_base.cpp \
                src/acclistmodel_base.cpp \
                src/updateprofilemodel.cpp \
                src/emotionlist.cpp \
                src/database.cpp \
                src/profile.cpp \
                src/microblog.cpp \
                src/inserttopicmodel.cpp \
                src/hottrendmodel.cpp \
                src/trendblogmodel.cpp \
                src/contentcommentmodel.cpp \
                src/weiboprofilemodel.cpp \
                src/detailmodel.cpp \
                src/deletemodel.cpp \
                src/selectqmlmodel_base.cpp \
                src/frequentcontactmodel.cpp \
                src/api.cpp \
                src/helper.cpp \
    src/qtm/qdeclarativewebview.cpp

HEADERS += \
    src/utility.h \
    src/networkmanager.h \
    src/networkconnector.h \
    src/id_std.h \
                src/pipeline.h \
                src/qt_funcview.h \
                src/settingmodel.h \
                src/newmsgnotification.h \
                src/accountmodel.h \
                src/commenttomemodel.h \
                src/atmemodel.h \
                src/crypt.h \
                src/loginmodel.h \
                src/messagecentermodel.h \
                src/firstpagemodel.h \
                src/searchblogmodel.h \
                src/searchusermodel.h \
                src/searchcontactmodel.h \
                src/searchtopicmodel.h \
                src/suibiankanmodel.h \
                src/favoritesmodel.h \
                src/fanlistmodel.h \
                src/friendlistmodel.h \
                src/trendtopicmodel.h \
                src/myweibolistmodel.h \
                src/qmlmodel_base.h \
                src/pagedqmlmodel_base.h \
                src/acclistmodel_base.h \
                src/updateprofilemodel.h \
                src/emotionlist.h \
                src/database.h \
                src/profile.h \
                src/microblog.h \
                src/inserttopicmodel.h \
                src/hottrendmodel.h \
                src/trendblogmodel.h \
                src/contentcommentmodel.h \
                src/weiboprofilemodel.h \
                src/detailmodel.h \
                src/deletemodel.h \
                src/selectqmlmodel_base.h \
                src/frequentcontactmodel.h \
                src/api.h \
                src/api_defines.h \
                src/helper.h \
    src/qtm/qdeclarativewebview.h


# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog
