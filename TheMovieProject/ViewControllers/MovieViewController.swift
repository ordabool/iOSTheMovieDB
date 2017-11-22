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
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var avgRatingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var videosTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        self.genresLabel.text = genresText
                    }
                }
            }
            
            movieTitle.text = movie.title
            avgRatingLabel.text = String(describing: movie.voteAvg!)
            releaseDateLabel.text = movie.releaseDate
            overviewLabel.text = movie.overview
            if let imageUrl = movie.imageUrl{
                APIHandler.shared.getImageFromUrl(url: imageUrl, targetImageView: movieImageView)
            } else {
                movieImageView.image = nil
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
                genresLabel.text = genresText
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "cell")
        newCell?.textLabel?.text = "Video"
        return newCell!
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
