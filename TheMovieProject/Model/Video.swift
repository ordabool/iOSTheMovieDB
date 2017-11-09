//
//  Video.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import Foundation
class Video {
    let id : Int
    let url : URL?
    let name : String
    init(id : Int, name : String, url : String) {
        self.id = id
        self.name = name
        let urlPath = "\(APIHandler.shared.videosBaseUrl)\(url)"
        self.url = AppManager.shared.convertStringToUrl(str: urlPath)
    }
}
