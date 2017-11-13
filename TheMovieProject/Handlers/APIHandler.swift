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
    
    let videosBaseUrl = "https://www.youtube.com/watch?v="
    let requestBaseUrl = "https://api.themoviedb.org/"
    let getPlayingNowMoviesUrlConst = "3/movie/now_playing?"
    let APIKey = "api_key=8733c01dbdcb1ed64534dd396e5ee532"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w300"
    
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
                    print(data)
                    let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    let movies = results!["results"] as? [[String:AnyObject]]
                    var myMovie : Movie
                    if let movies = movies {
                        for movie in movies {
                            myMovie = Movie(title: movie["title"] as! String,
                                            id: movie["id"] as! Int,
                                            image: movie["poster_path"] as? String,
                                            voteAvg: movie["vote_average"] as? Float,
                                            overview: movie["overview"] as? String,
                                            //genres: movie["genre_ids"] as! [Int],
                                            genres: nil,
                                            releaseDate: movie["release_date"] as? String,
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
    
}
