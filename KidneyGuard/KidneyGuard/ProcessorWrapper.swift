import Foundation
import UIKit

/// Converts a measured wavelength (in pixels) to surface tension (in mN/m).
func wl_to_tension(wavelength: Double, resolution: Double, frequency: Double = 144.5) -> Double {
    let l_m = wavelength / resolution
    let k = 2 * Double.pi / l_m
    let w = 2 * Double.pi * frequency
    let g = 9.8
    return (w * w - k * g) / pow(k, 3) * 1e6
}

/// Processes the captured images using CapCam’s ImageProcessor and returns the computed surface tension.
/// - Parameters:
///   - images: An array of UIImages captured by the camera.
///   - distance: The distance (in mm) entered by the user.
/// - Returns: The computed surface tension.
func analyzeCapturedImages(images: [UIImage], distance: Double) -> Double {
    // Create the ImageProcessor with a minimal AppClient.
    // The 'orig_len' should match the size expected by your processing code.
    let processor = ImageProcessor(orig_len: 320, log: { _ in }, client: AppClient())
    
    // Call analyzeGroup from CapCam. It returns a tuple whose fourth element is the wavelength.
    let (_, _, _, wavelength) = processor.analyzeGroup(images)
    
    // Calculate resolution. In CapCam’s CameraController, resolution is computed as:
    //   resolution = 39500.0 / resize_factor * 87.0 / distance.
    // Here we assume resize_factor = 1.
    let resolution = 39500.0 * 87.0 / distance
    return wl_to_tension(wavelength: wavelength, resolution: resolution)
}
