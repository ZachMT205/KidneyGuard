import AVFoundation
import UIKit
import SwiftUI

class CameraManager: NSObject, ObservableObject {
    private var captureSession: AVCaptureSession?
    
    @Published var isRunning = false
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func setupCamera() {
        // Initialize capture session
        captureSession = AVCaptureSession()
        
        guard let captureSession = captureSession else { return }
        
        // Set the video capture device (camera)
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("No camera available")
            return
        }
        
        do {
            // Try to create an input from the video capture device
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            // Add input to the session
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            } else {
                print("Failed to add input")
                return
            }
        } catch {
            print("Error setting up video input: \(error)")
            return
        }
        
        // Add output for the video feed
        let videoDataOutput = AVCaptureVideoDataOutput()
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        } else {
            print("Failed to add output")
            return
        }
        
        // Start the session in the background thread to avoid UI blockage
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
            DispatchQueue.main.async {
                self.isRunning = captureSession.isRunning
            }
        }
    }
    
    func getPreviewLayer(for view: UIView) -> AVCaptureVideoPreviewLayer? {
        guard let captureSession = captureSession else { return nil }
        
        // Create the preview layer from the capture session
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }
}
