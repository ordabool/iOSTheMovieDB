//
//  FeaturedResultsViewController.swift
//  TheMovieProject
//
//  Created by Or Dabool on 1711//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class FeaturedResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var result = ""
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if result == "movies" {
            if AppManager.shared.movieGenres.isEmpty {
                APIHandler.shared.getMovieGenres {
                    DispatchQueue.main.async {
                        self.resultsTableView.reloadData()
                    }
                }
            }
        } else {
            if AppManager.shared.seriesGenres.isEmpty {
                APIHandler.shared.getSeriesGenres {
                    DispatchQueue.main.async {
                        self.resultsTableView.reloadData()
                    }
                }
            }
            if !AppManager.shared.seasonsNumberLoaded{
                APIHandler.shared.getNumOfSeasons {
                    self.resultsTableView.reloadData()
                }
                AppManager.shared.seasonsNumberLoaded = true
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if result == "movies" {
            return AppManager.shared.nowPlayingMovies.count
        } else {
            return AppManager.shared.onAirSerieses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if result == "movies" {
            let newCell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! FeaturedMovieTableViewCell
            newCell.titleLabel.text = AppManager.shared.nowPlayingMovies[indexPath.row].title
            newCell.releaseDateLabel.text = AppManager.shared.nowPlayingMovies[indexPath.row].releaseDate
            newCell.avgRatingLabel.text = "Average Rating: \(AppManager.shared.nowPlayingMovies[indexPath.row].voteAvg!)"
            
            if !AppManager.shared.movieGenres.isEmpty{
                var genresText = ""
                if let genres = AppManager.shared.nowPlayingMovies[indexPath.row].genres{
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
            
            
            APIHandler.shared.getImageFromUrl(url: AppManager.shared.nowPlayingMovies[indexPath.row].imageUrl!, targetImageView: newCell.titleImage)
            return newCell
        } else {
            let newCell = tableView.dequeueReusableCell(withIdentifier: "seriesCell") as! FeaturedSeriesTableViewCell
            newCell.titleLabel.text = AppManager.shared.onAirSerieses[indexPath.row].title
            newCell.avgRatingLabel.text = "Average Rating: \(AppManager.shared.onAirSerieses[indexPath.row].voteAvg!)"
            newCell.releaseDateLabel.text = AppManager.shared.onAirSerieses[indexPath.row].releaseDate
            if let numOfSeasons = AppManager.shared.onAirSerieses[indexPath.row].numberOfSeasons {
                if numOfSeasons == 1 {
                    newCell.numOfSeasonsLabel.text = "1 season"
                } else {
                    newCell.numOfSeasonsLabel.text = "\(numOfSeasons) seasons"
                }
            }
            
//            var genresText = ""
//            if let genres = AppManager.shared.onAirSerieses[indexPath.row].genres{
//                for genre in genres{
//                    genresText += "\(genre) "
//                }
//            }
//            newCell.genresLabel.text = genresText
            
            if !AppManager.shared.seriesGenres.isEmpty{
                var genresText = ""
                if let genres = AppManager.shared.onAirSerieses[indexPath.row].genres{
                    for genre in genres{
                        for genreKey in AppManager.shared.seriesGenres{
                            if (genreKey[genre] != nil){
                                genresText += "| \(genreKey[genre]!) "
                            }
                        }
                    }
                }
                genresText += "|"
                newCell.genresLabel.text = genresText
            }
            
            APIHandler.shared.getImageFromUrl(url: AppManager.shared.onAirSerieses[indexPath.row].imageUrl!, targetImageView: newCell.titleImage)
            return newCell
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
