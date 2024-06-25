# OneRepMax
One Rep Max and Charts Demo App

Given a set of historical workout data, this app shows a list of workouts and presents a plot of their historical data on a separate screen. The plot processes the data into 1RM (One Rep Max) per each date in the set.

GitHub project: [OneRepMax](https://github.com/ideastouch/OneRepMax)

## Build tools & versions used
To build this demo, only Xcode is required. This demo includes three of my own Swift Package Manager (SPM) dependencies:
- NetworkKit
    - GitHub: [NetworkKit](https://github.com/iDT-Swift/NetworkKit)
    - DocC: [NetworkKit Documentation](https://networkkit.ideastouch.com/documentation/networkkit/)
- SwiftExt
    - GitHub: [SwiftExt](https://github.com/iDT-Swift/SwiftExt)
    - DocC: [SwiftExt Documentation](https://networkkit.ideastouch.com/documentation/swiftext)
- SwiftUIExt
    - GitHub: [SwiftUIExt](https://github.com/iDT-Swift/SwiftUIExt)

## Steps to run the app
1. For peace of mind, `Clean All Issues`, `Clean Build Folder...`, and `Update to Latest Package Versions`.
2. Build and run the app.
3. The main screen includes three ways to update the displayed data:
    - **Clear**: Clears all the data in the database.
    - **GDrive**: Provides an option to download a `csv` file from Google Drive by providing the file ID.
        - GDrive also includes a default Google File ID in case you don't have one.
    - **Open**: Offers an option to open a local file, either in the cloud or the device's download folder.
    - If an error occurs during the database update, an Alert View will present the error.
4. At the bottom of the main screen, there is a toolbar with options to filter, sort, and search workouts by exercise name and/or favorites.
5. In the center of the main screen, you can see the exercise cells. Each cell shows the exercise name, its 1 Rep Max, and a star icon to mark it as a favorite.
    - Each cell is clickable and presents the same info along with the historical data for that specific workout on a new screen.
6. The workout historical screen also offers an option to adjust the Y-axis domain to better visualize the One Rep Max on the graph.

## Focus areas on this app
- Stability, maintenance, and performance.
- Architecture MVVM with one source of truth, a SwiftData Data Base.
- Preview of all the SwiftUI View in use.
- Present a screen that shows the One Rep Max historical values over time.
- Present a screen with the list of workouts in the database, plus an option to show the historical data screen.
- Offer several ways to filter the list of workouts.
- Offer several ways to upload new `CSV` files.
    - File processing happens in the background to avoid UI freezing for large files.
- Clean code with small modules: ViewModel, View, and Model.
    - Model includes DataModel, Extensions, and Network modules.
- Use URLSessionManager with caching to avoid downloading the same file twice, implemented via my SPM NetworkKit.
- Use SwiftData to store objects obtained from the CSV file downloaded from Google Drive or uploaded.
- Implement a clean way to load the ModelContainer without risking app unresponsiveness in case of failure. Check `OneRepMaxApp.body.WindowGroup.Group.task`.
- Support portrait and landscape orientations.
- Support Dark Mode.

## Future improvements and features
- Add a hover feature on the One Rep Max historical screen.
- Add an option to reduce the X-axis domain.
- Add an option to zoom and pan the graph when the X-axis domain is smaller than the data range.
- Add options to add/update data; currently, it only replaces existing data.
- Polish UI colors in Dark Mode.
- Add test cases for network calls, `CSV` file processing, and other extensions in this demo.

## Weakest parts of this app
- Lacks test cases

## Third-party code/libraries
All mine are mentioned already in the `Build tools & versions used` section. Here they are again:
- NetworkKit: [GitHub](https://github.com/iDT-Swift/NetworkKit)
- SwiftExt: [GitHub](https://github.com/iDT-Swift/SwiftExt)
- SwiftUIExt: [GitHub](https://github.com/iDT-Swift/SwiftUIExt)
