//
//  imageView.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 22/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func downloadImage(from url: URL){
        let urlSession = URLSession.shared
        print("Download Started")
        urlSession.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}
