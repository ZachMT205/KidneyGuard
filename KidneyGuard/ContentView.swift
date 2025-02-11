import SwiftUI

struct ContentView: View {
    @State private var isVibrating = false
    @State private var isFlashlightOn = false
    @State private var distance: String = ""
    @State private var density: String = ""
    @State private var totalImages: String = ""
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            // Camera takes up as much space as possible
            CameraView()
                .frame(maxHeight: .infinity, alignment: .top)
                .clipped()

            // Bottom section with input fields and button
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

                // Start/Stop Button at the very bottom
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
                .padding(.bottom) // Padding to ensure it's at the very bottom
            }
            .padding()
            .background(Color(UIColor.systemBackground)) // Background to separate from camera
        }
        .gesture(
            TapGesture().onEnded {
                hideKeyboard()
            }
        )
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil, queue: .main) { notification in
                    if let info = notification.userInfo,
                       let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil, queue: .main) { _ in
                    keyboardHeight = 0
                }
        }
    }

    private func hideKeyboard() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first(where: \.isKeyWindow)?.endEditing(true)
        }
    }
}
