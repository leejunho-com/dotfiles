import Cocoa

// Passive CGEventTap — listenOnly mode does not consume events,
// so skhd and other tools receive option key events normally.
// Only shows sketchybar when it is currently hidden (peek behavior).
let sketchybarPath = "/run/current-system/sw/bin/sketchybar"

func runSketchybar(_ args: String...) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: sketchybarPath)
    task.arguments = Array(args)
    try? task.run()
}

func isBarHidden() -> Bool {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: sketchybarPath)
    task.arguments = ["--query", "bar"]
    let pipe = Pipe()
    task.standardOutput = pipe
    try? task.run()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
       let hidden = json["hidden"] as? String {
        return hidden == "on"
    }
    return false
}

class Peeking {
    var optionPressed = false
    var didShow = false

    func start() {
        let mask = CGEventMask(1 << CGEventType.flagsChanged.rawValue)

        let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: mask,
            callback: { _, _, event, userInfo -> Unmanaged<CGEvent>? in
                let p = Unmanaged<Peeking>.fromOpaque(userInfo!).takeUnretainedValue()
                p.handleEvent(event)
                return nil
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )

        guard let tap = tap else {
            fputs("Failed to create event tap. Grant Accessibility permission.\n", stderr)
            exit(1)
        }

        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
        CFRunLoopRun()
    }

    func handleEvent(_ event: CGEvent) {
        // keyCode 58 = left_option, 61 = right_option
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        guard keyCode == 58 || keyCode == 61 else { return }

        let isPressed = event.flags.contains(.maskAlternate)

        if isPressed && !optionPressed {
            if isBarHidden() {
                didShow = true
                runSketchybar("--bar", "hidden=off")
            }
        } else if !isPressed && optionPressed {
            if didShow {
                didShow = false
                runSketchybar("--bar", "hidden=on")
            }
        }
        optionPressed = isPressed
    }
}

let peeking = Peeking()
peeking.start()
