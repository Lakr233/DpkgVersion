# DpkgVersion

Swift implementation of robust dpkg semi-semantic version management.

## Features

- Parse Debian package version strings (epoch:version-revision format)
- Validate version strings according to Debian policy
- Compare version strings using the same algorithm as `dpkg`
- Written in pure Swift with no dependencies

## Usage

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Lakr233/DpkgVersion.git", from: "1.0.0")
]
```

Then import the library in your Swift file:

```swift
import DpkgVersion
```

### Comparing Version Strings

```swift
import DpkgVersion

#expect(Version.compare("1.0.0", "1.0.0+1") < 0)
#expect(Version.compare("1.0.0+2", "1.0.0+1") > 0)
#expect(Version.compare("1.0.0+", "1.0.0+") == 0)
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Copyright © 2025 Lakr Aream, All rights reserved.
