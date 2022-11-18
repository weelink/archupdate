import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.plasmoid 2.0

RowLayout {
  id: row

  property int margin: 2
  property string iconUpdate: "../assets/software-update-available.svg"
  property string iconRefresh: "../assets/arch-unknown.svg"
  property string total: "0"

  anchors.fill: parent // the row fill the parent in height and width
  anchors.topMargin: margin // margin give a better look for the icon in the panel
  anchors.bottomMargin: margin

  // updates the icon according to the refresh status
  function updateUi(refresh: boolean) {
    refresh ? icon.source=iconRefresh : icon.source=iconUpdate
  }

  // event handler for MouseArea
  function onClick() {
    updateUi(true)
    updater.count()
  }

  // map the stdout with the widget
  Connections {
    target: cmd
    function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
      total = stdout.replace(/\n/g, '')
      console.log("get", total)
      updateUi(false)
    }
  }

  Image {
    id: icon
    height: row.height
    width: height
    Layout.fillWidth: true
    fillMode: Image.PreserveAspectFit
    sourceSize: Qt.size(height, height) // w/ the sourceSize set to the height the svg have alway the right definition
    source: iconUpdate

    MouseArea {
      anchors.fill: icon // cover all the zone
      cursorShape: Qt.PointingHandCursor // give user feedback
      onClicked: { onClick() }
    }

    // background for the text
    Rectangle {
      id: circle
      width: icon.width / 3
      height: width
      radius: width / 2
      color: "Black"
      opacity: 1
      anchors.right: parent.right
      anchors.bottom: parent.bottom

      // total of update
      Text {
        text: total
        font.pointSize: 8
        color: "White"
        anchors.centerIn: circle
      }
    }
  }

}
