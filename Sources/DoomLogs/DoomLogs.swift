#if canImport(os)
import os
#endif
import Foundation

public enum LogLevel: String, Sendable {
    case debug
    case info
    case notice
    case warning
    case error
    case critical
}

public struct DoomLogger: Sendable {
#if canImport(os)
    private let logger: os.Logger
#else
    private let subsystem: String
    private let category: String
#endif

    public init(subsystem: String, category: String) {
#if canImport(os)
        self.logger = os.Logger(subsystem: subsystem, category: category)
#else
        self.subsystem = subsystem
        self.category = category
#endif
    }

    public func log(_ level: LogLevel, _ message: String) {
#if canImport(os)
        logger.log(level: osLogType(for: level), "\(message, privacy: .public)")
#else
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let line = "[\(timestamp)] [\(subsystem):\(category)] \(level.rawValue.uppercased()): \(message)\n"
        FileHandle.standardError.write(Data(line.utf8))
#endif
    }

    public func debug(_ message: String) {
        log(.debug, message)
    }

    public func info(_ message: String) {
        log(.info, message)
    }

    public func notice(_ message: String) {
        log(.notice, message)
    }

    public func warning(_ message: String) {
        log(.warning, message)
    }

    public func error(_ message: String) {
        log(.error, message)
    }

    public func critical(_ message: String) {
        log(.critical, message)
    }

#if canImport(os)
    private func osLogType(for level: LogLevel) -> os.OSLogType {
        switch level {
        case .debug:
            return .debug
        case .info:
            return .info
        case .notice:
            return .default
        case .warning:
            return .error
        case .error:
            return .error
        case .critical:
            return .fault
        }
    }
#endif
}
