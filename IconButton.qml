import QtQuick

Rectangle {
    id: root
    width: 35; height: width
    color: internal.cl
    radius: 8

    //exposed custom properties
    property alias iconWidth: iconImage.width
    property url iconUrl: "images/icons/closeIcon.svg"
    property string hoverColor: Qt.rgba(145, 16, 0, 255)
    property string clickColor: "#ed2fa1"
    signal clicked

    QtObject {
        id: internal

        property string cl: {
            if (mouseArea.containsPress) //on clicked
                clickColor
            else if (mouseArea.containsMouse) //on hover
                hoverColor
            else "transparent" //normal
        }
    }

    Image {
        id: iconImage

        width: 25; height: width

        source: iconUrl
        fillMode: Image.PreserveAspectFit

        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true

        onClicked: root.clicked()
    }
}
