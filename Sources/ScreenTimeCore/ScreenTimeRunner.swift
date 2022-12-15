import AppKit

public final class ScreenTimeRunner {
    
    public init() {
        // nop
    }

    // Init and run ScreenTime application
    public func run() throws {
        let delegate = ScreenTimeApp()
        let app = NSApplication.shared
        app.delegate = delegate
        app.run()
    }
}
