//
//  UIImageView+Extensions.swift
//  Desk360
//
//  Created by OsmanYıldırım on 22.06.2022.
//

import UIKit
import Alamofire

extension UIImageView {
    func setImage(url: String?, placeHolderImage: UIImage?) {
        guard let imageUrl = url else {
            DispatchQueue.main.async {
                self.image = placeHolderImage
            }
            return
        }

        AF.request(imageUrl, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
                DispatchQueue.main.async {
                    self.image = UIImage(data: responseData!, scale: 1)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.image = placeHolderImage
                }
            }
        }
    }
}
