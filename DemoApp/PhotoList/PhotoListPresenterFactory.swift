//
//  PhotoListPresenterFactory.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 29/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

class PhotoListPresenterFactory {

  let presenter: PhotoListPresenter!

  init(view: PhotoListViewProtocol, source: PhotoSource) {
    var sourceAdapter: PhotoListAdapter!

    switch source {
      case .library:
        sourceAdapter = PhotoLibraryManager()
      case .unsplash:
        sourceAdapter = UnsplashService()
    }
    presenter = PhotoListPresenter(view, source: sourceAdapter)
  }
}
