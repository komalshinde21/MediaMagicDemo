//
//  PhotoInfo.swift
//  MediaMagicDemo1
//
//  Created by Komal Shinde on 31/05/20.
//  Copyright © 2020 Komal Shinde. All rights reserved.
//

import Foundation

struct PhotoInfoModel : Codable {
    let format : String?
    let width : Int?
    let height : Int?
    let filename : String?
    let id : Int?
    let author : String?
    let authorUrl : String?
    let postUrl : String?

    enum CodingKeys: String, CodingKey {

        case format = "format"
        case width = "width"
        case height = "height"
        case filename = "filename"
        case id = "id"
        case author = "author"
        case authorUrl = "author_url"
        case postUrl = "post_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        format = try values.decodeIfPresent(String.self, forKey: .format)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        filename = try values.decodeIfPresent(String.self, forKey: .filename)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        authorUrl = try values.decodeIfPresent(String.self, forKey: .authorUrl)
        postUrl = try values.decodeIfPresent(String.self, forKey: .postUrl)
    }

}
