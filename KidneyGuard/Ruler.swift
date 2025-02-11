import SwiftUI

struct RulerView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer() // Push content to the right

                VStack {
                    // Vertical ruler on the right edge
                    Ruler()
                        .frame(width: 50, height: UIScreen.main.bounds.height * 0.6) // Adjust height based on device's screen
                }
            }
            .padding(.trailing, 20) // Move closer to the edge

            Spacer()
        }
    }
}

// 📏 Vertical Ruler Component in Inches
struct Ruler: View {
    // Physical height of the iPhone 16 Pro Max in inches
    let screenHeightInches: CGFloat = 6.7

    // Pixel height of the iPhone 16 Pro Max screen (in points)
    let screenHeightPoints: CGFloat = UIScreen.main.bounds.height

    // Number of points per inch based on the iPhone screen
    var pointsPerInch: CGFloat {
        return screenHeightPoints / screenHeightInches
    }

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let step: CGFloat = pointsPerInch // Step size for each inch
            let numberOfInches = Int(screenHeightInches) // Whole inches in the screen height

            Path { path in
                for i in 0..<numberOfInches+1 { // Draw a line for each inch
                    let y = CGFloat(i) * step
                    
                    if i % 1 == 0 {
                        // Long mark for every whole inch
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: 30, y: y))
                    }
                }
            }
            .stroke(Color.black, lineWidth: 2)

            // Labels for every inch
            VStack {
                ForEach(0..<numberOfInches+1) { i in
                    Text(String(i)) // Whole inch labels
                        .font(.caption)
                        .frame(height: height / CGFloat(numberOfInches), alignment: .top)
                }
            }
            .offset(x: 35) // Move text to the right of ruler
        }
    }
}
