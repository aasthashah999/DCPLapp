//
//  GameScheduleViewController.swift
//  dccplPublicAccessArticles
//
//  Created by Aastha Shah on 8/16/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import UIKit

class GameScheduleViewController: UIViewController {
    let url1 = URL(string: "http://www.dcplusa.org/downloads/DCPL-SCHEDULE-2017.pdf")
    
    @IBOutlet weak var scedulePDF: UIWebView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceduleURL = URL(string: "http://www.dcplusa.org/schedule.html")
        let requestURL = URLRequest(url: sceduleURL!)
        scedulePDF.loadRequest(requestURL)
        
    }
}
