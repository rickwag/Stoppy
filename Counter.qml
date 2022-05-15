import QtQuick


Rectangle {
    id: root
    width: 30
    height: 90
    color: "transparent"

    //exposed custom properties
    property alias textColor: txt.color
    property alias initialValue: txt.currentValue
    property int minimumValue: 0
    property int maximumValue: 60
    property bool hasColon: false

    state: "off" //start with no option for changing values

    states: [
        State {
            name: "off"

            PropertyChanges {
                target: up
                visible: false
            }
            PropertyChanges {
                target: down
                visible: false
            }
        },

        State {
            name: "on"

            PropertyChanges {
                target: up
                visible: true
            }
            PropertyChanges {
                target: down
                visible: true
            }
        }
    ]

    IconButton {
        id: up

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        iconUrl: "Images/Icons/upIcon.svg"

        //increment text value
        onClicked: txt.currentValue < root.maximumValue - 1 ? txt.currentValue++ : root.minimumValue
    }

    QtObject {
        id: internal

        property string value: {
            if (txt.currentValue < 10)
            {
                if (root.hasColon) ":0" + txt.currentValue
                else "0" + txt.currentValue
            }

            else
            {
                if (root.hasColon) ":" + txt.currentValue
                else txt.currentValue
            }
        }

        property string cl: {
            if (textMouseArea.containsPress)
                "#c320d6"
            else if (textMouseArea.containsMouse)
                Qt.rgba(145, 16, 0, 255)
            else "#ff350a"
        }
    }

    Text {
        id: txt
        text: internal.value
        color: internal.cl

        //custom properties
        property int currentValue: 5

        font.pixelSize: 50
        font.family: "Ubuntu"
        font.styleName: "Italic"

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: up.bottom
        anchors.bottom: down.top
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0

        MouseArea {
            id: textMouseArea
            anchors.fill: parent
            anchors.margins: -10

            hoverEnabled: true

            onClicked: root.state === "off" ? root.state = "on" : root.state = "off"
        }
    }

    IconButton {
        id: down

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0

        iconUrl: "Images/Icons/downIcon.svg"

        //decrement text value
        onClicked: txt.currentValue > root.minimumValue ? txt.currentValue-- : root.maximumValue - 1
    }
}
