import UIKit

class Vibrate {
    static var isVibrating = false
    
    static func startVibration() {
        if !isHapticAvailable() {
            print("Device does not support haptic feedback.")
            return
        }
        isVibrating = true
        DispatchQueue.global().async {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            while isVibrating {
                DispatchQueue.main.async {
                    generator.impactOccurred()
                }
                Thread.sleep(forTimeInterval: 0.01)
            }
        }
    }
    
    static func stopVibrating() {
        isVibrating = false
    }
    
    static func isHapticAvailable() -> Bool {
        if #available(iOS 10.0, *) {
            return true
        } else {
            return false
        }
    }
}
