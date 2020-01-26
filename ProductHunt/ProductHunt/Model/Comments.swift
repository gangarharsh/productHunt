//
//  Comments.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 26/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation

// MARK: - Comments
// MARK: - Comments
struct Comments: Codable {
    let comments: [Comment]?
}

// MARK: - Comment
struct Comment: Codable {
    let id: Int?
    let body, createdAt, parentCommentID: String?
    let userID, subjectID, childCommentsCount: Int?
    let url: String?
    let postID: Int?
    let subjectType: String?
    let sticky: Bool?
    let votes: Int?
    let post: Post?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id, body
        case createdAt = "created_at"
        case parentCommentID = "parent_comment_id"
        case userID = "user_id"
        case subjectID = "subject_id"
        case childCommentsCount = "child_comments_count"
        case url
        case postID = "post_id"
        case subjectType = "subject_type"
        case sticky, votes, post, user
    }
}
