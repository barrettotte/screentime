import ScreenTimeCore

@main
public struct ScreenTime {

    public static func main() {
        let runner = ScreenTimeRunner()

        do {
            try runner.run()
        } catch {
            print("Error occurred: \(error)")
        }
    }
}
