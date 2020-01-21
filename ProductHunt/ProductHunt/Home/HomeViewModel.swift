//
//  HomeViewModel.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 20/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation
import CoreData

class HomeViewModel {
    typealias DataReceived = () -> ()
    typealias ErrorFetchingData = () -> ()
    private(set) var postsData : PostsData?
    var postsReceived: DataReceived?
    var errorFetchingPosts:ErrorFetchingData?
    var arrayDataSource = [PostViewModel]()
    
    init() {
        
    }
    
    func getPosts(){
        if Reachability.isConnectedToNetwork(){
            PostsAPI.shared.fetchPost(from: .posts) { (result) in
                switch result {
                case .success(let data):
                    self.postsData = data
                    DatabaseManager.deleteAllEntitiesForEntityName(name: "Posts")
                    if let posts:Posts = NSEntityDescription.insertNewObject(forEntityName: "Posts", into: DatabaseManager.managedContext) as? Posts{
                        let postsDict = try? data.asDictionary() as NSObject
                        posts.data = postsDict
                        DatabaseManager.saveDbContext()
                        self.makeDataSource()
                        self.postsReceived?()
                    }
                case .failure(let error):
                    print(error.description)
                }
            }
        }else{
            let savedPosts = DatabaseManager.getEntitesForEntityName(name: "Posts")
            if savedPosts.count > 0{
                let offlinePostOnk = savedPosts.last as? Posts
                if let data = offlinePostOnk?.data
                {
                    do {
                    let jsondecoder = JSONDecoder()
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    self.postsData = try jsondecoder.decode(PostsData.self, from: jsonData as! Data)
                    self.makeDataSource()
                    self.postsReceived?()
                } catch let error{
                    print("error \(error)")
                    self.errorFetchingPosts?()
                }}
            }
        }
    }
    
    func makeDataSource(){
        self.arrayDataSource.removeAll()
        for post in self.postsData?.posts ?? []{
            let viewModel = PostViewModel(post: post)
            self.arrayDataSource.append(viewModel)
        }
    }
    
    var postCount : Int{
        return self.postsData?.posts?.count ?? 0
    }
}

class PostViewModel{
    var postObj :Post?
    
    init(post:Post) {
        self.postObj = post
    }
    
    var name:String{
        return self.postObj?.name ?? ""
    }
    
    var tagline: String {
        return self.postObj?.tagline ?? ""
    }
    
    var imageURL:String{
        return self.postObj?.thumbnail?.imageURL ?? ""
    }
}
