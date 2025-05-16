//
//  Version.swift
//  Sail
//
//  Created by Lakr Aream on 2020/2/22.
//  Copyright © 2020 Lakr Aream. All rights reserved.
//

import Foundation

/// Data structure representing a dpkg version.
public struct Version {
    /// The epoch. It will be zero if no epoch is present.
    public var epoch: UInt

    /// The upstream part of the version.
    public var version: String

    /// The Debian revision part of the version.
    public var revision: String

    /// Creates a DpkgVersion object with the given components
    ///
    /// - Parameters:
    ///   - epoch: The epoch number
    ///   - version: The version string
    ///   - revision: The revision string
    public init(epoch: UInt, version: String, revision: String) {
        self.epoch = epoch
        self.version = version
        self.revision = revision
    }
}

public extension Version {
    /// Checks if a version string is valid according to Debian package version rules
    ///
    /// - Parameter version: The version string to validate
    /// - Returns: True if the version string is valid, false otherwise
    static func isValid(_ version: String) -> Bool {
        Version.parse(from: version) != nil
    }

    /// Compares two version strings according to Debian package version comparison rules
    ///
    /// - Parameters:
    ///   - a: First version string
    ///   - b: Second version string
    /// - Returns:
    ///   - 0: If a and b are equal.
    ///   - < 0: If a is smaller than b.
    ///   - > 0: If a is greater than b.
    static func compare(_ lhs: String, _ rhs: String) -> Int {
        guard let versionA = Version.parse(from: lhs),
              let versionB = Version.parse(from: rhs)
        else {
            print("[Error] compareVersionA&B contain invalid version string")
            return 0
        }

        return Version.compare(versionA, versionB)
    }
}
