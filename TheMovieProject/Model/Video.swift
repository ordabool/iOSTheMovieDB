//
//  Video.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import Foundation
class Video {
    let id : String
    let url : URL?
    let name : String
    init(id : String, name : String, url : String) {
        self.id = id
        self.name = name
        self.url = APIHandler.shared.convertStringToUrl(str: url, append: APIHandler.shared.youtubeBaseUrl)
    }
}
