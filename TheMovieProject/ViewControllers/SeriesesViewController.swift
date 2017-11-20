//
//  SeriesesViewController.swift
//  TheMovieProject
//
//  Created by Or Dabool on 2011//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import UIKit

class SeriesesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular Serieses"
        if !AppManager.shared.popularSeriesesLoaded{
            APIHandler.shared.getPopularSerieses {
                DispatchQueue.main.async {
                    self.resultsCollectionView.reloadData()
                }
                AppManager.shared.popularSeriesesLoaded = true
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppManager.shared.popularSerieses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "seriesCell", for: indexPath) as! SeriesesCollectionViewCell
        newCell.seriesTitle.text = AppManager.shared.popularSerieses[indexPath.row].title
        APIHandler.shared.getImageFromUrl(url: AppManager.shared.popularSerieses[indexPath.row].imageUrl!, targetImageView: newCell.seriesImageView)
        return newCell
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
