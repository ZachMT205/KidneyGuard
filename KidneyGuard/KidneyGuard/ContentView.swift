import SwiftUI
import UIKit

struct ContentView: View {
    @State private var distance: String = ""         // in mm
    @State private var density: String = ""          // Currently unused
    @State private var totalImages: String = "5"     // Number of photos to capture
    @State private var surfaceTensionResult: String = "N/A"
    @State private var isAnalyzing = false
    @State private var isCapturing = false
    @State private var capturedImages: [UIImage] = []
    
    @State private var isFlashlightOn = false
    @State private var isVibrating = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CameraView(
                    totalImages: Binding(
                        get: { Int(totalImages) ?? 5 },
                        set: { totalImages = String($0) }
                    ),
                    isCapturing: $isCapturing,
                    distance: distance,
                    density: density,
                    capturedImages: $capturedImages,
                    processCapturedImages: { images in
                        processImages(images: images)
                    }
                )
                .frame(maxHeight: .infinity)
                .clipped()
                
                VStack(spacing: 12) {
                    TextField("Enter distance (mm)", text: $distance)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") { dismissKeyboard() }
                            }
                        }
                    
                    TextField("Enter density (g/cm³)", text: $density)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    TextField("Enter total images (pics)", text: $totalImages)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            if !isAnalyzing { startSurfaceTensionAnalysis() }
                        }) {
                            Text(isAnalyzing ? "Analyzing..." : "Start Analysis")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(isAnalyzing ? Color.gray : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .disabled(isAnalyzing)
                        
                        NavigationLink(destination: RulerView()) {
                            Text("Ruler")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    
                    if !isAnalyzing && surfaceTensionResult != "N/A" {
                        Text("Average Surface Tension: \(surfaceTensionResult) mN/m")
                             .padding()
                             .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }
            .navigationBarTitle("KidneyGuard", displayMode: .inline)
        }
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
    
    func startSurfaceTensionAnalysis() {
        guard let _ = Double(distance),
              let totalImagesValue = Int(totalImages), totalImagesValue > 0 else {
            surfaceTensionResult = "Invalid input"
            return
        }
        capturedImages = []
        surfaceTensionResult = "N/A"
        isAnalyzing = true
        
        startFlashlightAndVibration()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Starting capture...")
            self.isCapturing = true
        }
    }
    
    func processImages(images: [UIImage]) {
        guard let distanceValue = Double(distance) else {
            DispatchQueue.main.async {
                self.surfaceTensionResult = "Invalid distance"
                self.isAnalyzing = false
                stopFlashlightAndVibration()
            }
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let tension = analyzeCapturedImages(images: images, distance: distanceValue)
            DispatchQueue.main.async {
                self.surfaceTensionResult = String(format: "%.2f", tension)
                self.isAnalyzing = false
                self.isCapturing = false
                self.capturedImages = []
                stopFlashlightAndVibration()
            }
        }
    }
    
    func startFlashlightAndVibration() {
        Flashlight.turnOn()
        Vibrate.startVibration()
        isFlashlightOn = true
        isVibrating = true
    }
    
    func stopFlashlightAndVibration() {
        Flashlight.turnOff()
        Vibrate.stopVibration()
        isFlashlightOn = false
        isVibrating = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
