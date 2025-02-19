import SwiftUI

struct RulerView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Ruler()
                    .frame(width: 50, height: UIScreen.main.bounds.height * 0.6)
            }
            .padding(.trailing, 20)
            Spacer()
        }
    }
}

struct Ruler: View {
    let screenHeightInches: CGFloat = 6.7
    let screenHeightPoints: CGFloat = UIScreen.main.bounds.height
    var pointsPerInch: CGFloat {
        return screenHeightPoints / screenHeightInches
    }
    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let step: CGFloat = pointsPerInch
            let numberOfInches = Int(screenHeightInches)
            
            Path { path in
                for i in 0...numberOfInches {
                    let y = CGFloat(i) * step
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: 30, y: y))
                }
            }
            .stroke(Color.black, lineWidth: 2)
            
            VStack {
                ForEach(0...numberOfInches, id: \.self) { i in
                    Text("\(i)")
                        .font(.caption)
                        .frame(height: height / CGFloat(numberOfInches), alignment: .top)
                }
            }
            .offset(x: 35)
        }
    }
}
