//
//  SeriesViewController.swift
//  TheMovieProject
//
//  Created by Admin on 05/12/2017.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var seriesTableView: UITableView!
    var series : Series? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndex = seriesTableView.indexPathForSelectedRow {
            seriesTableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        APIHandler.shared.getSeriesSeasons(series: series!, completion: {
            DispatchQueue.main.async {
                self.seriesTableView.reloadData()
            }
        })
        
        if AppManager.shared.seriesGenres.isEmpty {
            APIHandler.shared.getSeriesGenres {
                DispatchQueue.main.async {
                    self.seriesTableView.reloadData()
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let seasons = series?.seasons{
            return seasons.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let newCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as! SeriesDefaultTableViewCell
            if let series = series {
                
                if AppManager.shared.seriesGenres.isEmpty{
                    APIHandler.shared.getSeriesGenres {
                        DispatchQueue.main.async {
                            var genresText = ""
                            if let genres = series.genres{
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
                    }
                }
                
                newCell.seriesTitle.text = series.title
                newCell.avgRatingLabel.text = String(describing: series.voteAvg!)
                newCell.releaseDateLabel.text = series.releaseDate
                newCell.overviewLabel.text = series.overview
                if let imageUrl = series.imageUrl{
                    APIHandler.shared.getImageFromUrl(url: imageUrl, targetImageView: newCell.seriesImageView)
                } else {
                    newCell.seriesImageView.image = nil
                }
                if !AppManager.shared.movieGenres.isEmpty{
                    var genresText = ""
                    if let genres = series.genres{
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
            }
            return newCell
        } else {
            let newCell = tableView.dequeueReusableCell(withIdentifier: "seasonCell")
            if series!.seasons![indexPath.row-1].number == 0 {
                newCell?.textLabel?.text = "Specials"
            } else {
                newCell?.textLabel?.text = "Season \(series!.seasons![indexPath.row-1].number)"
            }
            return newCell!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let seasonViewController = segue.destination as? SeasonViewController {
            if let selectedIndexPath = seriesTableView.indexPathForSelectedRow {
                seasonViewController.series = series
                seasonViewController.seasonIndex = selectedIndexPath.row-1
                seasonViewController.title = "Season \(series!.seasons![selectedIndexPath.row-1].number)"
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
