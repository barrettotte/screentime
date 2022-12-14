import AppKit

class ScreenTimeApp : NSObject, NSApplicationDelegate {
    let app = NSApplication.shared
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var timer = Timer()
    var counter = 0

    override init() {
        super.init()
        app.setActivationPolicy(.accessory) // No dock, no menubar

        let statusMenu = newMenu()
        statusItem.button?.title = "..."
        statusItem.menu = statusMenu

        let appMenu = newMenu()
        let sub = NSMenuItem()
        sub.submenu = appMenu
        app.mainMenu = NSMenu()
        app.mainMenu?.addItem(sub)

        timer = Timer.scheduledTimer(
            timeInterval: 1.0, 
            target: self, 
            selector: #selector(timerAction), 
            userInfo: nil, 
            repeats: true)

        print("App initialized.")
    }

    // Timer action needs to be exposed to Objective-C
    @objc func timerAction() {
        counter += 1
        print("\(counter) second(s)")
        // statusItem.button?.title = "\(counter)"
    }

    func applicationDidFinishLaunching(_ n: Notification) {
        print("App launched.")
    }

    private func newMenu(title: String = "Menu") -> NSMenu {
        let menu = NSMenu(title: title)

        menu.addItem(NSMenuItem.init(
            title: "Exit", 
            action: #selector(app.terminate(_:)), 
            keyEquivalent: "q"))

        // TODO: open System Preferences/Screen Time

        return menu
    }
}
