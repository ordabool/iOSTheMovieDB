//
//  SearchViewController.swift
//  TheMovieProject
//
//  Created by Or Dabool on 2011//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndex = resultsTableView.indexPathForSelectedRow {
            resultsTableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        if AppManager.shared.movieGenres.isEmpty{
            APIHandler.shared.getMovieGenres {
                DispatchQueue.main.async {
                    self.resultsTableView.reloadData()
                }
            }
        }
        if AppManager.shared.seriesGenres.isEmpty{
            APIHandler.shared.getSeriesGenres {
                DispatchQueue.main.async {
                    self.resultsTableView.reloadData()
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

        AppManager.shared.searchSeriesesEnded = false
        AppManager.shared.searchMoviesEnded = false
        AppManager.shared.searchResults = []
        if searchBar.text != "" {
            let query = searchBar.text!.replacingOccurrences(of: " ", with: "%20")

            APIHandler.shared.searchSeries(query: query, completion: {
                APIHandler.shared.getNumOfSeasonsForSearch {
                    DispatchQueue.main.async {
                        self.resultsTableView.reloadData()
                    }
                }

                AppManager.shared.searchSeriesesEnded = true
                if AppManager.shared.searchMoviesEnded{
                    DispatchQueue.main.async {
                        self.resultsTableView.reloadData()
                    }
                }
            })

            APIHandler.shared.searchMovie(query: query, completion: {
                AppManager.shared.searchMoviesEnded = true
                if AppManager.shared.searchSeriesesEnded{
                    DispatchQueue.main.async {
                        self.resultsTableView.reloadData()
                    }
                }
            })
        }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        AppManager.shared.searchSeriesesEnded = false
        AppManager.shared.searchMoviesEnded = false
        AppManager.shared.searchResults = []
        self.resultsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppManager.shared.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if AppManager.shared.searchResults[indexPath.row] is Movie{
            let result = AppManager.shared.searchResults[indexPath.row] as! Movie
            let newCell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! FeaturedMovieTableViewCell
            newCell.titleImage.image = nil
            newCell.titleLabel.text = result.title
            newCell.releaseDateLabel.text = result.releaseDate
            newCell.avgRatingLabel.text = "Average Rating: \(result.voteAvg!)"
            
            if !AppManager.shared.movieGenres.isEmpty{
                var genresText = ""
                if let genres = result.genres{
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
            
            if let imageUrl = result.imageUrl{
                APIHandler.shared.getImageFromUrl(url: imageUrl, targetImageView: newCell.titleImage)
            } else {
                newCell.titleImage.image = nil
            }
            return newCell
            
        }
            
        else {
            let result = AppManager.shared.searchResults[indexPath.row] as! Series
            let newCell = tableView.dequeueReusableCell(withIdentifier: "seriesCell") as! FeaturedSeriesTableViewCell
            newCell.titleLabel.text = result.title
            newCell.avgRatingLabel.text = "Average Rating: \(result.voteAvg!)"
            newCell.releaseDateLabel.text = result.releaseDate
            if let numOfSeasons = result.numberOfSeasons {
                if numOfSeasons == 1 {
                    newCell.numOfSeasonsLabel.text = "1 season"
                } else {
                    newCell.numOfSeasonsLabel.text = "\(numOfSeasons) seasons"
                }
            }
            
            if !AppManager.shared.seriesGenres.isEmpty{
                var genresText = ""
                if let genres = result.genres{
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
            
            if let imageUrl = result.imageUrl{
                APIHandler.shared.getImageFromUrl(url: imageUrl, targetImageView: newCell.titleImage)
            } else {
                newCell.titleImage.image = nil
            }
            return newCell
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndexPath = resultsTableView.indexPathForSelectedRow {
            
            if AppManager.shared.searchResults[selectedIndexPath.row] is Movie{
                if let movieViewController = segue.destination as? MovieViewController {
                    movieViewController.movie = AppManager.shared.searchResults[selectedIndexPath.row] as? Movie
                    movieViewController.title = AppManager.shared.searchResults[selectedIndexPath.row].title
                }
            }
            
            if let seriesViewController = segue.destination as? SeriesViewController {
                if let selectedIndexPath = resultsTableView.indexPathForSelectedRow {
                    seriesViewController.series = AppManager.shared.searchResults[selectedIndexPath.row] as? Series
                    seriesViewController.title = AppManager.shared.searchResults[selectedIndexPath.row].title
                }
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
