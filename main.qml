import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

Window {
    visible: true
    width: 1920
    height: 1080
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
                    ListElement {
                        data: "qrc:/img/cow.png"
                    }
                }
            }
        }

        GridLayout {
            id: grid
            columns: 2
            property int prHeight : 20
            property int prWidth: 500
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
                Layout.preferredWidth: grid.prWidth
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
                Layout.preferredWidth: grid.prWidth
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
                Layout.preferredWidth: grid.prWidth
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
                Layout.preferredWidth: grid.prWidth
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
                Layout.preferredWidth: grid.prWidth
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
                Layout.preferredWidth: grid.prWidth
                Layout.preferredHeight: grid.prHeight
                from: -50
                value: 0
                to: 50
            }
        }

        Label {
            id: descriptionLabel
            anchors {
                left: grid.right
                top: grid.top
                right: parent.right
                leftMargin: 10
            }
            font.pointSize: 16
            text: "Стрелки: Влево, вправо, вверх, вниз.\nКнопки плюс, минус, A, S, Z, X\nРасслабьте глаза и начните\nсмотреть вдаль соединяя мишени.\nДалее используйте клавиши"
        }

        // Algorithm state and timer
        property int algorithmState: 0 // 0 = idle, 1 = wait for user to set comfortable spread, 2 = rotating
        property real algorithmSavedWidth: 0
        property real algorithmSavedUpDown: 0
        property real algorithmCircleRadius: 25 // radius of circular motion in pixels
        property real algorithmMaxBaseline: 50 // clamp baseline separation to +/- this value when starting

        Timer {
            id: algorithmTimer
            interval: 16 // ~60fps
            repeat: true
            running: root.algorithmState === 2
            property real angle: 0
            property real speed: 0.01
            onTriggered: {
                angle += speed

                var baseline = root.algorithmSavedWidth
                var r = root.algorithmCircleRadius
                sliderWidth.value = baseline + Math.cos(angle) * r - r
                sliderUpDown.value = root.algorithmSavedUpDown + Math.sin(angle) * r
            }
        }

        Button {
            id: algorithmStart
            anchors {
                left: grid.right
                top: descriptionLabel.bottom
                right: parent.right
            }
            enabled: root.algorithmState == 0

            text: root.algorithmState === 0 ? "Включить алгоритм" :
                  root.algorithmState === 1 ? "Настройте комфортно и нажмите Пробел" :
                  "Вращение — нажмите Пробел для остановки"

            onClicked: {
                root.focus = true;
                var raw = sliderWidth.value
                root.algorithmSavedWidth = Math.max(-root.algorithmMaxBaseline, Math.min(root.algorithmMaxBaseline, raw))
                root.algorithmSavedUpDown = sliderUpDown.value
                root.algorithmState = 1
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

        Label {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            font.pointSize: 16
            text: "Автор данного приложения не несёт ответственности за ваши действия\nпри использовании данного приложения"
            horizontalAlignment: Qt.AlignHCenter
        }

        Keys.onLeftPressed: sliderWidth.value++
        Keys.onRightPressed: sliderWidth.value--;
        Keys.onUpPressed: sliderUpDown.value--;
        Keys.onDownPressed: sliderUpDown.value++;
        Keys.onPressed: (event)=> {
            // Space handling for algorithm states
            if (event.key === Qt.Key_Space) {
                if (root.algorithmState === 1) {
                    // User confirmed comfortable spread: start spiral rotation from saved max towards center
                    root.algorithmSavedWidth = sliderWidth.value
                    root.algorithmSavedUpDown = sliderUpDown.value

                    // reset timer state and start
                    // algorithmTimer.elapsed = 0
                    algorithmTimer.angle = 0
                    algorithmTimer.running = true
                    root.algorithmState = 2
                    event.accepted = true
                    return
                } else if (root.algorithmState === 2) {
                    // stop rotation and restore saved values
                    algorithmTimer.running = false
                    root.algorithmState = 0
                    sliderWidth.value = root.algorithmSavedWidth
                    sliderUpDown.value = root.algorithmSavedUpDown

                    event.accepted = true
                    return
                }
            }

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
