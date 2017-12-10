//
//  Media.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import Foundation
class Media {
    let id : Int
    let title : String
    var imageUrl : URL?
    let voteAvg : Float?
    let overview : String?
    let genres : [Int]?
    let releaseDate : String?
    
    init(title : String, id : Int) {
        self.title = title
        self.id = id
        self.imageUrl = nil
        self.voteAvg = nil
        self.overview = nil
        self.genres = nil
        self.releaseDate = nil
    }
    
    init(title : String, id : Int, image : String?, voteAvg : Float?, overview : String?, genres : [Int]?, releaseDate : String) {
        self.title = title
        self.id = id
        self.releaseDate = releaseDate
        self.voteAvg = voteAvg
        self.overview = overview
        self.genres = genres
        self.imageUrl = APIHandler.shared.convertStringToUrl(str: image, append: APIHandler.shared.imageBaseUrl)
    }
    
}
