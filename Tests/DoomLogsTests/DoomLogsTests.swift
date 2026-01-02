import Foundation
import OSLog
import Testing
@testable import DoomLogs

@Test func logsAppearInOSLogStore() async throws {
    let subsystem = "DoomLogsTests.\(UUID().uuidString)"
    let category = "OSLogStore"
    let marker = "log-marker-\(UUID().uuidString)"
    let logger = DoomLogger(subsystem: subsystem, category: category)

    logger.info("hello \(marker)")

    try await Task.sleep(nanoseconds: 200_000_000)

    let store = try OSLogStore(scope: .currentProcessIdentifier)
    let position = store.position(timeIntervalSinceLatestBoot: 0)
    let predicate = NSPredicate(format: "subsystem == %@ AND category == %@", subsystem, category)
    let entries = try store.getEntries(at: position, matching: predicate)

    let messages = entries.compactMap { entry -> String? in
        guard let log = entry as? OSLogEntryLog else { return nil }
        return log.composedMessage
    }

    #expect(messages.contains { $0.contains(marker) })
}
