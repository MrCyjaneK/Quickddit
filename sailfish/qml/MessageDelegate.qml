/*
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2014  Dickson Leong

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: messageDelegate

    property bool isSentMessage: false

    property alias listItem: mainItem

    signal clicked

    height: mainItem.height

    ListItem {
        id: mainItem
        contentHeight: messageColumn.height + 2 * constant.paddingMedium

        onClicked: messageDelegate.clicked();

        Column {
            id: messageColumn
            anchors {
                left: unreadIndicator.visible ? unreadIndicator.right : parent.left
                right: parent.right
                margins: constant.paddingMedium
                verticalCenter: parent.verticalCenter
            }
            height: childrenRect.height
            spacing: constant.paddingSmall

            Row {
                width: parent.width
                spacing: constant.paddingSmall

                Image {
                    source: isComment ? "image://theme/icon-m-chat" : "image://theme/icon-m-mail"
                    width: 32
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    width: parent.width - 32 - constant.paddingSmall
                    font.pixelSize: constant.fontSizeDefault
                    color: mainItem.highlighted ? Theme.highlightColor : constant.colorLight
                    font.bold: true
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    text: isComment ? model.subject + " from " + model.author
                                    : model.subject
                }
            }

            Text {
                width: parent.width
                font.pixelSize: constant.fontSizeSmaller
                color: Theme.highlightColor
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
                text: isComment ? "in /r/" + model.subreddit + " · " + model.created
                                : (isSentMessage) ? "to " + model.destination
                                                  : (model.author !== "")
                                                    ? "from " + model.author + " · " + model.created
                                                    : "/r/" + model.subreddit + " · " + model.created
            }

            Text {
                width: parent.width
                font.pixelSize: constant.fontSizeSmaller
                color: mainItem.highlighted ? Theme.secondaryHighlightColor : constant.colorMid
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                visible: text.length > 0
                text: model.linkTitle
            }

            Text {
                visible: isComment
                width: parent.width - x
                x: 25
                text: /(<p>(.*?)<\/p>).*/.exec(model.body)[2]
                textFormat: Text.StyledText
                font.pixelSize: constant.fontSizeDefault
                color: mainItem.enabled ? (mainItem.highlighted ? Theme.highlightColor : constant.colorLight)
                                        : constant.colorDisabled
                linkColor: mainItem.enabled ? Theme.highlightColor : constant.colorDisabled
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 3

                Rectangle {
                    x: -25
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 10
                    color: Theme.secondaryHighlightColor
                }
            }

            WideText {
                visible: !isComment
                width: parent.width
                body: model.body
                listItem: mainItem
                onClicked: messageDelegate.clicked()
                Component.onCompleted: if (isComment) { height = 0 }
            }

        }

        Rectangle {
            id: unreadIndicator
            anchors { top: parent.top; bottom: parent.bottom; left: parent.left; margins: constant.paddingMedium }
            width: visible ? constant.paddingMedium : 0
            color: "royalblue"
            visible: model.isUnread
        }
    }
}
