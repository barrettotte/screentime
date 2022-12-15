import AppKit
import Foundation
import SQLite

class ScreenTimeApp : NSObject, NSApplicationDelegate {

    private let app = NSApplication.shared
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var timer = Timer()
    private let knowledgeSql = """
      with app_usage as (
        select datetime(ZOBJECT.ZCREATIONDATE + 978307200, 'UNIXEPOCH', 'LOCALTIME') as entry_creation, 
          (ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE) as usage
        from ZOBJECT
        where ZSTREAMNAME is "/app/usage"
      )
      select time(sum(usage), 'unixepoch') as total_usage
      from app_usage
      where date(entry_creation) = date('now');
    """
    private var knowledgeDbPath = ""

    override init() {
        super.init()
        app.setActivationPolicy(.accessory) // No dock, no menubar

        // set knowledge database path
        if let user = ProcessInfo.processInfo.environment["USER"] {
            self.knowledgeDbPath = "/System/Volumes/Data/Users/\(user)/Library/Application Support/Knowledge/knowledgeC.db"
        } else {
            print("Failed to find user from environment. Unable to start app.")
            return
        }

        // setup status bar
        let statusMenu = buildMenu()
        statusItem.button?.title = "..."
        statusItem.menu = statusMenu

        // setup app menu
        let appMenu = buildMenu()
        let sub = NSMenuItem()
        sub.submenu = appMenu
        app.mainMenu = NSMenu()
        app.mainMenu?.addItem(sub)

        // setup and start timer
        timer = Timer.scheduledTimer(
            timeInterval: (60.0 * 2.5), // seconds
            target: self,
            selector: #selector(timerAction),
            userInfo: nil,
            repeats: true
        )
        timer.fire()
        print("ScreenTimeApp initialized.")
    }

    internal func applicationDidFinishLaunching(_ n: Notification) {
        print("ScreenTimeApp launched.")
    }

    // Timer action needs to be exposed to Objective-C
    @objc
    private func timerAction() throws {
        do {
            let uptime = formatTime(s: try queryScreenTime())
            print("Uptime => \(uptime)")
            statusItem.button?.title = "\(uptime)"
        } catch {
            throw error
        }
    }

    @objc
    private func openSysPrefAction() {
        NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/ScreenTime.prefPane"))
    }

    private func buildMenu(title: String = "Menu") -> NSMenu {
        let menu = NSMenu(title: title)
        menu.addItem(
            NSMenuItem.init(
                title: "System Preferences",
                action: #selector(self.openSysPrefAction),
                keyEquivalent: "o"
            )
        )
        menu.addItem(
            NSMenuItem.init(
                title: "Force Refresh",
                action: #selector(self.timerAction),
                keyEquivalent: "r"
            )
        )
        menu.addItem(
            NSMenuItem.init(
                title: "Quit",
                action: #selector(app.terminate(_:)),
                keyEquivalent: "q"
            )
        )
        return menu
    }

    private func queryScreenTime() throws -> String {
        do {
            let db = try Connection(knowledgeDbPath, readonly: true)
            return try db.scalar(knowledgeSql) as! String
        } catch {
            throw error
        }
    }

    private func formatTime(s: String) -> String {
        let t = s.split(separator: ":")
        return "\(t[0])h \(t[1])m"
    }
}
