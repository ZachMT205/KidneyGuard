import Foundation
import CoreGraphics

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

extension Data {
    func toArray<T>(type: T.Type) -> [T] {
        let count = self.count / MemoryLayout<T>.size
        return self.withUnsafeBytes { pointer in
            let buffer = pointer.bindMemory(to: T.self)
            return Array(buffer.prefix(count))
        }
    }
    
    init<T>(fromArray array: [T]) {
        self = array.withUnsafeBufferPointer { Data(buffer: $0) }
    }
}
