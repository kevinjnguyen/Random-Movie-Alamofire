//
//  ViewController.swift
//  Movie Search Alamo Fire
//
//  Created by Kevin Nguyen on 3/12/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {

    let end_point_base : String = "https://api.themoviedb.org/"
    let append_api_key : String = "?api_key=8776cd8658f49f0ec71d7b77c9a7bace"
    let version : String = "3/"
    
    var pastGenerated : Int = 0

    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelMovieDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func randomizeMovie(sender: UIButton) {
        randomMovie()
    }
    
    func randomMovie(){
        let specify_endpoint : String = "movie/now_playing"
        let request_endpoint = end_point_base + version + specify_endpoint + append_api_key
        
        Alamofire.request(.GET, request_endpoint)
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    let randomMaxBound = json["results"].count
                    var generateRandom = Int(arc4random_uniform(UInt32(randomMaxBound)))
                    while(generateRandom == self.pastGenerated ){
                        generateRandom = Int(arc4random_uniform(UInt32(randomMaxBound)))
                    }
                    self.pastGenerated = generateRandom
                    
                    let name = json["results"][generateRandom]["title"].stringValue
                    self.labelMovieTitle.text = name
                    
                    let description = json["results"][generateRandom]["overview"].stringValue
                    self.labelMovieDescription.text = description
                case .Failure(let error):
                    print("Request failed with error: \(error)")
    
                }
        }
    }
}