//
//  ViewController.swift
//  ObjectDetectionCoreML
//
//  Created by Shravan K on 12/26/17.
//  Copyright © 2017 GoDimensions. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        // request handler
        //let request = VNCoreMLRequest(model: <#T##VNCoreMLModel#>, completionHandler: <#T##VNRequestCompletionHandler?##VNRequestCompletionHandler?##(VNRequest, Error?) -> Void#>)
        
        //VNImageRequestHandler(cgImage: captureSession, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
        
    }

    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Camera is working:",Date())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("Memory Warning!")
    }


}

