import Foundation
import CoreGraphics

// MARK: - Minimal ImageGroup

/// Define a minimal ImageGroup if you don’t use the full CoreData version.
/// Adjust properties as needed.
struct ImageGroup {
    var resolution: Double = 39500.0  // example default
    var frequency: Double = 144.5     // example default
}

// MARK: - CGPoint Arithmetic Operators

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }
    
    static func / (point: CGPoint, scalar: Double) -> CGPoint {
        return point / CGFloat(scalar)
    }
    
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    static func * (point: CGPoint, scalar: Double) -> CGPoint {
        return point * CGFloat(scalar)
    }
}

// MARK: - Data Extension to Convert to Array

extension Data {
    /// Converts Data to an array of the specified type.
    func toArray<T>(type: T.Type) -> [T] {
        let count = self.count / MemoryLayout<T>.size
        return self.withUnsafeBytes { pointer in
            let buffer = pointer.bindMemory(to: T.self)
            return Array(buffer.prefix(count))
        }
    }
}

extension Data {
    init<T>(fromArray array: [T]) {
        self = array.withUnsafeBufferPointer { Data(buffer: $0) }
    }
}
