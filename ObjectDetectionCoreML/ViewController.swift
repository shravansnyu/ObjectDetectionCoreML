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
    var name = ""
    @IBOutlet weak var label: UILabel!
    
    
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
        self.label.text = name
        // request handler 
        
        //VNImageRequestHandler(cgImage: captureSession, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
    }
  
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
       // print("Camera is working:",Date())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else{return}
        
        guard let model  = try? VNCoreMLModel(for: Resnet50().model) else{return}
        
        let request = VNCoreMLRequest(model: model) { (finsihedRequest, error) in
          //  print(finsihedRequest.results)
            guard let results = finsihedRequest.results as? [VNClassificationObservation] else {return}
            
            guard let firstObservation = results.first else{return}
            
            print(firstObservation.identifier, firstObservation.confidence)
            DispatchQueue.main.async {
                self.label.text = "\(firstObservation.identifier) \(firstObservation.confidence * 100)"
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("Memory Warning!")
    }


}

