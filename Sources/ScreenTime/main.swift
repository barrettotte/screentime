import ScreenTimeCore

@main
public struct ScreenTime {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(ScreenTime().text)

        // TODO: restore
        // let runner = ScreenTimeRunner()
        // do {
        //     try runner.run()
        // } catch {
        //     print("Whoops! An error occurred: \(error)")
        // }
    }
}
