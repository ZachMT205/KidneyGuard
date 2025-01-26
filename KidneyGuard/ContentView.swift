import SwiftUI

struct ContentView: View {
    @State private var isVibrating = false // Track vibration state in the UI
    @State private var isFlashlightOn = false // Tracks flashlight state
    @ObservedObject private var cameraManager = CameraManager() // Tracks camera state

    var body: some View {
        VStack {
            // Camera Preview Layer
            CameraPreviewView(cameraManager: cameraManager)
                .edgesIgnoringSafeArea(.top)
            
            // Button to toggle vibration
            Button(action: {
                if isVibrating {
                    Vibrate.stopVibrating() // Stop vibration
                } else {
                    Vibrate.startVibration() // Start vibration
                }
                // Toggle the UI state on the main thread
                DispatchQueue.main.async {
                    isVibrating.toggle()
                }
            }) {
                Text(isVibrating ? "Stop Vibrating" : "Start Vibrating")
                    .padding()
                    .background(isVibrating ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            
            // Button for flashlight
            Button(action: {
                if isFlashlightOn {
                    Flashlight.turnOff() // Turn off flashlight
                } else {
                    Flashlight.turnOn() // Turn on flashlight
                }
                // Toggle the UI state
                isFlashlightOn.toggle()
            }) {
                Text(isFlashlightOn ? "Turn Off Flashlight" : "Turn On Flashlight")
                    .padding()
                    .background(isFlashlightOn ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
        .padding()
    }
}

struct CameraPreviewView: UIViewRepresentable {
    var cameraManager: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        // Set up the preview layer
        if let previewLayer = cameraManager.getPreviewLayer(for: view) {
            view.layer.addSublayer(previewLayer)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // The view is updated as necessary
    }
}

#Preview {
    ContentView()
}
