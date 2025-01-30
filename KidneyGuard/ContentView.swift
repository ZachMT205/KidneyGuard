import SwiftUI

struct ContentView: View {
    @State private var isVibrating = false // Track vibration state in the UI
    @State private var isFlashlightOn = false // Tracks flashlight state
    
    var body: some View {
        VStack {
            CameraView() // Display the camera view by default
            
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

#Preview {
    ContentView()
}
