//
//  FeaturedViewController.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

//Defines the featured movies and series ViewController. This is the main VC.
class FeaturedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var featuredTableView: UITableView!
    
    let numOfMoviesTextToDisplay = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        featuredTableView.rowHeight = UITableViewAutomaticDimension
        title = "Featured"
        APIHandler.shared.getNowPlayingMovies {
            AppManager.shared.moviesLoaded = true
            DispatchQueue.main.async {
                self.featuredTableView.reloadData()
            }
        }
        
        APIHandler.shared.getOnAirSeries {
            AppManager.shared.seriesesLoaded = true
            DispatchQueue.main.async {
                self.featuredTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FeaturedTableViewCell
        
        switch indexPath.row {
        case 0:
            //Sets the rounded corners and shadow for the movies' view
            let radius : CGFloat = 15
            newCell.customViewCorners.setRadius(cornerRadius: radius)
            newCell.customViewShadows.setRadius(cornerRadius: radius)
            newCell.customViewShadows.dropShadow(color: .gray, opacity: 0.8, offSet: CGSize(width: 0, height: 1), radius: radius, scale: true)
            newCell.customViewCorners.clipsToBounds = true
            
            //Gets the now playing movies from the API into an array in the handler
            
            newCell.cellTitle.text = "In Theaters"
            
            //This is a callback! performed when the getNowPlayingMovies
            if AppManager.shared.moviesLoaded{
                APIHandler.shared.getImageFromUrl(url: AppManager.shared.nowPlayingMovies[0].imageUrl!, targetImageView: newCell.firsimage)
                APIHandler.shared.getImageFromUrl(url: AppManager.shared.nowPlayingMovies[1].imageUrl!, targetImageView: newCell.secondImage)
            }
            
            var i = 0
            var movieDesc : String = ""
            
            for movie in AppManager.shared.nowPlayingMovies{
                if i<self.numOfMoviesTextToDisplay{
                    movieDesc += "\(movie.title), "
                    i += 1
                }
            }
            movieDesc += "and more..."
            newCell.mediaTitle.text = "\(AppManager.shared.nowPlayingMovies.count) movies in theaters today"
            newCell.mediaDescription.text = movieDesc
            newCell.mediaDescription.sizeToFit()
            
            return newCell
            
        case 1:
            //Sets the rounded corners and shadow for the movies' view
            let radius : CGFloat = 15
            newCell.customViewCorners.setRadius(cornerRadius: radius)
            newCell.customViewShadows.setRadius(cornerRadius: radius)
            newCell.customViewShadows.dropShadow(color: .gray, opacity: 0.8, offSet: CGSize(width: 0, height: 1), radius: radius, scale: true)
            newCell.customViewCorners.clipsToBounds = true
            
            //Gets the now playing movies from the API into an array in the handler
            
            newCell.cellTitle.text = "On Air"
            
            //This is a callback! performed when the getNowPlayingMovies
            if AppManager.shared.seriesesLoaded{
                APIHandler.shared.getImageFromUrl(url: AppManager.shared.onAirSerieses[0].imageUrl!, targetImageView: newCell.firsimage)
                APIHandler.shared.getImageFromUrl(url: AppManager.shared.onAirSerieses[1].imageUrl!, targetImageView: newCell.secondImage)
            }
            
            var i = 0
            var seriesDesc : String = ""
            
            for series in AppManager.shared.onAirSerieses{
                if i<self.numOfMoviesTextToDisplay{
                    seriesDesc += "\(series.title), "
                    i += 1
                }
            }
            seriesDesc += "and more..."
            newCell.mediaTitle.text = "\(AppManager.shared.onAirSerieses.count) shows you can watch today"
            newCell.mediaDescription.text = seriesDesc
            newCell.mediaDescription.sizeToFit()
            
            return newCell
        default:
            return newCell
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var mediaClicked = ""
        if featuredTableView.indexPathForSelectedRow?.row == 0 {
            mediaClicked = "movies"
        } else {
            mediaClicked = "serieses"
        }
        if let featuredResultsVC = segue.destination as? FeaturedResultsViewController {
            featuredResultsVC.result = mediaClicked
            if mediaClicked == "movies" {
                featuredResultsVC.title = "In Theaters"
            } else {
                featuredResultsVC.title = "On Air"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

