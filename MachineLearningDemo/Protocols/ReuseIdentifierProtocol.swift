//
//  ReuseIdentifierProtocol.swift
//  MachineLearningDemo
//
//  Created by Abhishek Bedi on 7/7/17.
//  Copyright © 2017 abhishekbedi. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableIdentifierProtocol: class {}

extension ReusableIdentifierProtocol where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
