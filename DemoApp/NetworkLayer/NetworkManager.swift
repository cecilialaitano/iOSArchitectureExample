//
//  NetworkManager.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

typealias NetworkManagerCompletion = (_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> ()

class NetworkManager {
  private var urlCache: URLCache!

  init() {
    urlCache = URLCache.shared
    urlCache.removeCachedResponses(since: Constants.cacheExpiresDate)
  }

  func request(_ endpoint: EndPoint, requestCompletion: @escaping NetworkManagerCompletion) {
    let session = URLSession.shared
    var request = URLRequest(url: endpoint.url)
    request.httpMethod = endpoint.httpMethod.rawValue

    // MARK: - Set headers
    request.setValue(Constants.versionHeaderValue, forHTTPHeaderField: Constants.versionHeaderKey)
    request.setValue(Constants.authorizationHeaderValue, forHTTPHeaderField: Constants.authorizationHeaderKey)
    request.cachePolicy = .returnCacheDataElseLoad

    //If the request has cache, return cache data.
    if let cachedURLResponse = urlCache.cachedResponse(for: request) {
      requestCompletion(cachedURLResponse.data, nil, nil)
      return
    }

    session.dataTask(with: request, completionHandler: { data, response, error in
      if let error = error {
        requestCompletion(nil, nil, error)
      }
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        //TODO:  handle all the cases for the different status code and provide customs error.
        requestCompletion(nil, nil, error)
        return
      }

      if let responseData = data {
        let cachedURLResponse = CachedURLResponse(response: httpResponse, data: responseData)
        self.urlCache.storeCachedResponse(cachedURLResponse, for: request)
        requestCompletion(responseData, nil, nil)
      }

    }).resume()
  }
}
