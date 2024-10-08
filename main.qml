import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

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

        GridLayout {
            id: grid
            columns: 2
            property int prHeight : 20
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            columnSpacing: 5

            Label {
                text: qsTr("Раздвинуть")
                font.pointSize: 20
            }

            Slider {
                id: sliderWidth
                Layout.preferredWidth: 800
                Layout.preferredHeight: grid.prHeight
                from: -100
                value: 1
                to: 500
            }

            Label {
                text: qsTr("Размер")
                font.pointSize: 20
            }

            Slider {
                id: sliderSize
                Layout.preferredWidth: 800
                Layout.preferredHeight: grid.prHeight
                from: 1
                value: 100
                to: 200
            }

            Label {
                text: qsTr("Сплюснуть")
                font.pointSize: 20
            }

            Slider {
                id: sliderWidthElement
                Layout.preferredWidth: 800
                Layout.preferredHeight: grid.prHeight
                from: 0
                value: 1
                to: 1
            }

            Label {
                text: qsTr("Вверх/вниз")
                font.pointSize: 20
            }

            Slider {
                id: sliderUpDown
                Layout.preferredWidth: 800
                Layout.preferredHeight: grid.prHeight
                from: -200
                value: 0
                to: 200
            }

            Label {
                text: qsTr("Корр-я по x правой")
                font.pointSize: 20
            }

            Slider {
                id: sliderCorrecionRightElement
                Layout.preferredWidth: 800
                Layout.preferredHeight: grid.prHeight
                from: -50
                value: 0
                to: 50
            }
            Label {
                text: qsTr("Корр-я по x левой")
                font.pointSize: 20
            }

            Slider {
                id: sliderCorrecionLeftElement
                Layout.preferredWidth: 800
                Layout.preferredHeight: grid.prHeight
                from: -50
                value: 0
                to: 50
            }
        }

        Label {
            anchors {
                left: grid.right
                top: grid.top
                leftMargin: 10
            }
            font.pointSize: 20
            text: "Стрелки: Влево, вправо, вверх, вниз.\nКнопки плюс, минус, A, S, Z, X\nРасслабьте глаза и начните\nсмотреть вдаль соединяя мишени.\nДалее используйте клавиши"
        }

        Image {
            id: target1
            x: {
                let calculatedX = - 50 - sliderWidth.value - sliderCorrecionLeftElement.value;
                if (calculatedX >= 0)
                    return root.width / 2;
                return  root.width / 2 + calculatedX
            }
            y: root.height / 3 + sliderUpDown.value
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
            y: root.height / 3 + sliderUpDown.value
            width: sliderSize.value * sliderWidthElement.value
            height: sliderSize.value
            source: "qrc:/img/target.png"
        }

        Keys.onLeftPressed: sliderWidth.value++
        Keys.onRightPressed: sliderWidth.value--;
        Keys.onUpPressed: sliderUpDown.value--;
        Keys.onDownPressed: sliderUpDown.value++;
        Keys.onPressed: (event)=> {
            if (event.key === Qt.Key_A) {
                sliderCorrecionLeftElement.value--;
                event.accepted = true;
            }
            else if (event.key === Qt.Key_S)
            {
                sliderCorrecionLeftElement.value++;
                event.accepted = true;
            }
            else if (event.key === Qt.Key_Z)
            {
                sliderCorrecionRightElement.value--;
                event.accepted = true;
            }
            else if (event.key === Qt.Key_X)
            {
                sliderCorrecionRightElement.value++;
                event.accepted = true;
            } else if (event.key === Qt.Key_Plus) {
                sliderSize.value++
            } else if (event.key === Qt.Key_Minus) {
                sliderSize.value--
            }
        }
    }
}
