//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import PasswordGenerator
import XCTest

final class AppLocalizationTests: XCTestCase {
    func test_allLanguages_areLocalized() {
        let table = "Localizable"
        assertLocalizedKeysAndValuesExists(in: Bundle.main, table)
    }
}
