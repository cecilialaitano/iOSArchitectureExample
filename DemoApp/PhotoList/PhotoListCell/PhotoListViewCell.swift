//
//  PhotoListViewCell.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import UIKit

class PhotoListViewCell: UICollectionViewCell {

  @IBOutlet weak var imageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func setup(_ image: UIImage) {
    imageView.image = image
    if isSelected {
      backgroundColor = UIColor.teal()
    } else {
      backgroundColor = UIColor.white
    }
  }
}
