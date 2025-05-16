//
//  Version+Compare.swift
//  AptPackageVersion
//
//  Created by 秋星桥 on 5/16/25.
//

import Foundation

public extension Version {
    /// Compares two Debian versions.
    ///
    /// - Parameters:
    ///   - a: The first version.
    ///   - b: The second version.
    /// - Returns:
    ///   - 0: If a and b are equal.
    ///   - <0: If a is smaller than b.
    ///   - >0: If a is greater than b.
    static func compare(_ a: Version, _ b: Version) -> Int {
        // Compare epoch
        if a.epoch > b.epoch { return 1 }
        if a.epoch < b.epoch { return -1 }

        // Compare version
        let versionResult = Version.verrevcmp(a.version, b.version)
        if versionResult != 0 { return versionResult }

        // Compare revision
        return Version.verrevcmp(a.revision, b.revision)
    }

    /// Give a weight to the character to order in the version comparison.
    private static func order(_ c: Character) -> Int {
        if c.isNumber {
            0
        } else if c.isLetter {
            Int(c.asciiValue ?? 0)
        } else if c == "~" {
            -1
        } else if !c.isASCII {
            0
        } else {
            Int(c.asciiValue ?? 0) + 256
        }
    }

    /// Compare two version or revision strings
    private static func verrevcmp(_ a: String, _ b: String) -> Int {
        var aStr = a
        var bStr = b

        while !aStr.isEmpty || !bStr.isEmpty {
            var firstDiff = 0

            // Handle the part of the string which are not numbers
            while (!aStr.isEmpty && !aStr.first!.isNumber) || (!bStr.isEmpty && !bStr.first!.isNumber) {
                let ac = !aStr.isEmpty ? order(aStr.first!) : 0
                let bc = !bStr.isEmpty ? order(bStr.first!) : 0

                if ac != bc {
                    return ac - bc
                }

                if !aStr.isEmpty { aStr.removeFirst() }
                if !bStr.isEmpty { bStr.removeFirst() }
            }

            // Skip leading zeros
            while !aStr.isEmpty, aStr.first == "0" { aStr.removeFirst() }
            while !bStr.isEmpty, bStr.first == "0" { bStr.removeFirst() }

            // Compare digit sequences
            while !aStr.isEmpty, aStr.first!.isNumber, !bStr.isEmpty, bStr.first!.isNumber {
                if firstDiff == 0 {
                    let aDigit = Int(String(aStr.first!))!
                    let bDigit = Int(String(bStr.first!))!
                    firstDiff = aDigit - bDigit
                }

                aStr.removeFirst()
                bStr.removeFirst()
            }

            if !aStr.isEmpty, aStr.first!.isNumber { return 1 }
            if !bStr.isEmpty, bStr.first!.isNumber { return -1 }

            if firstDiff != 0 { return firstDiff }
        }

        return 0
    }
}
