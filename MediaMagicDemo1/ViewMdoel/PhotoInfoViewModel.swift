//
//  PhotoInfoViewModel.swift
//  MediaMagicDemo1
//
//  Created by Komal Shinde on 31/05/20.
//  Copyright © 2020 Komal Shinde. All rights reserved.
//

import Foundation

class PhotoInfoViewModel {
    
    weak var vc: ViewController?
    var arrPhotoInfo = [PhotoInfoModel]()
    var baseUrl = "https://picsum.photos/"

    func getAllPhotoIfo() {
        URLSession.shared.dataTask(with: URL(string: baseUrl + "list")!) { (data, reponse, error) in
            if error == nil {
                if let data = data {
                    do {
                        let urlResponse = try JSONDecoder().decode([PhotoInfoModel].self, from: data)
                        self.arrPhotoInfo.append(contentsOf: urlResponse)
                        DispatchQueue.main.async {
                            self.vc?.collectionView.reloadData()
                        }
                       // print(urlResponse)
                    }catch let err{
                        print(err.localizedDescription)
                    }
                }
            }else {
                print(error?.localizedDescription as Any)
            }
        }.resume()
    }
}
