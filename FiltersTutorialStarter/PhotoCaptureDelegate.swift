//
//  PhotoCaptureDelegate.swift
//  FiltersTutorialStarter
//
//  Created by James Rochabrun on 6/6/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    private let completed: (PhotoCaptureDelegate) -> ()
    private let capturedPhoto: (UIImage) -> ()
    
    
    init(with requestedPhotoSettings: AVCapturePhotoSettings,
         capturedPhoto: @escaping (UIImage) -> (),
         completed: @escaping (PhotoCaptureDelegate) -> ()) {
        
        self.requestedPhotoSettings = requestedPhotoSettings
        self.completed = completed
        self.capturedPhoto = capturedPhoto
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error)
            
        }
        guard let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) else { return }
        
        capturedPhoto(image)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        completed(self)
    }
}



