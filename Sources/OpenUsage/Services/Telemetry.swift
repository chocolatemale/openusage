import Foundation

/// Build-time configuration for telemetry. Disabled in this fork so neither analytics nor crash
/// autocapture ever initializes or sends network traffic.
enum TelemetryConfig {
    /// Sentinel meaning "no real token configured" — the sink stays inert (no setup, no network) while
    /// the resolved token equals this. Do NOT change this value.
    static let placeholderToken = "phc_REPLACE_ME"

    static var token: String { placeholderToken }

    static var isConfigured: Bool { false }

    static let host = "https://us.i.posthog.com"
}

/// The transport seam telemetry is emitted through. Abstracted so the recorder's daily-rollup/dedup
/// logic can be unit-tested against a fake sink.
@MainActor
protocol TelemetrySink: AnyObject {
    func capture(_ event: String, _ properties: [String: Any])
    /// Mirror the optional-analytics preference without disabling daily activity or crash reporting.
    func setOptionalAnalyticsEnabled(_ enabled: Bool)
    func flush()
}

/// Inert telemetry sink: both usage analytics and crash autocapture are permanently disabled.
@MainActor
final class PostHogTelemetrySink: TelemetrySink {
    nonisolated static func errorAutocaptureEnabled(optionalAnalyticsEnabled _: Bool) -> Bool { false }

    init(enabled _: Bool, token _: String = TelemetryConfig.token, host _: String = TelemetryConfig.host) {
        AppLog.info(.config, "telemetry disabled")
    }

    func capture(_: String, _: [String: Any]) {}

    func setOptionalAnalyticsEnabled(_: Bool) {}

    func flush() {}
}
