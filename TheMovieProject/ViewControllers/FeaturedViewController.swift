//
//  FeaturedViewController.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

//Defines the featured movies and series ViewController. This is the main VC.
class FeaturedViewController: UIViewController {

    @IBOutlet weak var inTheatersHeader: UILabel! //Outlet for the movies header
    @IBOutlet weak var theatersView: UIView! //Outlet for the movies view
    @IBOutlet weak var theatersCornersView: UIView!
    @IBOutlet weak var theatersFirstImageView: UIImageView! //outlet for the first movie image
    @IBOutlet weak var theatersSecondImageView: UIImageView! //outlet for the second movie image
    @IBOutlet weak var theatersDescription: UILabel!
    let numOfMoviesTextToDisplay = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets the rounded corners and shadow for the movies' view
        let radius : CGFloat = 15
        theatersView.setRadius(cornerRadius: radius)
        theatersCornersView.setRadius(cornerRadius: radius)
        theatersView.dropShadow(color: .gray, opacity: 0.8, offSet: CGSize(width: 0, height: 1), radius: radius, scale: true)
        theatersCornersView.clipsToBounds = true
        
        
        //Gets the now playing movies from the API into an array in the handler
        APIHandler.shared.getNowPlayingMovies {
            
            //This is a callback! performed when the getNowPlayingMovies
            APIHandler.shared.getImageFromUrl(url: AppManager.shared.nowPlayingMovies[0].imageUrl!, targetImageView: self.theatersFirstImageView)
            APIHandler.shared.getImageFromUrl(url: AppManager.shared.nowPlayingMovies[1].imageUrl!, targetImageView: self.theatersSecondImageView)
            
            DispatchQueue.main.async {
                
                self.inTheatersHeader.text = "\(AppManager.shared.nowPlayingMovies.count) movies in theaters today!"
                var i = 0
                var movieDesc : String = ""
                
                for movie in AppManager.shared.nowPlayingMovies{
                    if i<self.numOfMoviesTextToDisplay{
                        movieDesc += "\(movie.title), "
                        i += 1
                    }
                }
                movieDesc += "and more..."
                
                self.theatersDescription.text = movieDesc
                self.theatersDescription.sizeToFit()
            }
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

