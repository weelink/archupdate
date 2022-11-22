import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.workspace.components 2.0 as WorkspaceComponents

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
    if (refresh) {
      icon.source=iconRefresh
      total="↻"
    } else {
      icon.source=iconUpdate
    }
  }

  // event handler for MouseArea
  function onClick() {
    updater.count()
  }

  // map the cmd signal with the widget
  Connections {
    target: cmd
    function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
      total = stdout.replace(/\n/g, '')
      updateUi(false)
    }
    function onConnected(source) {
      updateUi(true)
    }
  }

  Image {
    id: icon
    height: row.height
    width: height
    Layout.fillWidth: true
    fillMode: Image.PreserveAspectFit
    // w/ the sourceSize set to the height the svg have alway the right definition
    sourceSize: Qt.size(height, height)
    source: iconUpdate

    MouseArea {
      anchors.fill: icon // cover all the zone
      cursorShape: Qt.PointingHandCursor // give user feedback
      onClicked: onClick()
    }

    WorkspaceComponents.BadgeOverlay {
      anchors {
        bottom: parent.bottom
        right: parent.right
      }
      visible: true
      text: total
      icon: icon
    }

  }

}
