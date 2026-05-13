import Testing
import Foundation
@testable import Domain

@Suite
struct MenuBarPercentageDisplayTests {

    // MARK: - Text Format Without Reset Time

    @Test
    func `text shows only percentage when quota has no reset time`() {
        // Given
        let quota = UsageQuota(percentRemaining: 60, quotaType: .session, providerId: "claude")

        // When
        let display = MenuBarPercentageDisplay(quota: quota, mode: .remaining)

        // Then
        #expect(display.text == "60%")
    }

    // MARK: - Text Format With Reset Time

    @Test
    func `text appends compact reset time when quota has reset time`() {
        // Given - 3 hours, 30 minutes from now
        let resetDate = Date().addingTimeInterval(3 * 3600 + 30 * 60)
        let quota = UsageQuota(
            percentRemaining: 60,
            quotaType: .session,
            providerId: "claude",
            resetsAt: resetDate
        )

        // When
        let display = MenuBarPercentageDisplay(quota: quota, mode: .remaining)

        // Then
        #expect(display.text == "60% · 3h")
    }

    // MARK: - Reset Time Appears In All Display Modes

    @Test
    func `text includes reset time in remaining mode`() {
        // Given - 2h + 30s buffer so Int(timeUntilReset)/3600 stays at 2
        let resetDate = Date().addingTimeInterval(2 * 3600 + 30)
        let quota = UsageQuota(
            percentRemaining: 75,
            quotaType: .session,
            providerId: "claude",
            resetsAt: resetDate
        )

        // When
        let display = MenuBarPercentageDisplay(quota: quota, mode: .remaining)

        // Then
        #expect(display.text == "75% · 2h")
    }

    @Test
    func `text includes reset time in used mode`() {
        // Given - 75% remaining means 25% used; 2h + 30s buffer for Int rounding
        let resetDate = Date().addingTimeInterval(2 * 3600 + 30)
        let quota = UsageQuota(
            percentRemaining: 75,
            quotaType: .session,
            providerId: "claude",
            resetsAt: resetDate
        )

        // When
        let display = MenuBarPercentageDisplay(quota: quota, mode: .used)

        // Then
        #expect(display.text == "25% · 2h")
    }

    @Test
    func `text includes reset time in pace mode`() {
        // Given - pace mode shows percentRemaining; 2h + 30s buffer for Int rounding
        let resetDate = Date().addingTimeInterval(2 * 3600 + 30)
        let quota = UsageQuota(
            percentRemaining: 75,
            quotaType: .session,
            providerId: "claude",
            resetsAt: resetDate
        )

        // When
        let display = MenuBarPercentageDisplay(quota: quota, mode: .pace)

        // Then
        #expect(display.text == "75% · 2h")
    }
}
