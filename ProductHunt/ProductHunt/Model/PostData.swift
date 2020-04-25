//
//  PostData.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 21/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation
// MARK: - PostsData
struct PostsData: Codable {
    let posts: [Post]?

    enum CodingKeys: String, CodingKey {
        case posts = "posts"
    }
}

// MARK: - Post
struct Post: Codable {
    let commentsCount: Int?
    let id: Int?
    let name: String?
    let productState: String?
    let tagline: String?
    let slug: String?
    let votesCount: Int?
    let day: String?
    let categoryID: String?
    let createdAt: String?
    let currentUser: CurrentUser?
    let discussionURL: String?
    let exclusive: String?
    let featured: Bool?
    let iosFeaturedAt: Bool?
    let makerInside: Bool?
    let makers: [User]?
    let platforms: [String]?
    let redirectURL: String?
    let screenshotURL: ScreenshotURL?
    let thumbnail: Thumbnail?
    let topics: [Topic]?
    let user: User?
    let name_test : String?

    enum CodingKeys: String, CodingKey {
        case commentsCount = "comments_count"
        case id = "id"
        case name = "name"
        case productState = "product_state"
        case tagline = "tagline"
        case slug = "slug"
        case votesCount = "votes_count"
        case day = "day"
        case categoryID = "category_id"
        case createdAt = "created_at"
        case currentUser = "current_user"
        case discussionURL = "discussion_url"
        case exclusive = "exclusive"
        case featured = "featured"
        case iosFeaturedAt = "ios_featured_at"
        case makerInside = "maker_inside"
        case makers = "makers"
        case platforms = "platforms"
        case redirectURL = "redirect_url"
        case screenshotURL = "screenshot_url"
        case thumbnail = "thumbnail"
        case topics = "topics"
        case user = "user"
    }
}

// MARK: - CurrentUser
struct CurrentUser: Codable {
    let votedForPost: Bool?
    let commentedOnPost: Bool?

    enum CodingKeys: String, CodingKey {
        case votedForPost = "voted_for_post"
        case commentedOnPost = "commented_on_post"
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let createdAt: String?
    let name: String?
    let username: String?
    let headline: String?
    let twitterUsername: String?
    let websiteURL: String?
    let profileURL: String?
    let imageURL: ImageURL?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case name = "name"
        case username = "username"
        case headline = "headline"
        case twitterUsername = "twitter_username"
        case websiteURL = "website_url"
        case profileURL = "profile_url"
        case imageURL = "image_url"
    }
}

// MARK: - ImageURL
struct ImageURL: Codable {
    let the30Px: String?
    let the32Px: String?
    let the40Px: String?
    let the44Px: String?
    let the48Px: String?
    let the50Px: String?
    let the60Px: String?
    let the64Px: String?
    let the73Px: String?
    let the80Px: String?
    let the88Px: String?
    let the96Px: String?
    let the100Px: String?
    let the110Px: String?
    let the120Px: String?
    let the132Px: String?
    let the146Px: String?
    let the160Px: String?
    let the176Px: String?
    let the220Px: String?
    let the264Px: String?
    let the32Px2X: String?
    let the40Px2X: String?
    let the44Px2X: String?
    let the88Px2X: String?
    let the32Px3X: String?
    let the40Px3X: String?
    let the44Px3X: String?
    let the88Px3X: String?
    let original: String?

    enum CodingKeys: String, CodingKey {
        case the30Px = "30px"
        case the32Px = "32px"
        case the40Px = "40px"
        case the44Px = "44px"
        case the48Px = "48px"
        case the50Px = "50px"
        case the60Px = "60px"
        case the64Px = "64px"
        case the73Px = "73px"
        case the80Px = "80px"
        case the88Px = "88px"
        case the96Px = "96px"
        case the100Px = "100px"
        case the110Px = "110px"
        case the120Px = "120px"
        case the132Px = "132px"
        case the146Px = "146px"
        case the160Px = "160px"
        case the176Px = "176px"
        case the220Px = "220px"
        case the264Px = "264px"
        case the32Px2X = "32px@2X"
        case the40Px2X = "40px@2X"
        case the44Px2X = "44px@2X"
        case the88Px2X = "88px@2X"
        case the32Px3X = "32px@3X"
        case the40Px3X = "40px@3X"
        case the44Px3X = "44px@3X"
        case the88Px3X = "88px@3X"
        case original = "original"
    }
}

// MARK: - ScreenshotURL
struct ScreenshotURL: Codable {
    let the300Px: String?
    let the850Px: String?

    enum CodingKeys: String, CodingKey {
        case the300Px = "300px"
        case the850Px = "850px"
    }
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let id: Int?
    let mediaType: String?
    let imageURL: String?
    let metadata: Metadata?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case mediaType = "media_type"
        case imageURL = "image_url"
        case metadata = "metadata"
    }
}

// MARK: - Metadata
struct Metadata: Codable {
}

// MARK: - Topic
struct Topic: Codable {
    let id: Int?
    let name: String?
    let slug: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case slug = "slug"
    }
}
