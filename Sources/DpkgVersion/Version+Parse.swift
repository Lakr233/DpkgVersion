//
//  Version+Parse.swift
//  AptPackageVersion
//
//  Created by 秋星桥 on 5/16/25.
//

import Foundation

public extension Version {
    /// Parse a version string and check for invalid syntax.
    ///
    /// - Parameter string: The version string to parse.
    /// - Returns: A parsed DpkgVersion if successful, or nil if the parsing failed
    static func parse(from string: String) -> Version? {
        // Trim leading and trailing space.
        var versionString = string.trimmingCharacters(in: .whitespaces)

        if versionString.isEmpty {
            return nil
        }

        // Check for embedded spaces
        if versionString.contains(where: \.isWhitespace) {
            return nil
        }

        // Parse epoch
        var epoch: UInt = 0
        if let colonIndex = versionString.firstIndex(of: ":") {
            let epochString = versionString[..<colonIndex]

            if epochString.isEmpty {
                return nil
            }

            if let epochValue = UInt(epochString) {
                epoch = epochValue

                // Move past the colon for further parsing
                let nextIndex = versionString.index(after: colonIndex)
                if nextIndex == versionString.endIndex {
                    return nil
                }
                versionString = String(versionString[nextIndex...])
            } else {
                return nil
            }
        }

        // Parse version and revision
        var version = versionString
        var revision = ""

        if let hyphenIndex = versionString.lastIndex(of: "-") {
            version = String(versionString[..<hyphenIndex])
            let revisionStartIndex = versionString.index(after: hyphenIndex)

            if revisionStartIndex == versionString.endIndex {
                return nil
            }

            revision = String(versionString[revisionStartIndex...])
        }

        if version.isEmpty { return nil }

        if !version.first!.isNumber { return nil }

        let validVersionChars = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-+~:")
        if version.unicodeScalars.contains(where: { !validVersionChars.contains($0) }) {
            print("[dpkg Inline] |E| invalid character in version number")
            return nil
        }

        let validRevisionChars = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.+~")
        if revision.unicodeScalars.contains(where: { !validRevisionChars.contains($0) }) {
            print("[dpkg Inline] |E| invalid character in revision number")
            return nil
        }

        return Version(epoch: epoch, version: version, revision: revision)
    }
}
