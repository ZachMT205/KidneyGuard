import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var totalImages: Int
    @Binding var isCapturing: Bool
    var distance: String
    var density: String
    @Binding var capturedImages: [UIImage]
    var processCapturedImages: ([UIImage]) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = CameraViewController(totalImages: totalImages, coordinator: context.coordinator)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let vc = uiViewController as? CameraViewController {
            if isCapturing {
                vc.startCapture(totalImages: totalImages, processImages: processCapturedImages)
            } else {
                vc.stopCapture()
            }
        }
    }
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput,
                         didFinishProcessingPhoto photo: AVCapturePhoto,
                         error: Error?) {
            if let error = error {
                print("Error capturing photo: \(error)")
                return
            }
            guard let imageData = photo.fileDataRepresentation(),
                  let image = UIImage(data: imageData) else {
                return
            }
            print("Captured image")
            parent.capturedImages.append(image)
            if parent.capturedImages.count == parent.totalImages {
                print("Finished capturing \(parent.totalImages) images")
                parent.processCapturedImages(parent.capturedImages)
            }
        }
    }
}

class CameraViewController: UIViewController {
    var session: AVCaptureSession?
    var output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    var totalImages: Int
    var coordinator: CameraView.Coordinator
    
    private var captureTimer: Timer?
    private var captureCount = 0
    
    init(totalImages: Int, coordinator: CameraView.Coordinator) {
        self.totalImages = totalImages
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        self.session = session
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            print("Error setting up camera input: \(error)")
            return
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    func captureImage() {
        print("Capturing image... Count: \(captureCount)")
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: coordinator)
    }
    
    func startCapture(totalImages: Int, processImages: @escaping ([UIImage]) -> Void) {
        guard captureTimer == nil else { return }
        self.totalImages = totalImages
        captureCount = 0
        let pulseInterval: TimeInterval = 0.5  // Sync with Vibrate.swift (was 0.2s)
        captureTimer = Timer.scheduledTimer(withTimeInterval: pulseInterval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.captureCount < totalImages {
                self.captureImage()
                self.captureCount += 1
            } else {
                timer.invalidate()
                self.captureTimer = nil
                print("Capture complete, processing...")
                processImages(self.coordinator.parent.capturedImages)
            }
        }
    }
    
    func stopCapture() {
        captureTimer?.invalidate()
        captureTimer = nil
    }
}
