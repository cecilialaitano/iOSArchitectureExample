//
//  PhotoLibraryManager.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation
import Photos

protocol PhotoManagerProtocol {
  func requestThumbData(for asset: PHAsset, completion: @escaping GetPhotoDataHandler)
}

class PhotoLibraryManager: PhotoListAdapter {

  private var photosAsset = PHFetchResult<PHAsset>()
  fileprivate let thumbSize = CGSize(width: 100.0, height: 100.0)
  private var imageManager: PHImageManager!

  init() {
    imageManager = PHImageManager.default()
  }

  func getNumberOfPhotos() -> Int {
    return self.photosAsset.count
  }

  func getImageData(for row: Int, type: PhotoType, completion: @escaping GetPhotoDataHandler) {
    let asset = photosAsset[row]
    switch type {
      case .thumb:
        requestThumbData(for: asset) { (data, error) in
          completion(data, error)
      }
      case .full:
        requestFullSizeData(for: asset) { (data, error) in
          completion(data, error)
      }
    }
  }

  func fetchPhotos(completion: @escaping FetchPhotoLibraryClosure) {
    PHPhotoLibrary.requestAuthorization { status in
      switch status {
      case .authorized:
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
          NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        self.photosAsset = allPhotos
        completion(true, nil)
      case .denied, .restricted:
        completion(false, FetchPhotosError.accessNotAllowed)
      case .notDetermined:
        completion(false, FetchPhotosError.notDetermined)
      }
    }
  }

  func getSelectedItem(_ selected: Int) -> SelectablePhoto {
    return photosAsset[selected]
  }
}

extension PhotoLibraryManager: PhotoManagerProtocol {
  func requestThumbData(for asset: PHAsset, completion: @escaping GetPhotoDataHandler) {
    imageManager.requestImage(for: asset, targetSize: thumbSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, info) -> Void in
      if let thumbnail = result,
        let imageData = UIImageJPEGRepresentation(thumbnail, 0.2) {
        completion(imageData, nil)
      } else {
        completion(nil, FetchPhotosError.defualt)
      }
    })
  }

  func requestFullSizeData(for asset: PHAsset, completion: @escaping GetPhotoDataHandler) {
    let options = PHImageRequestOptions()
    // allows access from photos saved in iCloud.
    options.isNetworkAccessAllowed = true

    imageManager.requestImageData(for: asset, options: options, resultHandler: { (data, info, orientation, dictionary) in
      if let imageData = data {
        completion(imageData, nil)
      } else {
        completion(nil, FetchPhotosError.defualt)
      }
    })
  }
}

extension PHAsset: SelectablePhoto {

  func getPhotoDataFullSize(completion: @escaping GetSelectedPhoto) {
    PhotoLibraryManager().requestFullSizeData(for: self) { (data, error) in
      completion(data, error)
    }
  }

  func getThumb(completion: @escaping GetSelectedPhoto) {
    PhotoLibraryManager().requestThumbData(for: self) { (data, error) in
      completion(data, error)
    }
  }
}

