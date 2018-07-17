//
//  ImagePickerViewPresenter.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

class ImagePickerViewPresenter {
  private var view: ImagePickerViewProtocol!

  init(_ view: ImagePickerViewProtocol) {
    self.view = view
  }

  func getSource(for identifier: String) -> PhotoSource {
    if identifier == Constants.segueFromUnsplash {
      return PhotoSource.unsplash
    }
    return PhotoSource.library
  }

  func loadImage(_ photo: SelectablePhoto) {
    var fullSizeLoaded = false
    photo.getThumb {  [weak self] (data, error) in
      if error != nil && data == nil {
        self?.view.show(error!.localizedDescription)
      }
      else if data != nil && !fullSizeLoaded {
        self?.view.updatePhoto(with: data!)
      }
    }

    photo.getPhotoDataFullSize { [weak self] (data, error) in
      if error != nil && data == nil {
        self?.view.show(error!.localizedDescription)
      }
      else if let imageData = data {
        fullSizeLoaded = true
        self?.view.updatePhoto(with: imageData)
      }
    }
  }
}
