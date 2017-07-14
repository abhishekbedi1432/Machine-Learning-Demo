//
//  ViewController.swift
//  MachineLearningDemo
//
//  Created by Abhishek Bedi on 7/7/17.
//  Copyright © 2017 abhishekbedi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    /// IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    
    var kImageHeight:CGFloat = 0.0 {
        didSet {
            self.imageViewHeightConstraint.constant = CGFloat(kImageHeight)
        }
    }
    
    var models : [ViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK:- View Controller Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // On Initial load, hide the imageView
        kImageHeight = imgView.image == nil ? 0 : imageViewHeightConstraint.constant
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        self.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    //MARK:- IB Actions
    
    @IBAction func openImagePicker(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

//MARK:- UITableView Delegate & Datasource

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top \(kMaxResults) Results"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let viewModel = models[indexPath.row]
        cell.configure(model: viewModel)
        return cell
    }
}

//MARK:- Picker Delegate Methods

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgView.contentMode = .scaleAspectFit
            imgView.image = pickedImage
            kImageHeight = 160
            view.layoutIfNeeded()
            spinner.isHidden = false
            models.removeAll()
            
            ImageProcessor.processImage(pickedImage) { [weak self] strings in
                self?.models = strings
                self?.spinner.isHidden = true
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

