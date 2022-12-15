# screentime

A MacOS status bar item to show today's screen time for roughly tracking work hours.

![docs/screenshot.png](docs/screenshot.png)

This is pretty much just an alternative display to `System Preferencs/Screen Time`.
Uses MacOS "Knowledge" SQLite database to find total app usage and displays in status bar with format of `##h ##m`.
Also, built without using xcode editor and only uses Swift Package Manager (SPM).

## Commands

```sh
# build
swift build

# run
swift run
```

## Run on Startup

```applescript
# screentime.applescript
do shell script "swift run --package-path $PATH_TO_REPO"
```

```sh
# compile AppleScript command to MacOS app
osacompile -o ScreenTime.app screentime.applescript
```

Go to `System Preferences > Users & Groups > Login Items`, then press `+` and add `ScreenTime.app`.

## References

- https://www.swiftbysundell.com/articles/building-a-command-line-tool-using-the-swift-package-manager/
- https://www.mac4n6.com/blog/2018/8/5/knowledge-is-power-using-the-knowledgecdb-database-on-macos-and-ios-to-determine-precise-user-and-application-usage
- https://github.com/stephencelis/SQLite.swift
