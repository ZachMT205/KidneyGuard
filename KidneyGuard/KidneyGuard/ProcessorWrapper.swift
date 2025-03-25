import Foundation
import UIKit

func wl_to_tension(wavelength: Double, resolution: Double, frequency: Double = 144.5) -> Double {
    let l_m = wavelength / resolution
    let k = 2 * Double.pi / l_m
    let w = 2 * Double.pi * frequency
    let g = 9.8
    return (w * w - k * g) / pow(k, 3) * 1e6
}

func analyzeCapturedImages(images: [UIImage], distance: Double) -> Double {
    let processor = ImageProcessor(orig_len: 320, log: { _ in }, client: AppClient())
    let (_, _, _, wavelength) = processor.analyzeGroup(images)
    let resolution = 39500.0 * 87.0 / distance
    return wl_to_tension(wavelength: wavelength, resolution: resolution)
}
