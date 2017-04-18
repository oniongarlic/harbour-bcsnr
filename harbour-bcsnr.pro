# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-bcsnr

CONFIG += sailfishapp

QT += multimedia

SOURCES += src/harbour-bcsnr.cpp

OTHER_FILES += qml/harbour-bcsnr.qml \
    qml/cover/CoverPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-bcsnr.changes.in \
    rpm/harbour-bcsnr.spec \
    rpm/harbour-bcsnr.yaml \
    translations/*.ts \
    harbour-bcsnr.desktop

include(3rdparty/barcodevideofilter/barcodevideofilter.pri)

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-bcsnr-de.ts

DISTFILES += \
    qml/pages/MainPage.qml
