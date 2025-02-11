import SwiftUI

struct ContentView: View {
    @State private var isVibrating = false
    @State private var isFlashlightOn = false
    @State private var distance: String = ""
    @State private var density: String = ""
    @State private var totalImages: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CameraView()
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
                        // Ruler Button (Navigates to RulerView)
                        NavigationLink(destination: RulerView()) {
                            Text("Ruler")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }

                        // Start/Stop Button
                        Button(action: {
                            if isVibrating {
                                Vibrate.stopVibrating()
                                Flashlight.turnOff()
                            } else {
                                Vibrate.startVibration()
                                Flashlight.turnOn()
                            }
                            isVibrating.toggle()
                            isFlashlightOn.toggle()
                        }) {
                            Text(isVibrating ? "Stop" : "Start")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(isVibrating ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }
        }
    }
}
