//
//  OnePhotoViewController.swift
//  dccplPublicAccessArticles
//
//  Created by Aastha Shah on 8/23/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import UIKit

class OnePhotoViewController: UIViewController {

    @IBOutlet weak var oneImage: UIImageView!
    
    var articleImage: UIImage? {
        didSet {
            if isViewLoaded {
                oneImage.image = articleImage
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        oneImage.image = articleImage

        // Do any additional setup after loading the view.
    }
    
    
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to photo library.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func saveImage(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(oneImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}
