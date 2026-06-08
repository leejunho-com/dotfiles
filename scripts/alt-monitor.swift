import Cocoa

// Passive CGEventTap — listenOnly mode does not consume events,
// so skhd and other tools receive option key events normally.
let sketchybarPath = "/run/current-system/sw/bin/sketchybar"

func runSketchybar(_ args: String...) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: sketchybarPath)
    task.arguments = Array(args)
    try? task.run()
}

class AltMonitor {
    var optionPressed = false

    func start() {
        let mask = CGEventMask(1 << CGEventType.flagsChanged.rawValue)

        let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: mask,
            callback: { _, _, event, userInfo -> Unmanaged<CGEvent>? in
                let monitor = Unmanaged<AltMonitor>.fromOpaque(userInfo!).takeUnretainedValue()
                monitor.handleEvent(event)
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
            runSketchybar("--bar", "hidden=off")
        } else if !isPressed && optionPressed {
            runSketchybar("--bar", "hidden=on")
        }
        optionPressed = isPressed
    }
}

let monitor = AltMonitor()
monitor.start()
