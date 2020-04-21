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
    
  
    var photoCollection = [1, 2, 3, 4, 5, 6]
    
    var user: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        return cell
    }

  }

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
}
