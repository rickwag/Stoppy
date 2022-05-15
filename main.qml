import QtQuick
import QtQuick.Window
import QtQuick.Controls 2.15
import QtMultimedia

Window {
    id: root
    width: 400; height: 400
    visible: true
    color: "transparent"

    //remove default title bar
    flags: Qt.Window | Qt.FramelessWindowHint

    property url bgImageUrl: "images/bgImage.png"

    Rectangle {
        id: bgRect
        color: "#1d1d1d"
        radius: 10

        anchors.fill: parent

        Image {
            id: bgImage
            source: bgImageUrl
            fillMode: Image.PreserveAspectCrop

            anchors.fill: parent
        }

        Rectangle {

            id: titleBar
            height: 24
            color: "transparent"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 20

            Rectangle {
                id: infoBtn

                width: 35
                radius: 8
                color: "transparent"
                border.color: "#ed2fa1"
                border.width: 2

                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -5
                anchors.top: parent.top
                anchors.topMargin: -5

                IconButton {
                    iconUrl: "Images/Icons/infoIcon.svg"

                    anchors.centerIn: parent

                    onClicked: centerDisplay.state = "about"
                }
            }

            Row {
                spacing: 8
                layoutDirection: "RightToLeft"
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 10

                IconButton {
                    id: closeBtn

                    onClicked: root.close()
                }

                IconButton {
                    id: minimizeBtn
                    iconUrl: "Images/Icons/minimizeIcon.svg"

                    onClicked: root.showMinimized()
                }
            }

            DragHandler {
                onActiveChanged: if (active) startSystemMove()
            }
        }

        Rectangle {
            id: centerDisplay

            width: 250; height: width
            radius: width/2
            border.width: 2
            border.color: "#ed2fa1"
            color: "transparent"

            anchors.centerIn: parent
            anchors.verticalCenterOffset: -20

            state: "clock"

            states: [
                State {
                    name: "clock"
                    PropertyChanges {
                        target: clockDisplay
                        visible: true
                    }

                    PropertyChanges {
                        target: alarmDisplay
                        visible: false
                    }

                    PropertyChanges {
                        target: aboutDisplay
                        visible: false
                    }
                },

                State {
                    name: "alarm"
                    PropertyChanges {
                        target: clockDisplay
                        visible: false
                    }

                    PropertyChanges {
                        target: alarmDisplay
                        visible: true
                    }

                    PropertyChanges {
                        target: aboutDisplay
                        visible: false
                    }
                },

                State {
                    name: "about"
                    PropertyChanges {
                        target: clockDisplay
                        visible: false
                    }

                    PropertyChanges {
                        target: alarmDisplay
                        visible: false
                    }

                    PropertyChanges {
                        target: aboutDisplay
                        visible: true
                    }
                }
            ]

            Item {
                id: clockDisplay

                anchors.fill: parent

                state: "showTimer"

                states: [
                    State {
                        name: "showTimer"
                        PropertyChanges {
                            target: timerLabel
                            visible: true
                        }
                        PropertyChanges {
                            target: timerModifier
                            visible: false
                        }
                    },

                    State {
                        name: "showTimerModifier"
                        PropertyChanges {
                            target: timerLabel
                            visible: false
                        }
                        PropertyChanges {
                            target: timerModifier
                            visible: true
                        }
                    }
                ]

                Label {
                    id: timerLabel
                    text: qsTr("00:02:00")

                    color: "#ff350a"
                    font.pixelSize: 50
                    font.family: "Roboto"
                    font.styleName: "bold"

                    anchors.centerIn: parent;
                }

                Rectangle {
                    id: timerModifier
                    color: "transparent"

                    height: 50

                    anchors.right: parent.right
                    anchors.rightMargin: 45
                    anchors.left: parent.left
                    anchors.leftMargin: 45
                    anchors.verticalCenter: parent.verticalCenter

                    Counter {
                        id: hrs
                        initialValue: 0
                        maximumValue: 24

                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: -30
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -30
                    }

                    Counter {
                        id: mins
                        initialValue: 0
                        hasColon: true
                        height: 90 + 25

                        anchors.centerIn: parent
                    }

                    Counter {
                        id: secs
                        initialValue: 0
                        hasColon: true

                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: -30
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -30
                    }
                }

                Item {
                    id: timerState
                    width: 35; height: width

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20

                    state: "inTimer"

                    states: [
                        State {
                            name: "inTimer"
                            PropertyChanges {
                                target: modifyDone
                                visible: false
                            }
                            PropertyChanges {
                                target: modify
                                visible: true
                            }
                            PropertyChanges {
                                target: clockDisplay
                                state: "showTimer"
                            }
                        },

                        State {
                            name: "inTimerModifier"
                            PropertyChanges {
                                target: modifyDone
                                visible: true
                            }
                            PropertyChanges {
                                target: modify
                                visible: false
                            }
                            PropertyChanges {
                                target: clockDisplay
                                state: "showTimerModifier"
                            }
                        }
                    ]

                    IconButton {
                        id: modifyDone
                        iconUrl: "Images/Icons/thumbsUpIcon.svg"

                        anchors.fill: parent

                        onClicked: {
                            timerState.state = "inTimer"

                            //on modify done set total seconds in backend
                            //calculate total secs
                            let hours = hrs.initialValue
                            let minutes = mins.initialValue
                            let seconds = secs.initialValue

                            let total_seconds = (hours * 3600) + (minutes * 60) + seconds

                            backend.set_total_seconds(total_seconds)
                        }
                    }

                    IconButton {
                        id: modify
                        iconUrl: "Images/Icons/thumbsDownIcon.svg"

                        anchors.fill: parent

                        onClicked: {
                            timerState.state = "inTimerModifier"

                            backend.get_initial_time_values()
                            backend.stop_timer()
                        }
                    }
                }
            }

            Item {
                id: alarmDisplay
                anchors.fill: parent

                IconButton {
                    id: stopAlarm
                    iconUrl: "Images/Icons/stopIcon.svg"

                    iconWidth: 20

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 15

                    onClicked: {
                        centerDisplay.state = "clock"
                        soundPlayer.stop()
                    }
                }

                Image {
                    id: bell
                    source: "Images/bell.png"
                    fillMode: Image.PreserveAspectFit

                    anchors.centerIn: parent

                }
            }

            Item {
                id: aboutDisplay

                anchors.fill: parent

                IconButton {
                    id: aboutDisplayClose

                    iconWidth: 20

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 15

                    onClicked: centerDisplay.state = "clock"
                }

                Text {
                    text: qsTr("Stoppy")
                    color: "#ed2fa1"

                    font.family: "Roboto"
                    font.styleName: "Bold"
                    font.pixelSize: 20

                    anchors.bottom: centerTxt.bottom
                    anchors.bottomMargin: 40
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                }

                Text {
                    id: centerTxt
                    text: qsTr("Developed by")
                    color: "#ff350a"

                    font.family: "Roboto"
                    font.pixelSize: 20

                    anchors.centerIn: parent
                }

                Text {
                    text: qsTr("Patwag")
                    color: "#c320d6"

                    font.family: "Roboto"
                    font.pixelSize: 20
                    font.styleName: "Bold Italic"

                    anchors.top: centerTxt.bottom
                    anchors.topMargin: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                }
            }

            //alarm sound player
            SoundEffect {
                id: soundPlayer
                source: "alarmSound.wav"
                loops: SoundEffect.Infinite
            }
        }

        Rectangle {
            id: bottomBar
            width: 300; height: 50
            radius: 8

            color: "transparent"
            border.width: 2
            border.color: "#ed2fa1"

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20

            IconButton {
                id: refreshBtn
                iconUrl: "Images/Icons/refreshIcon.svg"

                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                onClicked: backend.reset_timer()
            }

            IconButton {
                id: playBtn
                iconUrl: "Images/Icons/playIcon.svg"

                anchors.centerIn: parent

                onClicked: backend.start_timer()
            }

            IconButton {
                id: stopBtn
                iconUrl: "Images/Icons/stopIcon.svg"

                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                onClicked: backend.stop_timer()
            }
        }
    }

    Connections {
        target: backend

        //signal handlers
        function onSetTime(time) {
            timerLabel.text = time
        }

        function onSetInitialTimeValues(times) {
            hrs.initialValue = times[0]
            mins.initialValue = times[1]
            secs.initialValue = times[2]
        }

        function onTimeOut()
        {
            centerDisplay.state = "alarm"
            soundPlayer.play()
        }
    }
}
