//
//  PostAPI.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 21/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation
class PostsAPI {
    
    public static let shared = PostsAPI()
    private init() {}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://api.producthunt.com/v1")!
    private let apiKey = "Bearer eB3m5CCAqw4S3XAvVXA47IKIW9JrOxhtmyuN4qtiraw"
    private let jsonDecoder: JSONDecoder = {
       let jsonDecoder = JSONDecoder()
       jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-mm-dd"
       jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
       return jsonDecoder
    }()
    
    
    enum Endpoint: String, CaseIterable {
        case posts
        case comments
    }
    
    public enum APIServiceError: Error, CustomStringConvertible {
        public var description: String{
            switch self {
            case .apiError          : return "api error"
            case .invalidEndpoint   : return "invalidEndpoint"
            case .invalidResponse   : return "invalidResponse"
            case .noData            : return "noData"
            case .decodeError       : return "decodeError"
            }
        }
        
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
        
        
    }
    
    public enum RequestType : String{
        case get    = "GET"
        case post   = "POST"
    }
    
    private func fetchResources<T: Decodable>(url: URL, method:RequestType,
                                              completion: @escaping (Result<T, APIServiceError>) -> Void)
    {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("api.producthunt.com", forHTTPHeaderField: "Host")

        
        urlSession.dataTask(with: request) { (result) in
            switch result {
                case .success(let (response, data)):
                    print("response \(response)")
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    do {
                        let values = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(values))
                    } catch let error{
                        print("error \(error)")
                        completion(.failure(.decodeError))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(.apiError))
                }
         }.resume()
    }
    
    func fetchPost(from endpoint:Endpoint, result: @escaping (Result<PostsData,APIServiceError>)-> Void){
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        fetchResources(url: url, method: .get, completion: result)
    }
    
    func fetchPostForDate(from endpoint:Endpoint, date:String, result: @escaping (Result<PostsData,APIServiceError>)-> Void){
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),  let urlObj = urlComponents.url{
            var queryItems: [URLQueryItem]  = urlComponents.queryItems ??  []
            let query                       = URLQueryItem(name: "day", value: date)
            queryItems.append(query)
            urlComponents.queryItems        = queryItems
            fetchResources(url: urlObj, method: .get, completion: result)

        }else{
            result(.failure(.invalidEndpoint))
        }
    }
    
    func fetchComments(for postObjId:Int?, page:Int?, result: @escaping (Result<Comments,APIServiceError>)-> Void){
        let endpoint = Endpoint.comments
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),  let _ = urlComponents.url, let pageNumber = page, let postId = postObjId
        {
            var queryItems: [URLQueryItem]  = urlComponents.queryItems ??  []
            let postId                      = URLQueryItem(name: "post_id", value: "\(postId)")
            queryItems.append(postId)
            let pageQuery                   = URLQueryItem(name: "per_page", value: "5")
            queryItems.append(pageQuery)
            let query                       = URLQueryItem(name: "page", value: "\(pageNumber)")
            queryItems.append(query)
            urlComponents.queryItems        = queryItems
            if let urlObj = urlComponents.url{
                fetchResources(url: urlObj, method: .get, completion: result)
            }
            
        }else{
            result(.failure(.invalidEndpoint))
        }        
    }
}
