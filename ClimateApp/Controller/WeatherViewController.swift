//
//  ViewController.swift
//  ClimateApp
//
//  Created by Saranya Kalyanasundaram on 6/30/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
   
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        weatherManager.delegate = self
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        searchField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
             return true
        }
        else{
            textField.placeholder = "Type place name"
            return false
        }
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.fetchWeather(cityName: textField.text!)
        searchField.text = ""
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        print("\(weather.temperatureString)")
    }
}



