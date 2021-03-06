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
    let getPopularMoviesUrlConst = "3/movie/popular?"
    let getPopularSeriesesUrlConst = "3/tv/popular?"
    let getOnAirSeriesUrlConst = "3/tv/on_the_air?"
    let getMovieGenresConst = "3/genre/movie/list?"
    let getSeriesGenresConst = "3/genre/tv/list?"
    let getSeriesDetailesConst = "3/tv/"
    let getSeasonDetailesConst = "season/"
    let searchMoviesConst = "3/search/movie?"
    let searchSeriesConst = "3/search/tv?"
    let videoBaseConst = "3/movie/"
    let videoArgumentsConst = "/videos?"
    
    
    let queryStringConst = "&query="
    
    let imageBaseUrl = "https://image.tmdb.org/t/p/w300"
    let youtubeBaseUrl = "https://www.youtube.com/watch?v="
    
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
    
    //TODO: Replace with an Extension
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
                completion()
            }.resume()
        }
    }
    
    func getNumOfSeasonsForSearch(completion : @escaping ()->()) {
        for media in AppManager.shared.searchResults{
            if media is Series{
                let series = media as! Series
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
                    completion()
                }.resume()
            }
        }
    }
    
    func getPopularMovies(completion : @escaping ()->()) {
        
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.getPopularMoviesUrlConst)\(APIHandler.shared.APIKey)"
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
                                            genres: movie["genre_ids"] as? [Int],
                                            //videos: movie["vote_average"] as! Float
                                            videos: nil)
                            AppManager.shared.popularMovies.append(myMovie)
                        }
                    }
                    completion()
                }
            }
        }.resume()
        
    }
    
    func getPopularSerieses(completion : @escaping ()->()) {
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.getPopularSeriesesUrlConst)\(APIHandler.shared.APIKey)"
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
                            AppManager.shared.popularSerieses.append(mySeries)
                        }
                    }
                    completion()
                }
            }
        }.resume()
    }
    
    func searchSeries(query : String ,completion : @escaping ()->()) {
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.searchSeriesConst)\(APIHandler.shared.APIKey)\(APIHandler.shared.queryStringConst)\(query)"
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
                            AppManager.shared.searchResults.append(mySeries)
                        }
                    }
                    completion()
                }
            }
        }.resume()
    }
    
    func searchMovie(query : String ,completion : @escaping ()->()) {
        
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.searchMoviesConst)\(APIHandler.shared.APIKey)\(APIHandler.shared.queryStringConst)\(query)"
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
                                            //videos: movie["vote_average"] as! Float
                                            videos: nil)
                            AppManager.shared.searchResults.append(myMovie)
                        }
                    }
                    completion()
                }
            }
        }.resume()
        
    }
    
    func getMovieVideos(movie : Movie ,completion : @escaping ()->()) {
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.videoBaseConst)\(movie.id)\(APIHandler.shared.videoArgumentsConst)\(APIHandler.shared.APIKey)"
        let url = URL(string: urlStr)!
        var movieVideos : [Video] = []
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let data = data {
                    let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    let videos = results!["results"] as? [[String:AnyObject]]
                    if let videos = videos {
                        for video in videos {
                            let newVideo = Video(id: video["id"] as! String, name: video["name"] as! String, url: video["key"] as! String)
                            movieVideos.append(newVideo)
                        }
                        movie.videos = movieVideos
                    }
                    completion()
                }
            }
        }.resume()
    }
    
    //getSeasonEpisodes
    func getSeasonEpisodes(series : Series, seasonIndex : Int ,completion : @escaping ()->()) {
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.getSeriesDetailesConst)\(series.id)/\(APIHandler.shared.getSeasonDetailesConst)\(series.seasons![seasonIndex].number)?\(APIHandler.shared.APIKey)"
        let url = URL(string: urlStr)!
        print(urlStr)
        var seasonEpisodes : [Episode] = []
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let data = data {
                    let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    let episodes = results!["episodes"] as? [[String:AnyObject]]
                    if let episodes = episodes {
                        for episode in episodes {
                            let newEpisode = Episode(id: episode["id"] as! Int, number: episode["episode_number"] as! Int, name: episode["name"] as! String, airDate: episode["air_date"] as? String, image: episode["still_path"] as? String, overview: episode["overview"] as! String)
                            seasonEpisodes.append(newEpisode)
                        }
                        series.seasons![seasonIndex].episodes = seasonEpisodes
                    }
                    completion()
                }
            }
        }.resume()
    }
    
    //getSeriesSeasons
    func getSeriesSeasons(series : Series ,completion : @escaping ()->()) {
        let urlStr = "\(APIHandler.shared.requestBaseUrl)\(APIHandler.shared.getSeriesDetailesConst)\(series.id)?\(APIHandler.shared.APIKey)"
        let url = URL(string: urlStr)!
        var seriesSeasons : [Season] = []
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let data = data {
                    let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    let seasons = results!["seasons"] as? [[String:AnyObject]]
                    if let seasons = seasons {
                        for season in seasons {
                            let newSeason = Season(id: season["id"] as! Int, number: season["season_number"] as! Int, image: season["poster_path"] as? String, releaseDate: season["air_date"] as? String, episodes: nil)
                            seriesSeasons.append(newSeason)
                        }
                        series.seasons = seriesSeasons
                    }
                    completion()
                }
            }
        }.resume()
    }
    
    
}
