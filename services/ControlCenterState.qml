pragma Singleton

import Quickshell

Singleton {
    property bool visible: false

    function toggle(): void {
        visible = !visible;
    }

    function hide(): void {
        visible = false;
    }
}
