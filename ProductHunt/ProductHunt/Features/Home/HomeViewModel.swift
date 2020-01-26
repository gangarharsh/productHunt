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
    typealias DataReceived      = () -> ()
    typealias ErrorFetchingData = () -> ()
    typealias ShowLoader        = () -> ()
    typealias HideLoader        = () -> ()
    typealias goToCommentsVc    = (_ viewModel:CommentsViewModel) -> ()
    
    private(set) var postsData : PostsData?
    var postsReceived: DataReceived?
    var errorFetchingPosts:ErrorFetchingData?
    var showLoader:ShowLoader?
    var hideLoader:HideLoader?
    var goToCommentsViewController :goToCommentsVc?
    var arrayDataSource = [PostViewModel]()
    
    init() {
        
    }
    
    func performSearch(_ text:String){
        let filteredPosts = self.postsData?.posts?.filter({
            return ($0.name?.lowercased().contains(text.lowercased()) ?? true)
        })
        self.makeDataSource(postsArray: filteredPosts)
        self.postsReceived?()
    }
    
    
    func getPosts(){
        if Reachability.isConnectedToNetwork(){
            self.showLoader?()
            PostsAPI.shared.fetchPost(from: .posts) { (result) in
                self.hideLoader?()
                switch result {
                case .success(let data):
                    self.postsData = data
                    DatabaseManager.deleteAllEntitiesForEntityName(name: "Posts")
                    if let posts:Posts = NSEntityDescription.insertNewObject(forEntityName: "Posts", into: DatabaseManager.managedContext) as? Posts{
                        let postsDict = try? data.asDictionary() as NSObject
                        posts.data = postsDict
                        DatabaseManager.saveDbContext()
                        self.makeDataSource(postsArray: self.postsData?.posts)
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
                        self.postsData = try jsondecoder.decode(PostsData.self, from: jsonData)
                        self.makeDataSource(postsArray: self.postsData?.posts)
                        self.postsReceived?()
                    } catch let error{
                        print("error \(error)")
                        self.errorFetchingPosts?()
                    }}
            }
        }
    }
    
    func getPosts(forDate:Date){
        let formatter           = DateFormatter()
        formatter.dateFormat    = "YYYY-MM-DD"
        let selectedDate        = forDate
        let formattedDate       = formatter.string(from: selectedDate)
        if Reachability.isConnectedToNetwork()
        {
            self.showLoader?()
            PostsAPI.shared.fetchPostForDate(from: .posts, date: formattedDate, result: { (result) in
                self.hideLoader?()
                switch result {
                case .success(let data):
                    self.postsData = data
                    self.makeDataSource(postsArray: self.postsData?.posts)
                    self.postsReceived?()
                case .failure(let error):
                    print(error.description)
                    
                }
            })
        }else{
            
        }
    }
    
    func gotToCommentsVc(for indexPath:IndexPath){
        let vm = self.arrayDataSource[indexPath.row]
        let commentsVM = CommentsViewModel(postVm: vm)
        self.goToCommentsViewController?(commentsVM)
    }
    
    func makeDataSource(postsArray: [Post]?){
        self.arrayDataSource.removeAll()
        for post in postsArray ?? []{
            let viewModel = PostViewModel(post: post)
            self.arrayDataSource.append(viewModel)
        }
    }
    
    var postCount : Int{
        return self.arrayDataSource.count
    }
}


class PostViewModel{
    private(set) var postObj :Post?

    init(post:Post) {
        self.postObj = post
    }
    
    var postId:Int{
        return self.postObj?.id ?? 0
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
