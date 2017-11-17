//
//  APIHandler.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit
class APIHandler {
    static let shared = APIHandler()
    

    let requestBaseUrl = "https://api.themoviedb.org/"
    let APIKey = "api_key=8733c01dbdcb1ed64534dd396e5ee532"
    
    let getPlayingNowMoviesUrlConst = "3/movie/now_playing?"
    let getOnAirSeriesUrlConst = "3/tv/on_the_air?"
    let getMovieGenresConst = "3/genre/movie/list?"
    let getSeriesGenresConst = "3/genre/tv/list?"
    let getSeriesDetailesConst = "3/tv/"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w300"
    let videosBaseUrl = "https://www.youtube.com/watch?v="
    
    //A function to convert Strings to URLs
    func convertStringToUrl(str : String?, append : String) -> URL? {
        if let str = str {
            let srcUrl = "\(append)\(str)"
            if let myURL = URL(string: srcUrl){
                return myURL
            }
        }
        return nil
    }
    
    func getImageFromUrl(url : URL, targetImageView : UIImageView){
        URLSession.shared.dataTask(with: url, completionHandler: { (data, urlRes, err) in
            if let validData = data {
                if err == nil{
                    let myImage = UIImage(data: validData)
                    DispatchQueue.main.async {
                        targetImageView.image = myImage
                    }
                }
            }
        }).resume()
    }
    
    func getNowPlayingMovies(completion : @escaping ()->()) {
        
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.getPlayingNowMoviesUrlConst)\(APIHandler.shared.APIKey)"
        let url = URL(string: urlStr)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let data = data {
                    let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    let movies = results!["results"] as? [[String:AnyObject]]
                    var myMovie : Movie
                    if let movies = movies {
                        for movie in movies {
                            myMovie = Movie(title: movie["title"] as! String,
                                            id: movie["id"] as! Int,
                                            releaseDate: movie["release_date"] as! String,
                                            image: movie["poster_path"] as? String,
                                            voteAvg: movie["vote_average"] as? Float,
                                            overview: movie["overview"] as? String,
                                            //genres: movie["genre_ids"] as! [Int],
                                            genres: movie["genre_ids"] as? [Int],
                                            //runtime: movie["vote_average"] as! Float,
                                            runtime: nil,
                                            //videos: movie["vote_average"] as! Float
                                            videos: nil)
                            AppManager.shared.nowPlayingMovies.append(myMovie)
                        }
                    }
                    completion()
                }
            }
        }.resume()
        
    }
    
    func getOnAirSeries(completion : @escaping ()->()) {
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.getOnAirSeriesUrlConst)\(APIHandler.shared.APIKey)"
        let url = URL(string: urlStr)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let data = data {
                    let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    let serieses = results!["results"] as? [[String:AnyObject]]
                    var mySeries : Series
                    if let serieses = serieses {
                        for series in serieses {
                            mySeries = Series(title: series["name"] as! String,
                                              id: series["id"] as! Int,
                                              releaseDate: series["first_air_date"] as! String,
                                              image: series["poster_path"] as? String,
                                              voteAvg: series["vote_average"] as? Float,
                                              overview: series["overview"] as? String,
                                              genres: series["genre_ids"] as? [Int],
                                              seasons: nil,
                                              numberOfSeasons : nil)
                            AppManager.shared.onAirSerieses.append(mySeries)
                        }
                    }
                    completion()
                }
            }
            }.resume()
    }
    
    func getSeriesGenres(completion : @escaping ()->()) {
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.getSeriesGenresConst)\(APIHandler.shared.APIKey)"
        let url = URL(string: urlStr)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let data = data {
                    let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    let genres = results!["genres"] as? [[String:AnyObject]]
                    for genre in genres! {
                        let newGenre = [genre["id"] as! Int : genre["name"] as! String]
                        AppManager.shared.seriesGenres.append(newGenre)
                    }
                    completion()
                }
            }
            }.resume()
    }
    
    func getMovieGenres(completion : @escaping ()->()) {
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.getMovieGenresConst)\(APIHandler.shared.APIKey)"
        let url = URL(string: urlStr)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let data = data {
                    let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    let genres = results!["genres"] as? [[String:AnyObject]]
                    for genre in genres! {
                        let newGenre = [genre["id"] as! Int : genre["name"] as! String]
                        AppManager.shared.movieGenres.append(newGenre)
                    }
                    completion()
                }
            }
        }.resume()
    }
    
    func getNumOfSeasons(completion : @escaping ()->()) {
        for series in AppManager.shared.onAirSerieses{
            let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.getSeriesDetailesConst)\(series.id)?\(APIHandler.shared.APIKey)"
            let url = URL(string: urlStr)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    if let data = data {
                        let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                        let seasons = results!["number_of_seasons"] as! Int
                        series.numberOfSeasons = seasons
                    }
                }
            }.resume()
        }
        completion()
    }
    
}
