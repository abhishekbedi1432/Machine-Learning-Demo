//
//  TableViewCell.swift
//  MachineLearningDemo
//
//  Created by Abhishek Bedi on 7/7/17.
//  Copyright © 2017 abhishekbedi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell,ReusableIdentifierProtocol {

    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    func configure(model:ViewModel) {
        objectLabel.text =  model.object
        progressView.progress = model.confidence
        confidenceLabel.text = model.confidencePercentage
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let transform = CGAffineTransform(scaleX: 1, y: 5)
        progressView.transform = transform;
   }
}
