//
//  URLSession.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 20/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation
extension URLSession {
    func dataTask(with request:URLRequest, result: @escaping (Result<(URLResponse,Data), Error>)-> Void) -> URLSessionDataTask{
        return dataTask(with: request){ (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }   
}
