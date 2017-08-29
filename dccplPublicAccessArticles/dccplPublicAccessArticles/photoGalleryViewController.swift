//
//  photoGalleryViewController.swift
//  dccplPublicAccessArticles
//
//  Created by Aastha Shah on 8/13/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import UIKit
import Parse
class photoTableCell: UITableViewCell{
    
    @IBOutlet weak var photoImage123: UIImageView!
}

class photoGalleryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var photoTableView: UITableView!
    var refresher: UIRefreshControl!
    var tappedCell: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        getArticles()
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControlEvents.valueChanged)
        self.photoTableView.addSubview(refresher)
    }
    
    var photos: [PhotoObject]?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if photos == nil {
            return 0
        }
        return (photos?.count)!
    }
    
    func getArticles() {
        let photoQuery = PFQuery(className: "ImageGallery")
        photoQuery.includeKey("galleryImage")
        photoQuery.findObjectsInBackground(block: { (objects, error) in
            let articleInfo = objects
            self.photos = Array()
            guard let allPhotos = articleInfo else {return}
            for photo in allPhotos {
                let onePhoto = PhotoObject()
                onePhoto.ImageObject = photo
                onePhoto.photo = photo["galleryImage"] as? PFFile
                print(onePhoto)
                self.photos?.insert(onePhoto, at: 0)
                print(self.photos!)
            }
            self.photoTableView.reloadData()
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photoTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? photoTableCell
        photos?[indexPath.row].photo?.getDataInBackground{
            (imageData, error) -> Void in
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    cell?.photoImage123.image = image
                }
                else {
                    print(error)
                }
            }

        return cell!
    }
    
    
    
    func populate() {
        getArticles()
        refresher.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedCell = indexPath.row
        self.performSegue(withIdentifier: "onePhoto", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onePhoto: OnePhotoViewController = segue.destination as? OnePhotoViewController{
            tappedCell = photoTableView.indexPathForSelectedRow?.row
            photos?[tappedCell!].photo?.getDataInBackground{
                (imageData, error) -> Void in
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    onePhoto.oneImage.image = image
                }
                else {
                    print(error!)
                }
            }
            
            
            
        }
    }


}
