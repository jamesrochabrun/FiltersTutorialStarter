//
//  Filters.swift
//  FiltersTutorialStarter
//
//  Created by James Rochabrun on 6/6/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

enum Filters {
    
    case noFilter(inputImage: CIImage)
    case toneCurveToLinear(inputImage: CIImage)
    case exposureAdjust(inputImage: CIImage)
    case chromeEffect(inputImage: CIImage)
    case photoInstant(inputImage: CIImage)
    case fadeEffect(inputImage: CIImage)
    case unexpectedFilter
    
    init(caseIndex index: Int, inputImage: CIImage ) {
        
        switch index {
        case 0: self = .noFilter(inputImage: inputImage)
        case 1: self = .toneCurveToLinear(inputImage: inputImage)
        case 2: self = .exposureAdjust(inputImage: inputImage)
        case 3: self = .chromeEffect(inputImage: inputImage)
        case 4: self = .photoInstant(inputImage: inputImage)
        case 5: self = .fadeEffect(inputImage: inputImage)
        default: self = .unexpectedFilter
        }
    }
}

extension Filters {
    
    var outputImage: CIImage? {
        
        switch self {
        case .noFilter(let inputImage):
            
            let noFilter = CIFilter(name: "CIGammaAdjust")
            noFilter?.setValue(inputImage, forKey: kCIInputImageKey)
            noFilter?.setValue(1, forKey: "inputPower")
            return noFilter?.outputImage
        case .exposureAdjust(let inputImage):
            
            let exposure = CIFilter(name: "CIExposureAdjust")
            exposure?.setValue(inputImage, forKey: kCIInputImageKey)
            exposure?.setValue(1, forKey: "inputEV")
            return exposure?.outputImage
            
        case .toneCurveToLinear(let inputImage):
            let curveToLinear = CIFilter(name: "CIPhotoEffectTransfer")
            curveToLinear?.setValue(inputImage, forKey: kCIInputImageKey)
            return curveToLinear?.outputImage
            
        case .chromeEffect(let inputImage):
            let chromeEffect = CIFilter(name: "CIPhotoEffectChrome")
            chromeEffect?.setValue(inputImage, forKey: kCIInputImageKey)
            return chromeEffect?.outputImage
            
        case .photoInstant(let inputImage):
            let instant = CIFilter(name: "CIPhotoEffectInstant")
            instant?.setValue(inputImage, forKey: kCIInputImageKey)
            return instant?.outputImage
            
        case .fadeEffect(let inputImage):
            let fadeFilter = CIFilter(name: "CIPhotoEffectFade")
            fadeFilter?.setValue(inputImage, forKey: kCIInputImageKey)
            return fadeFilter?.outputImage
        case .unexpectedFilter:
            return nil
        }
    }
}

