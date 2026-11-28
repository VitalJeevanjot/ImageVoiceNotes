import XCTest

final class PicMikLocalizationTests: XCTestCase {
    @MainActor
    func testSearchUsesTheSelectedAppLanguage() {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(es)", "-AppleLocale", "es_ES"]
        app.launch()

        XCTAssertTrue(app.textFields["Buscar"].waitForExistence(timeout: 5))
    }
}
