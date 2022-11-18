// simplest menubar screen time
// run: swift ScreenTime.swift
import AppKit

class App : NSObject, NSApplicationDelegate {
    let app = NSApplication.shared
    let status = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var timer = Timer()
    var counter = 0
    
    let window = NSWindow.init(
        contentRect: NSMakeRect(0, 0, 200, 200),
        styleMask: [.titled, .closable, .miniaturizable],
        backing: .buffered,
        defer: false
    )

    override init() {
        super.init()
        app.setActivationPolicy(.accessory)

        let statusMenu = newMenu()
        status.button?.title = "..."
        status.menu = statusMenu

        let appMenu = newMenu()
        let sub = NSMenuItem()
        sub.submenu = appMenu
        app.mainMenu = NSMenu()
        app.mainMenu?.addItem(sub)

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        print("App initialized.")
    }

    // Timer action needs to be exposed to Objective-C
    @objc func timerAction() {
        counter += 1
        print("\(counter) second(s)")
        // status.button?.title = "\(counter)"
    }

    func applicationDidFinishLaunching(_ n: Notification) {
        print("App launched.")
    }

    private func newMenu(title: String = "Menu") -> NSMenu {
        let menu = NSMenu(title: title)
        menu.addItem(NSMenuItem.init(title: "Exit", action: #selector(app.terminate(_:)), keyEquivalent: "q"))
        // TODO: open System Preferences/Screen Time
        return menu
    }
}

// run application
let delegate = App()
let app = NSApplication.shared
app.delegate = delegate
app.run()
