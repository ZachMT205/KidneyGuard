import SwiftUI

struct ContentView: View {
    @State private var isVibrating = false
    @State private var isFlashlightOn = false
    @State private var distance: String = ""
    @State private var density: String = ""
    @State private var totalImages: String = "5" // Default to 5
    @State private var surfaceTensionResult: String = "N/A"
    @State private var isAnalyzing = false
    @State private var surfaceTensionValues: [Double] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CameraView(totalImages: Binding(get: {
                    Int(totalImages) ?? 5
                }, set: { newValue in
                    totalImages = String(newValue)
                }), distance: distance, density: density)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .clipped()

                VStack {
                    TextField("Enter distance (mm)", text: $distance)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    TextField("Enter density (g/cm³)", text: $density)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    TextField("Enter total images (pics)", text: $totalImages)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)

                    HStack {
                        // Start/Stop Button
                        Button(action: {
                            if !isAnalyzing {
                                startSurfaceTensionAnalysis()
                            }
                        }) {
                            Text(isAnalyzing ? "Analyzing..." : "Start Analysis")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(isAnalyzing ? Color.gray : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .disabled(isAnalyzing) // Disable button during analysis

                        // Ruler Button (Navigates to RulerView)
                        NavigationLink(destination: RulerView()) {
                            Text("Ruler")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.top, 10)
                    
                    // Display surface tension result
                    if !isAnalyzing {
                        Text("Average Surface Tension: \(surfaceTensionResult)")
                            .padding()
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .onTapGesture {
                    hideKeyboard() // Dismiss the keyboard when tapping outside the text fields
                }
            }
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func startSurfaceTensionAnalysis() {
        // Ensure input values are valid
        guard let distanceValue = Double(distance),
              let densityValue = Double(density),
              let totalImagesValue = Int(totalImages), totalImagesValue > 0 else {
            surfaceTensionResult = "Invalid input"
            return
        }
        
        // Initialize/reset values
        surfaceTensionValues.removeAll()
        isAnalyzing = true
        surfaceTensionResult = "N/A"
        
        // Start flashlight and vibration
        startFlashlightAndVibration()

        // Start the analysis (simulate photo capture and surface tension calculation)
        DispatchQueue.global(qos: .userInitiated).async {
            var imageCount = 0
            for _ in 1...totalImagesValue {
                // Simulate photo capture and calculation of surface tension
                let surfaceTension = self.calculateSurfaceTension(distance: distanceValue, density: densityValue)
                
                // Update on the main thread
                DispatchQueue.main.async {
                    self.surfaceTensionValues.append(surfaceTension)
                    imageCount += 1
                    if imageCount == totalImagesValue {
                        // Once all images are processed, calculate the average surface tension
                        let averageSurfaceTension = self.surfaceTensionValues.reduce(0, +) / Double(self.surfaceTensionValues.count)
                        self.surfaceTensionResult = String(format: "%.2f", averageSurfaceTension)
                        
                        // Stop analyzing, flashlight, and vibration
                        self.stopFlashlightAndVibration()
                        self.isAnalyzing = false
                    }
                }
                
                // Simulate a delay for each image (simulating photo capture time)
                Thread.sleep(forTimeInterval: 1.0) // Adjust time for each image
            }
        }
    }

    func calculateSurfaceTension(distance: Double, density: Double) -> Double {
        // Placeholder formula for surface tension (replace with actual calculation)
        return (distance * density) / 100.0 // This is a placeholder
    }

    func startFlashlightAndVibration() {
        // Start flashlight (assuming a flashlight utility exists)
        Flashlight.turnOn()
        
        // Start vibration (assuming a vibration utility exists)
        Vibrate.startVibration()
        
        // Set states
        isFlashlightOn = true
        isVibrating = true
    }

    func stopFlashlightAndVibration() {
        // Stop flashlight and vibration when analysis is complete
        Flashlight.turnOff()
        Vibrate.stopVibrating()
        
        // Set states
        isFlashlightOn = false
        isVibrating = false
    }
}
