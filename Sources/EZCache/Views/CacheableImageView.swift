//
//  CacheableImageView.swift
//  
//
//  Created by Matt Roberts on 26/01/2020.
//

import Foundation

#if canImport(UIKit)
import UIKit



@available(iOS 9.0, *)
class CacheableImageView: UIView {
  
  enum FetchError: LocalizedError {
    case invalidURL
  }
  
  private enum LayoutError: LocalizedError {
    case invalidConstraint
  }
  
  var imageView: UIImageView?
  
  let dataFetcher = DataFetcher<CacheableImage>()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    createImageViewIfNeeded()
  }
  
  // Might complain
  private func createImageViewIfNeeded() {
    if imageView == nil {
      imageView = UIImageView(frame: .zero)
      self.addSubview(imageView!)
      imageView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
      imageView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
      imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
      imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
  }
  
  private func setupImageViewConstraints() throws {
    // If the UIImageView has an image, set the constraints on the UIImage to match the parents size
    guard let imageView = self.imageView else { throw LayoutError.invalidConstraint }
    self.addSubview(imageView)
    
  }
  
  func fetchImage(from stringURL: String) throws {
    guard let url = URL(string: stringURL) else { throw FetchError.invalidURL }
    fetchImage(from: url)
  }
  
  func fetchImage(from url: URL) {
    self.dataFetcher.fetch(from: url) { (result) in
      switch result {
      case .success(let image):
        self.imageView?.image = image.rawValue
      case .failure(let error):
        print("ImageFetcher Error: \(error)")
      }
    }
  }
}
#endif
