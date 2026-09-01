pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    property alias model: notifications
    readonly property int count: notifications.count

    function iconSource(notification) {
        const source = notification.image || notification.appIcon;
        if (!source)
            return "";
        if (source.startsWith("/") )
            return "file://" + source;
        if (source.includes(":"))
            return source;
        return Quickshell.iconPath(source);
    }

    function removeById(id) {
        for (let index = 0; index < notifications.count; index++) {
            if (notifications.get(index).notificationId === id) {
                notifications.remove(index);
                return;
            }
        }
    }

    function dismiss(index) {
        if (index < 0 || index >= notifications.count)
            return;
        const notification = notifications.get(index).notification;
        notifications.remove(index);
        if (notification)
            notification.dismiss();
    }

    function clear() {
        const tracked = [];
        for (let index = 0; index < notifications.count; index++)
            tracked.push(notifications.get(index).notification);
        notifications.clear();
        for (const notification of tracked) {
            if (notification)
                notification.dismiss();
        }
    }

    ListModel { id: notifications }

    NotificationServer {
        id: server

        bodySupported: true
        bodyMarkupSupported: false
        imageSupported: true
        actionsSupported: true
        persistenceSupported: true
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true;
            root.removeById(notification.id);
            notifications.insert(0, {
                notification: notification,
                notificationId: notification.id,
                appName: notification.appName || "Notification",
                summary: notification.summary || "Notification",
                body: notification.body || "",
                icon: root.iconSource(notification),
                receivedAt: new Date()
            });
        }
    }
}
