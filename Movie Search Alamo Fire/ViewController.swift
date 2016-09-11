//
//  ViewController.swift
//  PokeDex
//
//  Created by Kevin Nguyen on 9/10/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    // Initialize the UI Bindings.
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokeDexID: UILabel!
    @IBOutlet weak var firstMoveLabel: UILabel!
    
    @IBOutlet weak var pokemonData: UILabel!
    
    // Init the API End Point
    let pokeAPI_BASE = "http://pokeapi.co/api/v2/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Code to disable the keyboard on a tap not currently defined.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function called when Search Button is clicked
    @IBAction func search(sender: UIButton) {
        // Grab the current user input.
        let currentUserInput = userInput.text!
        // Create the new API End point based on the base and user input.
        let GET_url_endpoint = pokeAPI_BASE + "pokemon/" + currentUserInput + "/"
        // Contact the API and update the DOM.
        pokeAPI(GET_url_endpoint)
    }
    
    // Function to connect with the PokeAPI and request the data.
    func pokeAPI(query: String) {
        // Init the Alamofire Module and use the GET Request.
        Alamofire.request(.GET, query)
            // Call require.
            .responseJSON { response in
                // Create a switch case based on the asynchronuous call of the data.
                switch response.result {
                    // If there was data returned from the server that did not result in error.
                case .Success(let data):
                    // Using SwiftJSON convert the data from AlamoFire to a usable form in Swift.
                    let json = JSON(data)
                    // Update the DOM elements with the data returned from the async call.
                    self.nameLabel.text = "Name: " + String(json["name"]).capitalizedString
                    self.heightLabel.text = "Height: " + String(json["height"])
                    self.weightLabel.text = "Weight: " + String(json["weight"])
                    self.pokeDexID.text = "ID: " + String(json["id"])
                    
                    // Temp set the first move for alteration.
                    var firstMove = String(json["moves"][0]["move"]["name"])
                    // Replace all the - in the move with spaces for aesthetic appeal.
                    firstMove = firstMove.stringByReplacingOccurrencesOfString("-", withString: " ")
                    // Capitalize each word of the string.
                    self.firstMoveLabel.text = "First Move: " + firstMove.capitalizedString
                    // On completion of all these tasks, hide the keyboard.
                    self.dismissKeyboard()
                
                    // If there was an error in the data returned or if the server timed out.
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}