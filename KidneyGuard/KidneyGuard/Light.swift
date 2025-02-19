import AVFoundation

class Flashlight {
    static func turnOn() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("Device does not support a flashlight.")
            return
        }
        do {
            try device.lockForConfiguration()
            if device.hasTorch {
                try device.setTorchModeOn(level: 1.0)
            }
            device.unlockForConfiguration()
        } catch {
            print("Error while turning on flashlight: \(error)")
        }
    }
    
    static func turnOff() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("Device does not support a flashlight.")
            return
        }
        do {
            try device.lockForConfiguration()
            if device.hasTorch {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            print("Error while turning off flashlight: \(error)")
        }
    }
}
