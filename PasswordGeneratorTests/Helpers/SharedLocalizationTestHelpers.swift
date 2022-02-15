//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import XCTest

private typealias LocalizedBundle = (bundle: Bundle, localization: String)

private func allLocalizationBundles(in bundle: Bundle, file: StaticString = #filePath, line: UInt = #line) -> [LocalizedBundle] {
    bundle.localizations.compactMap { localization in
        guard
            let path = bundle.path(forResource: localization, ofType: "lproj"),
            let localizedBundle = Bundle(path: path)
        else {
            XCTFail("Couldn't find bundle for localization: \(localization)", file: file, line: line)
            return nil
        }

        return (localizedBundle, localization)
    }
}

private func allLocalizedStringKeys(
    in bundles: [LocalizedBundle],
    table: String,
    file: StaticString = #filePath,
    line: UInt = #line
) -> Set<String> {
    bundles.reduce([]) { acc, current in
        guard
            let path = current.bundle.path(forResource: table, ofType: "strings"),
            let strings = NSDictionary(contentsOfFile: path),
            let keys = strings.allKeys as? [String]
        else {
            XCTFail("Couldn't load localized strings for localization: \(current.localization)", file: file, line: line)
            return acc
        }

        return acc.union(Set(keys))
    }
}

func assertLocalizedKeysAndValuesExists(in presentationBundle: Bundle, _ table: String, file: StaticString = #file, line: UInt = #line) {
    let localizationBundles = allLocalizationBundles(in: presentationBundle, file: file, line: line)
    let localizedStringKeys = allLocalizedStringKeys(in: localizationBundles, table: table, file: file, line: line)

    localizationBundles.filter { $0.localization != "fr" }.forEach { bundle, localization in
        localizedStringKeys.forEach { key in
            let localizedString = bundle.localizedString(forKey: key, value: nil, table: table)

            if localizedString == key {
                let language = Locale.current.localizedString(forLanguageCode: localization) ?? ""

                XCTFail(
                    "Missing \(language) (\(localization)) localized string for key: '\(key)' in table: '\(table)'",
                    file: file,
                    line: line
                )
            }
        }
    }
}
