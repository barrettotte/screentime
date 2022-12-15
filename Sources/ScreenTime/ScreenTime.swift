import ScreenTimeCore

@main
public struct ScreenTime {

    public static func main() {
        do {
            try ScreenTimeRunner().run()
        } catch {
            print("Error occurred: \(error)")
        }
    }
}
