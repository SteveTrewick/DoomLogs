# DoomLogs

![Swift](https://img.shields.io/badge/Swift-6.0-orange)
![Platforms](https://img.shields.io/badge/Platforms-macOS%2011%2B-lightgrey)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)

Minimal logging wrapper with a simple, instance-based API.

## Usage

```swift
import DoomLogs

let logger = DoomLogger(subsystem: "DoombergRSS", category: "RSSIngester")
logger.info("Starting up")
```
