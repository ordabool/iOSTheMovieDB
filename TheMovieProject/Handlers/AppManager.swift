//
//  AppManager.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import Foundation
class AppManager{
    
    static let shared = AppManager()
    var nowPlayingMovies : [Movie] = []
    var onAirSerieses : [Series] = []
    var popularMovies : [Movie] = []
    var popularSerieses : [Series] = []
    var seriesGenres : [[Int:String]] = []
    var movieGenres : [[Int:String]] = []
    var searchResults : [Media] = []
    var moviesLoaded = false
    var seriesesLoaded = false
    var seasonsNumberLoaded = false
    var popularMoviesLoaded = false
    var popularSeriesesLoaded = false
    var searchSeriesesEnded = false
    var searchMoviesEnded = false
    
}
