import AppKit

public final class ScreenTimeRunner {
    
    public init() {
        // nop
    }

    public func run() throws {
        let delegate = ScreenTimeApp()
        let app = NSApplication.shared
        app.delegate = delegate
        app.run()
    }
}
