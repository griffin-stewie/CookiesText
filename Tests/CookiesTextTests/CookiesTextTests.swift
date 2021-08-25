import XCTest
@testable import CookiesText

final class CookiesTextTests: XCTestCase {
    var cookiesTxtURL: URL {
        Bundle.module.url(forResource: "cookies", withExtension: "txt")!
    }

    func testLoad() {
        do {
            let cookies = try CookiesText.cookies(of: cookiesTxtURL)
            XCTAssertEqual(cookies[0].name, "xp_aostkn")
        } catch {
            XCTFail("\(error.localizedDescription)")
        }
    }
}
