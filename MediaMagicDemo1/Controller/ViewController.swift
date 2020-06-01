//
//  ViewController.swift
//  MediaMagicDemo1
//
//  Created by Komal Shinde on 31/05/20.
//  Copyright © 2020 Komal Shinde. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModelPhotoInfo = PhotoInfoViewModel()
    var estimateWidth = 170.0
    var cellMarginSize = 16.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Lorem Picsum"
              
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let cellWidth = Float(screenWidth / 2.30)
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        let size = CGSize(width:Int(cellWidth), height: Int(cellWidth))
        layout.itemSize = size
        
        self.collectionView.collectionViewLayout = layout
        
        // Register cells
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        viewModelPhotoInfo.vc = self
        viewModelPhotoInfo.getAllPhotoIfo()

        // Set Delegates
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // SetupGrid view
        self.setupGridView()
        
    }
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           self.setupGridView()
       }

    override func didReceiveMemoryWarning() {
        
//        URLCache.shared.removeAllCachedResponses()
//        URLCache.shared.diskCapacity = 0
//        URLCache.shared.memoryCapacity = 0

    }

}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(viewModelPhotoInfo.arrPhotoInfo.count)
                return viewModelPhotoInfo.arrPhotoInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        let photoInfo = viewModelPhotoInfo.arrPhotoInfo[indexPath.row]
        let baseUrl = viewModelPhotoInfo.baseUrl
        cell?.authorLabel.text = photoInfo.author
        let photoPath = "id/"
        let photoUrl = "\(baseUrl)\(photoPath)\(photoInfo.id!)/\(photoInfo.width!)/\(photoInfo.height!).jpg"
        
        // Before assigning the image, check whether the current cell is visible
        if self.collectionView.cellForItem(at: indexPath) == nil {
            
            cell?.authorImg.loadImageUsingCache(withUrl: photoUrl)
        }
       
        return cell!
    }
    
    func setupGridView() {
           let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
           flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
           flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
       }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = self.calculateWith()
//        return CGSize(width: width, height: width)
//    }
    
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    
    func resizeImage(image: UIImage) -> UIImage{
        
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }

    
    
    
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }

            DispatchQueue.main.async {
                [weak self] in
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    // image here is your original image
                    let imgCompressed: UIImage? = self?.resizeImage(image: image)
                    self?.image = imgCompressed
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}
