import XCTest
@testable import OpenUsage

/// Verifies telemetry and crash autocapture remain completely inert in this fork.
final class TelemetrySinkTests: XCTestCase {
    func testTelemetryAndCrashAutocaptureAreDisabled() {
        XCTAssertFalse(TelemetryConfig.isConfigured)
        XCTAssertEqual(TelemetryConfig.token, TelemetryConfig.placeholderToken)
        XCTAssertFalse(PostHogTelemetrySink.errorAutocaptureEnabled(optionalAnalyticsEnabled: true))
        XCTAssertFalse(PostHogTelemetrySink.errorAutocaptureEnabled(optionalAnalyticsEnabled: false))
    }
}
