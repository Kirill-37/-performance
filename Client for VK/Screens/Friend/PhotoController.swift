//
//  PhotoController.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 05/12/2019.
//  Copyright © 2019 Кирилл Харузин. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Photo"

class PhotoController: UICollectionViewController {
    
    
    var photoCollection = [Photos]()
    var user: Friends?
    var cachedPhotos = [String: UIImage]()
    
    var vkApi = VKApi()
    var db = DataBaseService()
    let queue: DispatchQueue = DispatchQueue(label: "FriendsPhoto_quene", qos: .userInteractive, attributes: [.concurrent])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        guard let userPhotoID = user?.id else { return }
        
        vkApi.getPhotos(userID: userPhotoID) {
            DispatchQueue.main.async {
                self.photoCollection = self.db.getUserPhotos(ownerId: userPhotoID)
                self.collectionView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        
        let url = photoCollection[indexPath.row].imageURL
        
        queue.async {
            if let image = self.vkApi.getImageByURL(imageUrl: url) {
                
                DispatchQueue.main.async {
                    cell.photo.image = image
                }
            }
        }
        
        return cell
    }
    
}

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
}
