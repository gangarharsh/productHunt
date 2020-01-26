//
//  CommentsViewModel.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 26/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation
class  CommentsViewModel{
    private(set) var postViewModel : PostViewModel!
    private(set) var commentsArray : Comments!
    typealias DataReceived      = () -> ()
    var commentsReceived: DataReceived?
    var arrayDataSource = [CommentsCellViewModel]()
    init(postVm :PostViewModel) {
        self.postViewModel = postVm
    }
    private var currentPage = 0
    var shouldMakeAPI:Bool = true
    func getComments(){
        if shouldMakeAPI{
            PostsAPI.shared.fetchComments(for: self.postViewModel?.postId, page: currentPage) { (result) in
                switch result
                {
                case .success(let commentsData):
                    self.currentPage += 1
                    self.commentsArray = commentsData
                    self.makeDataSource(comments: commentsData.comments ?? [])
                    self.commentsReceived?()
                    if commentsData.comments?.count == 0{
                        self.shouldMakeAPI = false
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    var commentsCount :Int{
        return arrayDataSource.count
    }
    
    func makeDataSource(comments:[Comment]){
        for comment in self.commentsArray.comments ?? []
        {
            let commentCellVm = CommentsCellViewModel(commet: comment)
            self.arrayDataSource.append(commentCellVm)
        }
    }
}


class CommentsCellViewModel {
    private(set) var commentObj : Comment
    
    init(commet:Comment) {
        self.commentObj = commet
    }

    var body:String{
        return self.commentObj.body ?? ""
    }
    
    var user: String {
        return self.commentObj.user?.name ?? ""
    }
    
    var commentDate : String {
        return self.commentObj.createdAt ?? ""
        
    }
}
