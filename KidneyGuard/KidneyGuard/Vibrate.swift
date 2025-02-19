import UIKit
import CoreHaptics

class Vibrate {
    private static var engine: CHHapticEngine?
    private static var continuousPlayer: CHHapticAdvancedPatternPlayer?
    
    static func startVibration() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Device does not support haptics")
            return
        }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            // Use .hapticContinuous instead of .continuous.
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 10.0)
            
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            continuousPlayer = try engine?.makeAdvancedPlayer(with: pattern)
            try continuousPlayer?.start(atTime: CHHapticTimeImmediate)
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
