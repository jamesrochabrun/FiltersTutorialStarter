//
//  ViewController.swift
//  FiltersTutorialStarter
//
//  Created by James Rochabrun on 6/5/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit
import Photos

//MARK: UI and properties
class CameraVC: UIViewController {
    
    //MARK: UI elements
    override var prefersStatusBarHidden: Bool { return true }
    
    lazy var captureButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.borderColor = UIColor.green.cgColor
        b.layer.borderWidth = 3.0
        b.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        return b
    }()
    
    ///Displays a preview of the video output generated by the device's cameras.
    let capturePreviewView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var toggleCameraButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
        b.addTarget(self, action: #selector(switchCameras), for: .touchUpInside)
        return b
    }()
    
    lazy var toggleFlashButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        b.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        return b
    }()
    
    
    
    //MARK: UI setUp
    func setUpViews() {
        
        view.addSubview(capturePreviewView)
        capturePreviewView.addSubview(captureButton)
        capturePreviewView.addSubview(toggleFlashButton)
        capturePreviewView.addSubview(toggleCameraButton)
        
        NSLayoutConstraint.activate([
            
            capturePreviewView.topAnchor.constraint(equalTo: view.topAnchor),
            capturePreviewView.leftAnchor.constraint(equalTo: view.leftAnchor),
            capturePreviewView.heightAnchor.constraint(equalTo: view.heightAnchor),
            capturePreviewView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            toggleFlashButton.heightAnchor.constraint(equalToConstant: 50),
            toggleFlashButton.widthAnchor.constraint(equalToConstant: 50),
            toggleFlashButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            toggleFlashButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            toggleCameraButton.topAnchor.constraint(equalTo: toggleFlashButton.bottomAnchor, constant: 30),
            toggleCameraButton.heightAnchor.constraint(equalTo: toggleFlashButton.heightAnchor),
            toggleCameraButton.widthAnchor.constraint(equalTo: toggleFlashButton.widthAnchor),
            toggleCameraButton.rightAnchor.constraint(equalTo: toggleFlashButton.rightAnchor),
            
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.heightAnchor.constraint(equalToConstant: 80),
            captureButton.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
    
    //MARK: Camera
    let cameraController = CameraController()
    
    
}

//MARK: App lifecycle
extension CameraVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        func configureCameraController() {
            
            cameraController.prepare {(error) in
                if let error = error { print(error) }
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }
        configureCameraController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
    }
}

//MARK: Photo action handlers
extension CameraVC {
    
    func toggleFlash() {
        
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        } else {
            
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    
    func switchCameras() {
        
        do {
            try cameraController.switchCameras()
        } catch {
            print("Error: \(error)")
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
        case .some(.rear):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
        case .none:
            return
        }
    }
}

//MARK: Photos framework classes usage
extension CameraVC {
    
    func captureImage() {
        
        cameraController.captureImage { (image, error) in
            
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }
}
