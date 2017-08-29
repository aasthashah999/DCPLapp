//
//  retrieveArticlesFromDB.swift
//  dccplPublicAccessArticles
//
//  Created by Aastha Shah on 8/9/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import Foundation
import Parse
class Articles: NSObject {
    var title: String?
    var picture: PFFile?
    var article: PFObject?
    var text: String?
}
