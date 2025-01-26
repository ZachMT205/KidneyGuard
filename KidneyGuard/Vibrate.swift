import UIKit

// Class to manage vibration toggle
class Vibrate {
    static var isVibrating = false

    // Start vibrating repeatedly with a small delay between triggers
    static func startVibration() {
        // Check if the device is capable of haptic feedback
        if !isHapticAvailable() {
            print("Device does not support haptic feedback.")
            return
        }

        isVibrating = true
        DispatchQueue.global().async {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare() // Prepare for better performance

            while isVibrating {
                DispatchQueue.main.async {
                    generator.impactOccurred() // Trigger vibration
                }
                Thread.sleep(forTimeInterval: 0.01) // Short delay to prevent rate limit
            }
        }
    }

    // Stop vibration
    static func stopVibrating() {
        isVibrating = false
    }

    // Check if haptic feedback is available (iOS 10.0+)
    static func isHapticAvailable() -> Bool {
        if #available(iOS 10.0, *) {
            return true
        } else {
            return false
        }
    }
}
