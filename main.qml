import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4


Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Расслабон для глаз")
    Component.onCompleted: showMaximized()
    Rectangle {
        id: root
        anchors.fill: parent
        color: "#FFB140"
        focus: true
        Rectangle {
            id: targerListView
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                leftMargin: 10
            }
            width: 150
            color: "#A66200"
            ListView {
                id: examplesView
                anchors.fill: parent
                spacing: 10
                delegate: Item {
                    width: examplesView.width
                    height: examplesView.width

                    MouseArea {
                        anchors.fill: imageData
                        onClicked: {
                            target1.source = model.data
                            target2.source = model.data
                        }
                    }

                    Image {
                        id: imageData
                        source: model.data
                        anchors.fill: parent
                    }
                }
                model: ListModel {
                    ListElement {
                        data: "qrc:/img/target.png"
                    }
                    ListElement {
                        data: "qrc:/img/minus.png"
                    }
                    ListElement {
                        data: "qrc:/img/plus.png"
                    }
                    ListElement {
                        data: "qrc:/img/square.png"
                    }
                    ListElement {
                        data: "qrc:/img/circle.png"
                    }
                }

            }
        }
        Item {
            anchors {
                left: targerListView.right
                top: parent.top
                right: parent.right
                rightMargin: 10
            }

            Label {
                text: qsTr("Раздвинуть")
                anchors.right: sliderWidth.left
                anchors.verticalCenter: sliderWidth.verticalCenter
                font.pointSize: 20
            }

            Slider {
                id: sliderWidth
                anchors {
                    top: parent.top
                    right: parent.right
                }
                width: 800
                from: -100
                value: 1
                to: 500
            }

            Label {
                text: qsTr("Размер")
                anchors.right: sliderSize.left
                anchors.verticalCenter: sliderSize.verticalCenter
                font.pointSize: 20
            }

            Slider {
                id: sliderSize
                anchors {
                    top: sliderWidth.bottom
                    right: parent.right
                }
                width: 800
                from: 1
                value: 100
                to: 200
            }

            Label {
                text: qsTr("Сплюснуть")
                anchors.right: sliderWidthElement.left
                anchors.verticalCenter: sliderWidthElement.verticalCenter
                font.pointSize: 20
            }

            Slider {
                id: sliderWidthElement
                anchors {
                    top: sliderSize.bottom
                    right: parent.right
                }
                width: 800
                from: 0
                value: 1
                to: 1
            }

            Label {
                text: qsTr("Корр-я по x правой")
                anchors.right: sliderCorrecionRightElement.left
                anchors.verticalCenter: sliderCorrecionRightElement.verticalCenter
                font.pointSize: 20
            }

            Slider {
                id: sliderCorrecionRightElement
                anchors {
                    top: sliderWidthElement.bottom
                    right: parent.right
                }
                width: 800
                from: -50
                value: 0
                to: 50
            }
            Label {
                text: qsTr("Корр-я по x левой")
                anchors.right: sliderCorrecionLeftElement.left
                anchors.verticalCenter: sliderCorrecionLeftElement.verticalCenter
                font.pointSize: 20
            }

            Slider {
                id: sliderCorrecionLeftElement
                anchors {
                    top: sliderCorrecionRightElement.bottom
                    right: parent.right
                }
                width: 800
                from: -50
                value: 0
                to: 50
            }
        }
        Image {
            id: target1
            x: {
                let calculatedX = - 50 - sliderWidth.value - sliderCorrecionLeftElement.value;
                if (calculatedX >= 0)
                    return root.width / 2;
                return  root.width / 2 + calculatedX
            }
            y: root.height / 3
            width: sliderSize.value * sliderWidthElement.value
            height: sliderSize.value
            source: "qrc:/img/target.png"
        }

        Image {
            id: target2
            x: {
                let calculatedX = 50 + sliderWidth.value + sliderCorrecionRightElement.value
                if (calculatedX <= 0)
                    return root.width / 2;

                return root.width / 2  + calculatedX;
            }
            y: root.height / 3
            width: sliderSize.value * sliderWidthElement.value
            height: sliderSize.value
            source: "qrc:/img/target.png"
        }
        Keys.onUpPressed: {
            sliderWidth.value = sliderWidth.value + 1;
        }

        Keys.onDownPressed: {
            sliderWidth.value = sliderWidth.value - 1;
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_A) {
                sliderCorrecionLeftElement.value = sliderCorrecionLeftElement.value - 1;
                event.accepted = true;
            }
            else if (event.key === Qt.Key_S)
            {
                sliderCorrecionLeftElement.value = sliderCorrecionLeftElement.value + 1;
                event.accepted = true;
            }
            else if (event.key === Qt.Key_Z)
            {
                sliderCorrecionRightElement.value = sliderCorrecionRightElement.value - 1;
                event.accepted = true;
            }
            else if (event.key === Qt.Key_X)
            {
                sliderCorrecionRightElement.value = sliderCorrecionRightElement.value + 1;
                event.accepted = true;
            }
        }
    }

}
