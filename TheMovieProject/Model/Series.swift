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
    init(title : String, id : Int, image : String?, voteAvg : Float?, overview : String?, genres : [String]?, seasons : [Season]?) {
        self.seasons = seasons
        super.init(title: title, id: id, image: image, voteAvg: voteAvg, overview: overview, genres: genres)
    }
}
