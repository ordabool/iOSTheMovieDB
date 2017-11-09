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
    var episodes : [Episode]?
    
    init(id : Int, number : Int, image : String?, episodes : [Episode]?) {
        self.id = id
        self.number = number
        self.episodes = episodes
        self.imageUrl = AppManager.shared.convertStringToUrl(str: image)
    }
}
