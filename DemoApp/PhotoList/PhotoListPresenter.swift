//
//  PhotoListPresenter.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

class PhotoListPresenter {

  private var view: PhotoListViewProtocol!
  private var source: PhotoListAdapter!
  private var selectedPhoto: Int?

  init(_ view: PhotoListViewProtocol, source: PhotoListAdapter) {
    self.view = view
    self.source = source
  }

  func start(source: PhotoSource) {
    var title = String()
    switch source {
      case .library:
        title = "Library"
      case .unsplash:
        title = "Unsplash"
    }
    view.setup(title: title)
    fetchPhotos()
  }

  func getNumberOfItems() -> Int {
    return source.getNumberOfPhotos()
  }

  func getThumbPhotoData(for row: Int, completion: @escaping (_ imageData: Data) -> ()) {
    source.getImageData(for: row, type: PhotoType.thumb, completion: { [weak self] data, error  in
      if let fetchDataError = error {
        self?.view.show(fetchDataError.rawValue)
      } else if let imageData = data {
        completion(imageData)
      }
    })
  }

  func getFullPhotoData(for row: Int, completion: @escaping (_ imageData: Data) -> ()) {
    source.getImageData(for: row, type: PhotoType.full, completion: { [weak self] data, error in
      if let fetchDataError = error {
        self?.view.show(fetchDataError.rawValue)
      } else if let imageData = data {
        completion(imageData)
      }
    })
  }

  func setSelected(row: Int) {
    selectedPhoto = row
    view.doneButton(enable: true)
  }

  func getSelectedItem() -> SelectablePhoto? {
    guard let row = selectedPhoto else {
      return nil
    }
    return source.getSelectedItem(row)
  }

  private func fetchPhotos() {
    view.showLoading()
    source.fetchPhotos { (isSuccess, error) in
      DispatchQueue.main.async {
        if isSuccess && error == nil {
          self.view.hideLoading()
          self.view.updateCollectionView()
        } else if let error = error {
          self.view.show(error.rawValue)
        }
      }
    }
  }
}
