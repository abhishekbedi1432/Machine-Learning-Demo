//
//  ImageProcessor.swift
//  GuessImage
//
//  Created by Abhishek Bedi on 7/6/17.
//

import Foundation
import Vision
import CoreML


class ImageProcessor {
    
    
    static func processImage(_ image: CGImage, completion: @escaping ([(String,Double)])->Void ){
        
        DispatchQueue.global(qos: .background).async {
            
            //Init Core Vision Model
            guard let vnCoreModel = try? VNCoreMLModel(for: Inceptionv3().model) else { return }
            
            //Init Core Vision Request
            let request = VNCoreMLRequest(model: vnCoreModel) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else { fatalError("Failure") }
                
                var strings : [(id:String,confidence:Double)] = []
                for classification in results {
                    let id  = String(classification.identifier) ?? ""
                    let confidence = Double(classification.confidence)
                    strings.append((id: id, confidence: confidence))
                }
                
                strings = strings.sorted(by: { (record1, record2) -> Bool in
                    return record1.confidence > record2.confidence
                })
                
                DispatchQueue.main.async {
                    print("Found \(strings.count) results")
                    
                    completion(strings)
                }
            }
            //Init Core Vision Request Handler
            let handler = VNImageRequestHandler(cgImage: image)
            
            //Perform Core Vision Request
            do {
                try handler.perform([request])
            } catch {
                print("did throw on performing a VNCoreRequest")
            }
        }
    }
    
}
