//
//  Movies.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import Foundation
class Movie: Media {
    var videos : [Video]?
    
    init(title : String, id : Int, releaseDate : String, image : String?, voteAvg : Float?, overview : String?, genres : [Int]?, videos : [Video]?) {
        
        self.videos = videos
        
        super.init(title: title, id: id, image: image, voteAvg: voteAvg, overview: overview, genres: genres, releaseDate: releaseDate)
    }
}
