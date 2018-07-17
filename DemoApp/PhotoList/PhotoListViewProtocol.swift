//
//  PhotoListViewProtocol.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

protocol PhotoListViewProtocol {
  func setup(title: String)
  func updateCollectionView()
  func show(_ error: String)
  func showLoading()
  func hideLoading()
  func doneButton(enable: Bool)
}
