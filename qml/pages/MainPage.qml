import QtQuick 2.6
import Sailfish.Silica 1.0
import QtMultimedia 5.5

Page {
    id: page

    allowedOrientations: Orientation.Portrait

    Camera {
        id: camera
        captureMode: Camera.CaptureViewfinder
        focus {
            focusMode: Camera.FocusManual // Camera.FocusContinuous
        }

        onOrientationChanged: console.debug("CameraOrientation: "+orientation)
        onErrorStringChanged: console.debug("CameraError: "+errorString)
        onCameraStateChanged: {
            console.debug("State: "+cameraState)
            switch (cameraState) {
            case Camera.ActiveState:
                console.debug("DigitalZoom: "+maximumDigitalZoom)
                console.debug("OpticalZoom: "+maximumOpticalZoom)
                break;
            }
        }

        onLockStatusChanged: console.debug("LS"+lockStatus)

        imageCapture {
            onImageCaptured: {
                console.debug(camera.imageCapture.capturedImagePath)
            }
            onCaptureFailed: {
                console.debug("Capture failed")
            }
            onImageSaved: {
                console.debug("Image saved: "+path)
            }
        }

    }

    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
            }
            MenuItem {
                text: "Start"
                onClicked: {
                    camera.start()
                }
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("BCScanner")
            }

            VideoOutput {
                id: videoOutput
                source: camera
                autoOrientation: false // true
                fillMode: Image.PreserveAspectFit
                width: parent.width
                height: page.height/2
                onOrientationChanged: console.debug("Orientation: "+orientation)
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        camera.imageCapture.capture();
                    }
                    onPressAndHold: {
                        camera.searchAndLock()
                    }
                }

                BusyIndicator {
                    anchors.centerIn: parent
                    visible: running
                    running: camera.lockStatus==Camera.Searching
                }
            }
        }
    }
}

