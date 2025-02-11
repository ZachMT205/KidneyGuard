import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView
        var capturedImages: [UIImage] = []
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func captureImage() {
            // Capture the photo
            parent.capturePhoto()
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput,
                         didFinishProcessingPhotoToMemoryBuffer photo: AVCapturePhoto,
                         error: Error?) {
            guard let imageData = photo.fileDataRepresentation(),
                  let image = UIImage(data: imageData) else { return }
            capturedImages.append(image)
            
            // Check if we've reached the required number of images
            if capturedImages.count == parent.totalImages {
                // Here, you can process the captured images
                parent.processCapturedImages(images: capturedImages)
            }
        }
    }
    
    @Binding var totalImages: Int
    var distance: String
    var density: String
    var capturedImages: [UIImage] = []
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CameraViewController(totalImages: totalImages,
                                                  coordinator: context.coordinator)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func capturePhoto() {
        // Trigger the photo capture
    }
    
    func processCapturedImages(images: [UIImage]) {
        // Process the images and calculate surface tension here
    }
}

class CameraViewController: UIViewController {
    var session: AVCaptureSession?
    var output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    @State var totalImages: Int
    var coordinator: CameraView.Coordinator
    
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
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
            }
        } catch {
            print("Error setting up camera: \(error)")
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
        previewLayer.frame = view.bounds // Dynamically update frame
    }
    
    func captureImage() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: coordinator)
    }
}
