import QtQuick 2.6
import Sailfish.Silica 1.0
import QtMultimedia 5.6

import org.tal 1.0

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
                console.debug("CameraOrientation: "+orientation)
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

    BarcodeScanner {
        id: scanner
        // enabledFormats: BarcodeScanner.BarCodeFormat_2D | BarcodeScanner.BarCodeFormat_1D
        enabledFormats: BarcodeScanner.BarCodeFormat_1D
        rotate: camera.orientation!=0 ? true : false;
        onTagFound: {
            console.debug("TAG: "+tag);
            barcodeText.text=tag;
        }
        onDecodingStarted: {
            console.debug("DECs")

        }
        onDecodingFinished: {
            console.debug("DECe")
            if (succeeded)
                camera.stop();
        }
        onUnknownFrameFormat: {
            console.debug("Unknown video frame format: "+format)
            console.debug(width + " x "+height)
            // scanFatalFailure("Fatal: Unknown video frame format: "+format)
            camera.stop();
        }
        Component.onCompleted: {
            console.debug("Filter created")
        }
    }

    SilicaFlickable {
        anchors.fill: parent

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
                height: page.height/1.5
                onOrientationChanged: console.debug("VideoOutputOrientation: "+orientation)

                filters: [ scanner ]

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

            Text {
                id: barcodeText
                width: parent.width
                color: "red"
                font.pointSize: 22
                horizontalAlignment: Text.AlignHCenter
            }

        }
    }
}

