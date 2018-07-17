//
//  PhotoListDetailViewController.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 29/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import UIKit

class PhotoListDetailViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  var photo: UIImage?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func setPhoto(_ photo: UIImage) {
    DispatchQueue.main.async {
      self.imageView.image = photo
    }
  }
}
