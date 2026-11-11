#!/usr/bin/swift
import CoreGraphics
import Foundation

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data("restore-monitor: \(message)\n".utf8))
    exit(1)
}

let checkOnly = CommandLine.arguments.dropFirst() == ["--check"]
guard CommandLine.arguments.count == 1 || checkOnly else {
    fail("usage: restore-monitor [--check]")
}

var displays = [CGDirectDisplayID](repeating: 0, count: 16)
var count: UInt32 = 0
guard CGGetOnlineDisplayList(16, &displays, &count) == .success else {
    fail("cannot enumerate displays")
}
let external = displays.prefix(Int(count)).filter { CGDisplayIsBuiltin($0) == 0 }
guard external.count == 1, let display = external.first else {
    fail("expected exactly one external display; nothing changed")
}
let options = [kCGDisplayShowDuplicateLowResolutionModes: true] as CFDictionary
guard let modes = CGDisplayCopyAllDisplayModes(display, options) as? [CGDisplayMode],
      let target = modes.first(where: {
          $0.width == 7680 && $0.height == 2160 &&
          $0.pixelWidth == 7680 && $0.pixelHeight == 2160 &&
          abs($0.refreshRate - 60) < 1 && $0.isUsableForDesktopGUI()
      }) else {
    fail("native 7680 × 2160 at 60 Hz is unavailable; nothing changed")
}
if checkOnly {
    print("Native 7680 × 2160 at 60 Hz is available; nothing changed.")
} else {
    var configuration: CGDisplayConfigRef?
    let begin = CGBeginDisplayConfiguration(&configuration)
    guard begin == .success, let configuration else {
        fail("cannot begin display configuration (\(begin.rawValue))")
    }
    let select = CGConfigureDisplayWithDisplayMode(configuration, display, target, nil)
    guard select == .success else {
        CGCancelDisplayConfiguration(configuration)
        fail("mode selection failed (\(select.rawValue))")
    }
    let apply = CGCompleteDisplayConfiguration(configuration, .forSession)
    guard apply == .success else { fail("mode application failed (\(apply.rawValue))") }
    Thread.sleep(forTimeInterval: 2)
    guard let current = CGDisplayCopyDisplayMode(display),
          current.width == 7680 && current.height == 2160 &&
          current.pixelWidth == 7680 && current.pixelHeight == 2160 &&
          abs(current.refreshRate - 60) < 1 else {
        fail("macOS did not retain the requested mode")
    }
    print("Restored 7680 × 2160 at \(current.refreshRate) Hz.")
}
