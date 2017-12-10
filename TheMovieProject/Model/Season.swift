//
//  Season.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import Foundation
class Season {
    let id : Int
    let number : Int
    var imageUrl : URL?
    let releaseDate : String?
    var episodes : [Episode]?
    
    init(id : Int, number : Int, image : String?, releaseDate : String?, episodes : [Episode]?) {
        self.id = id
        self.number = number
        self.episodes = episodes
        self.releaseDate = releaseDate
        self.imageUrl = APIHandler.shared.convertStringToUrl(str: image, append: APIHandler.shared.imageBaseUrl)
    }
}
