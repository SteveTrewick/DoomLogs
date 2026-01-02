import os

public enum LogLevel: String, Sendable {
    case debug
    case info
    case notice
    case warning
    case error
    case critical
}

protocol LogSink: Sendable {
    func log(level: LogLevel, message: String)
}

struct OSLogSink: LogSink, Sendable {
    private let logger: os.Logger

    init(subsystem: String, category: String) {
        self.logger = os.Logger(subsystem: subsystem, category: category)
    }

    func log(level: LogLevel, message: String) {
        logger.log(level: osLogType(for: level), "\(message, privacy: .public)")
    }

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
}

public struct DoomLogger: Sendable {
    private let sink: any LogSink

    public init(subsystem: String, category: String) {
        self.sink = OSLogSink(subsystem: subsystem, category: category)
    }

    init(sink: any LogSink) {
        self.sink = sink
    }

    public func log(_ level: LogLevel, _ message: String) {
        sink.log(level: level, message: message)
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
}
