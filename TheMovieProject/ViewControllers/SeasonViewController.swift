//
//  SeasonViewController.swift
//  TheMovieProject
//
//  Created by Admin on 05/12/2017.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class SeasonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var seasonTableView: UITableView!
    var series : Series? = nil
    var seasonIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        APIHandler.shared.getSeasonEpisodes(series: series!, seasonIndex: seasonIndex, completion: {
            DispatchQueue.main.async {
                self.seasonTableView.reloadData()
            }
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let episodes = series?.seasons![seasonIndex].episodes{
            return episodes.count+1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let newCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as! SeasonDefaultTableViewCell
            if let series = series {
                let season = series.seasons![seasonIndex]
                newCell.seriesNameLabel.text = series.title
                newCell.seasonNameLabel.text = "Season \(season.number)"
                if let episodes = series.seasons![seasonIndex].episodes{
                    newCell.episodeCountLabel.text = "\(episodes.count)"
                }
                
                if let imageUrl = season.imageUrl{
                    APIHandler.shared.getImageFromUrl(url: imageUrl, targetImageView: newCell.seasonImageView)
                } else {
                    newCell.seasonImageView.image = nil
                }
            }
            return newCell
        } else {
            let newCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeTableViewCell
            newCell.episodeName.text = series?.seasons![seasonIndex].episodes![indexPath.row-1].name
            newCell.episodeNumberLabel.text = "Episode \(String(describing: series!.seasons![seasonIndex].episodes![indexPath.row-1].number))"
            newCell.overviewLabel.text = series?.seasons![seasonIndex].episodes![indexPath.row-1].overview
            if (series?.seasons![seasonIndex].episodes![indexPath.row-1].airDate) != nil {
                newCell.releaseDateLabel.text = series?.seasons![seasonIndex].episodes![indexPath.row-1].airDate
            } else {
                newCell.releaseDateLabel.text = "Not Available"
            }
            if let imageUrl = series?.seasons![seasonIndex].episodes![indexPath.row-1].imageUrl{
                APIHandler.shared.getImageFromUrl(url: imageUrl, targetImageView: newCell.episodeImageView)
            } else {
                newCell.episodeImageView.image = nil
            }
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
