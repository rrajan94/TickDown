import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory) // No dock icon

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.action = #selector(togglePopover)
            button.target = self
        }

        setupPopover()
        startTimer()
        updateDisplay()
    }

    func setupPopover() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 320, height: 420)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PopoverView())
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateDisplay()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    func updateDisplay() {
        let mode = UserDefaults.standard.string(forKey: "displayMode") ?? "seconds_day"
        let label = TimeCalculator.menuBarLabel(for: mode)
        DispatchQueue.main.async {
            if let button = self.statusItem.button {
                let attr = NSAttributedString(
                    string: label,
                    attributes: [
                        .foregroundColor: NSColor(red: 0, green: 0.898, blue: 1.0, alpha: 1.0),
                        .font: NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
                    ]
                )
                button.attributedTitle = attr
            }
        }
    }

    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                // Refresh the popover view each time
                popover.contentViewController = NSHostingController(rootView: PopoverView())
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
}
