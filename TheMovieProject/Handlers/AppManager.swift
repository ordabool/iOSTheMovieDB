//
//  AppManager.swift
//  TheMovieProject
//
//  Created by Or Dabool on 911//17.
//  Copyright © 2017 Or Dabool. All rights reserved.
//

import Foundation
class AppManager{
    
    static let shared = AppManager()
    
    //A function to convert Strings to URLs
    func convertStringToUrl(str : String?, append : String) -> URL? {
        if let str = str {
            let srcUrl = "\(append)\(str)"
            if let myURL = URL(string: srcUrl){
                return myURL
            }
        }
        return nil
    }
}
