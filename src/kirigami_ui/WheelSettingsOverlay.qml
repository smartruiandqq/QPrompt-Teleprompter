/****************************************************************************
 **
 ** QPrompt
 ** Copyright (C) 2022-2025 Javier O. Cordero Pérez
 **
 ** This file is part of QPrompt.
 **
 ** This program is free software: you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation, version 3 of the License.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **
 ****************************************************************************/

import QtQuick 2.12
import org.kde.kirigami 2.11 as Kirigami
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import com.cuperino.qprompt 1.0

Kirigami.OverlaySheet {
    id: wheelSettings

    header: Kirigami.Heading {
        text: qsTr("Prompter settings")
        level: 1
    }

    onOpened: {
        cursorAutoHide.reset();
        root.pageStack.currentItem.editor.enabled = false;
        if (root.pageStack.currentItem.prompter) {
            pageScrollLinesSpinBox.value = root.pageStack.currentItem.prompter.pageScrollLines;
            atEndActionComboBox.currentIndex = root.pageStack.currentItem.prompter.atEndAction;
            atEndLoopDelaySpinBox.value = root.pageStack.currentItem.prompter.atEndLoopDelay;
        }
    }
    onClosed: {
        cursorAutoHide.restart();
        root.pageStack.currentItem.editor.enabled = true;
        root.pageStack.currentItem.prompter.restoreFocus();
    }

    ColumnLayout {
        RowLayout {
            Label {
                text: qsTr("Use scroll as velocity dial", "Label at wheel settings overlay")
            }
            Button {
                id: useScrollAsDialButton
                text: checked ? qsTr("On") : qsTr("Off")
                checkable: true
                checked: root.__scrollAsDial
                onClicked: root.__scrollAsDial = !root.__scrollAsDial
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing
                Material.theme: Material.Dark
            }
        }
        GridLayout {
            width: parent.width
            columns: 2
            ColumnLayout {
                Label {
                    text: qsTr("Enable throttling")
                }
                Button {
                    id: enableThrottleButton
                    text: checked ? qsTr("On") : qsTr("Off")
                    checkable: true
                    checked: root.__throttleWheel
                    onClicked: root.__throttleWheel = !root.__throttleWheel
                    Layout.fillWidth: true
                    Layout.leftMargin: Kirigami.Units.smallSpacing
                    Layout.rightMargin: Kirigami.Units.smallSpacing
                    Material.theme: Material.Dark
                }
            }
            ColumnLayout {
                enabled: root.__throttleWheel
                Label {
                    text: qsTr("Throttle factor");
                }
                SpinBox {
                    value: root.__wheelThrottleFactor
                    from: 1
                    onValueModified: {
                        focus: true
                        root.__wheelThrottleFactor = value
                    }
                    Layout.fillWidth: true
                    Layout.leftMargin: Kirigami.Units.smallSpacing
                    Layout.rightMargin: Kirigami.Units.smallSpacing
                    Material.theme: Material.Dark
                }
            }
        }
        RowLayout {
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Enable throttling for use with touchpads, disable for precise scolling.")
                color: "#EED"
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing
            }
        }
        RowLayout {
            Label {
                text: qsTr("Lines per page turn")
            }
            SpinBox {
                id: pageScrollLinesSpinBox
                value: root.pageStack.currentItem.prompter.pageScrollLines
                from: 0
                to: 100
                editable: true
                onValueModified: {
                    focus: true
                    root.pageStack.currentItem.prompter.pageScrollLines = value
                }
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing
                Material.theme: Material.Dark
            }
        }
        RowLayout {
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Set lines per page turn to 0 to use one full page (minus one line).")
                color: "#EED"
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing
            }
        }
        RowLayout {
            Label {
                text: qsTr("At end of prompt")
            }
            ComboBox {
                id: atEndActionComboBox
                model: [qsTr("Stop"), qsTr("Return to edit mode"), qsTr("Loop")]
                currentIndex: root.pageStack.currentItem.prompter.atEndAction
                onActivated: root.pageStack.currentItem.prompter.atEndAction = index
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing
                Material.theme: Material.Dark
            }
        }
        RowLayout {
            enabled: root.pageStack.currentItem.prompter.atEndAction === Prompter.AtEndActions.Loop
            Label {
                text: qsTr("Loop delay (seconds)")
            }
            SpinBox {
                id: atEndLoopDelaySpinBox
                value: root.pageStack.currentItem.prompter.atEndLoopDelay
                from: 1
                to: 60
                editable: true
                onValueModified: {
                    focus: true
                    root.pageStack.currentItem.prompter.atEndLoopDelay = value
                }
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing
                Material.theme: Material.Dark
            }
        }
    }
}
