//
//  oneArticleViewController.swift
//  dccplPublicAccessArticles
//
//  Created by Aastha Shah on 8/11/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import UIKit


class oneArticleViewController: UIViewController {
    
    @IBOutlet weak var oneArticleImage: UIImageView!
    
    @IBOutlet weak var oneArticleTitle: UILabel!
    
    @IBOutlet weak var oneArticleText: UILabel!
    
    var articleTitle: String = ""

    
    var articleImage: UIImage? {
        didSet {
            if isViewLoaded {
                oneArticleImage.image = articleImage
            }
        }
    }

    
    var articleText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        oneArticleTitle.text = articleTitle
        oneArticleImage.image = articleImage
        oneArticleText.text = articleText
    }

}
