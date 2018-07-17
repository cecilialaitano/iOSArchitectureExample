//
//  PhotoListViewController.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import UIKit
import Photos

class PhotoListViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var loadingView: UIView!

  var selectedSource: PhotoSource!
  weak var delegate: ImagePickerDelegate?
  private let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
  private var presenter: PhotoListPresenter!
  private var doneButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = PhotoListPresenterFactory(view: self, source: selectedSource).presenter
    presenter.start(source: selectedSource)
    setupCollectionView()
    registerPreviewingDelegate()
    setupNavigationBar()
  }

  // MARK: - Initial Setup
  private func setupNavigationBar() {
    doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onTapSelectedDone))
    navigationItem.rightBarButtonItem = doneButton
    doneButton.isEnabled = false
    navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.navBarTitleColor()], for: .normal)
  }

  private func setupCollectionView() {
    collectionView.register(UINib(nibName: Constants.photoListReuseIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.photoListReuseIdentifier)
  }

  private func registerPreviewingDelegate() {
    if traitCollection.forceTouchCapability == .available {
      registerForPreviewing(with: self, sourceView: view)
    }
  }

  // MARK: - Actions
  @objc private func onTapSelectedDone() {
    if let photo = presenter.getSelectedItem() {
      delegate?.didSelectedPhoto(photo)
      navigationController?.popViewController(animated: true)
    }
  }
}

extension PhotoListViewController: PhotoListViewProtocol {

  func setup(title: String) {
    self.title = title
  }

  func updateCollectionView() {
    collectionView.reloadData()
  }

  func show(_ error: String) {
    //TODO: add implementation.
  }

  func showLoading() {
    loadingActivityIndicator.startAnimating()
    loadingView.isHidden = false
    collectionView.isHidden = true
  }

  func hideLoading() {
    loadingActivityIndicator.stopAnimating()
    loadingView.isHidden = true
    collectionView.isHidden = false
  }

  func doneButton(enable: Bool) {
    doneButton.isEnabled = enable
  }
}

extension PhotoListViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.getNumberOfItems()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.photoListReuseIdentifier, for: indexPath) as! PhotoListViewCell
    presenter.getThumbPhotoData(for: indexPath.row, completion: { imageData in
      DispatchQueue.main.async {
        if let image = UIImage(data: imageData) {
          cell.setup(image)
        }
      }
    })
    return cell
  }
}

extension PhotoListViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as? PhotoListViewCell
    cell?.isSelected = true
    cell?.backgroundColor = UIColor.teal()
    presenter.setSelected(row: indexPath.row)
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as? PhotoListViewCell
    cell?.isSelected = false
    cell?.backgroundColor = UIColor.white
  }
}

extension PhotoListViewController: UIViewControllerPreviewingDelegate {

  func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    guard let indexPath = collectionView.indexPathForItem(at: collectionView.convert(location, from: view)), let cell = collectionView.cellForItem(at: indexPath) as? PhotoListViewCell else {
      return nil
    }
    let photoDetail = storyboard?.instantiateViewController(withIdentifier: "PhotoListDetailViewController") as? PhotoListDetailViewController

    //set thumb until full size photo is load.
    if let thumb = cell.imageView.image {
      photoDetail?.setPhoto(thumb)
    }

    presenter.getFullPhotoData(for: indexPath.row, completion: { imageData in
      if let image = UIImage(data: imageData) {
        photoDetail?.setPhoto(image)
      }
    })

    photoDetail?.preferredContentSize = CGSize(width: 0, height: 400)

    guard let collectionSuperview = collectionView.superview else {
      return nil
    }

    previewingContext.sourceRect = collectionView.convert(cell.frame, to: collectionSuperview)
    return photoDetail
  }

  func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    show(viewControllerToCommit, sender: self)
  }
}

extension PhotoListViewController : UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = view.frame.width - (sectionInsets.left * 4)
    let photoSize = screenWidth / 3

    return CGSize(width: photoSize, height: photoSize)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
