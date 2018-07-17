//
//  UnsplashService.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

typealias GetPhotosCompletion = (_ photos: [UnsplashPhoto]?,_ error: Error?) -> ()
typealias Params = [String: String]

class UnsplashService {

  private var photos = [UnsplashPhoto]()
  private var networkManager: NetworkManager!

  init() {
    networkManager = NetworkManager()
  }

  private func getPhotosFromUnplash(_ params: Params?, completion: @escaping GetPhotosCompletion) {
    guard let url = buildURL(with: params) else {
      completion(nil, FetchPhotosError.defualt)
      return
    }

    let endpoint = EndPoint(url: url, httpMethod: .get)
    networkManager.request(endpoint) { (data, response, error) in
      if error != nil && data == nil {
        completion(nil, error)
      }
      if let photoData = data {
        let decoder = JSONDecoder()
        do {
          let photos = try decoder.decode([UnsplashPhoto].self, from: photoData)
          self.photos = photos
          completion(photos, nil)
        } catch let error {
          completion(nil, error)
        }
      }
    }
  }

  private func buildURL(with params: Params?) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = Constants.schema
    urlComponents.host = Constants.host
    urlComponents.path = Constants.pathPhotos

    guard let parameters = params else {
      return urlComponents.url
    }

    var queryItems = [URLQueryItem]()
    for p in parameters {
      let query = URLQueryItem(name: p.key, value: "\(p.value)")
      queryItems.append(query)
    }
    urlComponents.queryItems = queryItems
    return urlComponents.url
  }

  func getOneImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    let photoDataEndPoint = EndPoint(url: url, httpMethod: .get)
    networkManager.request(photoDataEndPoint) { (data, urlResponse, error) in
      completion(data, urlResponse, error)
    }
  }
}

extension UnsplashService: PhotoListAdapter {

  func getImageData(for row: Int, type: PhotoType, completion: @escaping GetPhotoDataHandler) {
    let photo = photos[row]
    var urlString = String()
    switch type {
      case .full:
        urlString = photo.urls.full
      case .thumb:
        urlString = photo.urls.thumb
    }

    guard let url = URL(string: urlString) else {
      completion(nil, FetchPhotosError.defualt)
      return
    }
    getOneImageData(from: url, completion: { data, response, error in
      guard let imageData = data else {
        completion(nil, FetchPhotosError.defualt)
        return
      }
      completion(imageData, nil)
    })
  }

  func getNumberOfPhotos() -> Int {
    return photos.count
  }

  func fetchPhotos(completion: @escaping FetchPhotoLibraryClosure) {
    let itemsPerPage = [Constants.itemsPerPageKey: Constants.itemsPerPageValue]

    getPhotosFromUnplash(itemsPerPage) { (photos, error)  in
      if let allPhotos = photos, error == nil {
        self.photos =  allPhotos
        completion(true, nil)
      } else {
        completion(false, nil)
      }
    }
  }

  func getSelectedItem(_ selected: Int) -> SelectablePhoto {
    return photos[selected]
  }
}
