import Foundation
import Testing
@testable import DoomLogs

@Test func logsToInjectedSink() async {
    let sink = TestLogSink()
    let logger = DoomLogger(sink: sink)

    logger.info("hello")
    logger.error("boom")

    let entries = sink.entries()
    #expect(entries.count == 2)
    #expect(entries[0].level == .info)
    #expect(entries[0].message == "hello")
    #expect(entries[1].level == .error)
    #expect(entries[1].message == "boom")
}

private final class TestLogSink: LogSink, @unchecked Sendable {
    private let lock = NSLock()
    private var stored: [(level: LogLevel, message: String)] = []

    func log(level: LogLevel, message: String) {
        lock.lock()
        stored.append((level: level, message: message))
        lock.unlock()
    }

    func entries() -> [(level: LogLevel, message: String)] {
        lock.lock()
        let snapshot = stored
        lock.unlock()
        return snapshot
    }
}
