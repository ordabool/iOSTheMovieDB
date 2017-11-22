//
//  MoviesViewController.swift
//  TheMovieProject
//
//  Created by Or Dabool on 2011//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular Movies"
        if !AppManager.shared.popularMoviesLoaded{
            APIHandler.shared.getPopularMovies {
                DispatchQueue.main.async {
                    self.resultsCollectionView.reloadData()
                }
                AppManager.shared.popularMoviesLoaded = true
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppManager.shared.popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MoviesCollectionViewCell
        newCell.movieTitle.text = AppManager.shared.popularMovies[indexPath.row].title
        APIHandler.shared.getImageFromUrl(url: AppManager.shared.popularMovies[indexPath.row].imageUrl!, targetImageView: newCell.movieImageView)
        return newCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieViewController = segue.destination as? MovieViewController {
            if let selectedIndexPath = resultsCollectionView.indexPathsForSelectedItems {
                movieViewController.movie = AppManager.shared.popularMovies[selectedIndexPath[0].row]
                movieViewController.title = AppManager.shared.popularMovies[selectedIndexPath[0].row].title
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
