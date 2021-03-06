
//
//  Episode.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import Foundation
class Episode {
    let id : Int
    let number : Int
    let name : String
    let airDate : String?
    var imageUrl : URL?
    let overview : String
    
    init(id : Int, number : Int, name : String, airDate : String?, image : String?, overview : String) {
        self.airDate = airDate
        self.id = id
        self.name = name
        self.number = number
        self.overview = overview
        self.imageUrl = APIHandler.shared.convertStringToUrl(str: image, append: APIHandler.shared.imageBaseUrl)
    }
}
