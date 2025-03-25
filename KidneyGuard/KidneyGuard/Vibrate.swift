import UIKit
import CoreHaptics

class Vibrate {
    private static var engine: CHHapticEngine?
    private static var continuousPlayer: CHHapticAdvancedPatternPlayer?
    private static let pulseDuration: TimeInterval = 0.3  // Longer pulse (was 0.1s)
    private static let pulseInterval: TimeInterval = 0.5  // Longer cycle (was 0.2s)

    static func startVibration() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Device does not support haptics")
            return
        }

        do {
            engine = try CHHapticEngine()
            try engine?.start()

            // Stronger, repeating pulse pattern
            var events: [CHHapticEvent] = []
            let totalDuration: TimeInterval = 10.0  // Extended duration (adjustable)
            var time: TimeInterval = 0

            while time < totalDuration {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)  // Max intensity
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)  // Sharper for stronger feel
                let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness],
                                        relativeTime: time, duration: pulseDuration)
                events.append(event)
                time += pulseInterval  // Pulse every 0.5s
            }

            let pattern = try CHHapticPattern(events: events, parameters: [])
            continuousPlayer = try engine?.makeAdvancedPlayer(with: pattern)
            continuousPlayer?.loopEnabled = true  // Loop until stopped
            try continuousPlayer?.start(atTime: CHHapticTimeImmediate)

            // Keep engine alive
            engine?.notifyWhenPlayersFinished { _ in return .leaveEngineRunning }
        } catch {
            print("Haptic engine error: \(error)")
        }
    }

    static func stopVibration() {
        do {
            try continuousPlayer?.stop(atTime: CHHapticTimeImmediate)
            continuousPlayer = nil
            engine?.stop(completionHandler: nil)
            engine = nil
        } catch {
            print("Failed to stop haptics: \(error)")
        }
    }
}
