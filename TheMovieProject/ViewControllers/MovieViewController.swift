//
//  MovieViewController.swift
//  TheMovieProject
//
//  Created by Or Dabool on 2011//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var movie : Movie? = nil
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndex = movieTableView.indexPathForSelectedRow {
            movieTableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIHandler.shared.getMovieVideos(movie: movie!, completion: {
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let videos = movie?.videos{
            return videos.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let newCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as! MovieDefaultTableViewCell
            if let movie = movie {
                
                if AppManager.shared.movieGenres.isEmpty{
                    APIHandler.shared.getMovieGenres {
                        DispatchQueue.main.async {
                            var genresText = ""
                            if let genres = movie.genres{
                                for genre in genres{
                                    for genreKey in AppManager.shared.movieGenres{
                                        if (genreKey[genre] != nil){
                                            genresText += "| \(genreKey[genre]!) "
                                        }
                                    }
                                }
                            }
                            genresText += "|"
                            newCell.genresLabel.text = genresText
                        }
                    }
                }
                
                newCell.movieTitle.text = movie.title
                newCell.avgRatingLabel.text = String(describing: movie.voteAvg!)
                newCell.releaseDateLabel.text = movie.releaseDate
                newCell.overviewLabel.text = movie.overview
                if let imageUrl = movie.imageUrl{
                    APIHandler.shared.getImageFromUrl(url: imageUrl, targetImageView: newCell.movieImageView)
                } else {
                    newCell.movieImageView.image = nil
                }
                if !AppManager.shared.movieGenres.isEmpty{
                    var genresText = ""
                    if let genres = movie.genres{
                        for genre in genres{
                            for genreKey in AppManager.shared.movieGenres{
                                if (genreKey[genre] != nil){
                                    genresText += "| \(genreKey[genre]!) "
                                }
                            }
                        }
                    }
                    genresText += "|"
                    newCell.genresLabel.text = genresText
                }
            }
            return newCell
        } else {
            let newCell = tableView.dequeueReusableCell(withIdentifier: "videoCell")
            newCell?.textLabel?.text = movie?.videos![indexPath.row-1].name
            return newCell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open((movie?.videos![indexPath.row-1].url)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL((movie?.videos![indexPath.row-1].url)!)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
