import Foundation
import UIKit

// Minimal no-op version of AppClient for local processing.
class AppClient {
    func send_tag(_ tag: String) { }
    func send_pointer<T>(_ d: UnsafePointer<T>, _ count: Int) -> Int { return 0 }
    func send_array<T>(_ d: [T], _ name: String = "test") -> Int { return 0 }
    func send_data<T>(_ d: T, with_count: Bool = true) -> Int { return 0 }
    func receive_packet() -> Data? { return nil }
    func receive_double() -> Double? { return nil }
}
