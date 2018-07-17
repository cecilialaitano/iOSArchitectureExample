//
//  ImagePickerViewController.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate: class {
  func didSelectedPhoto( _ photo: SelectablePhoto) -> ()
}

class ImagePickerViewController: UIViewController {

  @IBOutlet weak var unsplashButton: UIButton!
  @IBOutlet weak var libraryButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!

  private var presenter: ImagePickerViewPresenter!
  private var images = [UIImage]()

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = ImagePickerViewPresenter(self)
    setupView()
  }

  // MARK: - Initial setup
  func setupView() {
    libraryButton.setRoundCorners()
    unsplashButton.setRoundCorners()
  }

  // MARK - Segue handler
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let photoList = segue.destination as? PhotoListViewController,
      let identifier = segue.identifier else {
        return
    }
    photoList.delegate = self
    photoList.selectedSource = presenter.getSource(for: identifier)
  }
}

extension ImagePickerViewController: ImagePickerDelegate {
  
  func didSelectedPhoto(_ photo: SelectablePhoto) -> () {
    //TODO: Add loader while full image size is loading.
    presenter.loadImage(photo)
  }
}

extension ImagePickerViewController: ImagePickerViewProtocol {

  func show(_ error: String) {
    //TODO: add implementation
  }

  func updatePhoto(with data: Data) {
    //TODO: Hide loader when full image size is loaded.
    DispatchQueue.main.async {
      self.imageView.image = UIImage(data: data)
    }
  }
}


