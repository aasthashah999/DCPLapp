//
//  ViewController.swift
//  dccplPublicAccessArticles
//
//  Created by Aastha Shah on 8/8/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import UIKit
import Parse

class customCell: UITableViewCell {
    
    @IBOutlet weak var titleLabelforArticle: UILabel!
    @IBOutlet weak var imageViewforArticle: UIImageView!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tappedCell: Int?
    var articleArray: [Articles]?
    var refresher: UIRefreshControl!
    @IBOutlet weak var articlesTableView: UITableView!
    
    func getArticles() {
        let articleQuery = PFQuery(className: "Articles")
        articleQuery.includeKey("articleText")
        articleQuery.includeKey("articleImage")
        articleQuery.includeKey("articleTitle")
        articleQuery.findObjectsInBackground(block: { (objects, error) in
            let articleInfo = objects
            self.articleArray = Array()
            guard let allArticles = articleInfo else {return}
            for article in allArticles {
                let oneArticle = Articles()
                oneArticle.article = article
                oneArticle.text = article["articleText"] as? String
                oneArticle.title = article["articleTitle"] as? String
                oneArticle.picture = article["articleImage"] as? PFFile
                print(oneArticle)
                self.articleArray?.insert(oneArticle, at: 0)
            }
            self.articlesTableView.reloadData()
        })
    }

    override func viewDidLoad() {
        self.getArticles()
        print("article Array Count\(String(describing: articleArray?.count))")
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControlEvents.valueChanged)
        self.articlesTableView.addSubview(refresher)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articleArray == nil {
            return 0
        }
        return self.articleArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articlesTableView.dequeueReusableCell(withIdentifier: "cell") as? customCell
        cell?.titleLabelforArticle.text = articleArray?[indexPath.row].title
        articleArray![indexPath.row].picture?.getDataInBackground{
            (imageData, error) -> Void in
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    cell?.imageViewforArticle.image = image
                }
                else {
                    print(error!)
                }
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedCell = indexPath.row
        self.performSegue(withIdentifier: "toArticle", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let oneArticleView: oneArticleViewController = segue.destination as? oneArticleViewController{
            tappedCell = articlesTableView.indexPathForSelectedRow?.row
            oneArticleView.articleTitle = (articleArray?[tappedCell!].title)!
            oneArticleView.articleText = (articleArray?[tappedCell!].text)!
            articleArray![tappedCell!].picture?.getDataInBackground{
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

