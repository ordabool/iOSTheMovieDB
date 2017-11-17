//
//  Series.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import Foundation
class Series : Media {
    var seasons : [Season]?
    var numberOfSeasons : Int?
    init(title : String, id : Int, releaseDate : String, image : String?, voteAvg : Float?, overview : String?, genres : [Int]?, seasons : [Season]?, numberOfSeasons : Int?) {
        self.seasons = seasons
        self.numberOfSeasons = numberOfSeasons
        super.init(title: title, id: id, image: image, voteAvg: voteAvg, overview: overview, genres: genres, releaseDate: releaseDate)
    }
}
