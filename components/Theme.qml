pragma Singleton

import Quickshell
import QtQuick
import "themes"

Singleton {
    property string currentTheme: "catppuccin"

    readonly property QtObject catppuccin: Catppuccin {}
    readonly property QtObject gruvbox: Gruvbox {}
    readonly property QtObject activeTheme: currentTheme === "gruvbox"
        ? gruvbox
        : catppuccin

    readonly property color liquidColor: activeTheme.foregroundColor
    readonly property color windowColor: activeTheme.windowColor
    readonly property color maskColor: activeTheme.maskColor
    readonly property color launcherTextColor: activeTheme.textColor
    readonly property color launcherSecondaryTextColor: activeTheme.secondaryTextColor
    readonly property color launcherItemHoverColor: activeTheme.itemHoverColor
    readonly property color launcherSelectionColor: activeTheme.highlightColor
    readonly property color launcherSearchBackgroundColor: activeTheme.searchBackgroundColor
    readonly property color launcherSearchBorderColor: activeTheme.searchBorderColor
    readonly property color launcherPlaceholderTextColor: activeTheme.placeholderTextColor
    readonly property color wallpaperFallbackColor: activeTheme.wallpaperFallbackColor
}
