//
//  MenuViewController.swift
//  dccplPublicAccessArticles
//
//  Created by Aastha Shah on 8/24/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import UIKit
import Parse
class MenuCell: UITableViewCell {
    
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var menuLabel: UILabel!
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var menuTable: UITableView!
    var menuArray: [Articles]?
    var tappedCell: Int?
    var refresher: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getArticles()
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControlEvents.valueChanged)
        self.menuTable.addSubview(refresher)
        
    }
    
    func getArticles() {
        let articleQuery = PFQuery(className: "Menu")
        articleQuery.includeKey("articleText")
        articleQuery.includeKey("articleImage")
        articleQuery.includeKey("articleTitle")
        articleQuery.findObjectsInBackground(block: { (objects, error) in
            let articleInfo = objects
            self.menuArray = Array()
            guard let allArticles = articleInfo else {return}
            for article in allArticles {
                let oneArticle = Articles()
                oneArticle.article = article
                oneArticle.text = article["articleText"] as? String
                oneArticle.title = article["articleTitle"] as? String
                oneArticle.picture = article["articleImage"] as? PFFile
                print(oneArticle)
                self.menuArray?.insert(oneArticle, at: 0)
            }
            self.menuTable.reloadData()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuArray == nil {
            return 0
        }
        return menuArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTable.dequeueReusableCell(withIdentifier: "Menucell") as? MenuCell
        cell?.menuLabel.text = menuArray?[indexPath.row].title
        menuArray![indexPath.row].picture?.getDataInBackground{
            (imageData, error) -> Void in
            if imageData != nil {
                let image = UIImage(data: imageData!)
                cell?.menuImage.image = image
            }
            else {
                print(error!)
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedCell = indexPath.row
        self.performSegue(withIdentifier: "toMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let oneArticleView: oneArticleViewController = segue.destination as? oneArticleViewController{
            tappedCell = menuTable.indexPathForSelectedRow?.row
            oneArticleView.articleTitle = (menuArray?[tappedCell!].title)!
            oneArticleView.articleText = (menuArray?[tappedCell!].text)!
            menuArray![tappedCell!].picture?.getDataInBackground{
                (imageData, error) -> Void in
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    oneArticleView.articleImage = image
                }
                else {
                    print(error!)
                }
            }
            
            
            
        }
    }
    
    func populate() {
        getArticles()
        refresher.endRefreshing()
        
    }




}
