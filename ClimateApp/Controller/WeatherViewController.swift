//
//  ViewController.swift
//  ClimateApp
//
//  Created by Saranya Kalyanasundaram on 6/30/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
   
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    @IBAction func gpsButtonPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate{
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
        print("didend editing called")
         weatherManager.fetchWeather(cityName: textField.text!)
         searchField.text = ""
         searchField.placeholder = "Search"
     }
}
 
//MARK: - WeatherManagerDelegate
    extension WeatherViewController : WeatherManagerDelegate{
        func didUpdateWeather(_ weatherManager: WeatherManager, weather : WeatherModel){
              DispatchQueue.main.async{
                   self.temperatureLabel.text = weather.temperatureString
                   self.conditionImageView.image = UIImage(systemName : weather.conditionCode)
                    self.cityLabel.text = weather.cityName
              }
           }
           
           func didFailWithError(error: Error){
               print("\(error)")
           }
    }
 
//MARK: - CLLocationManagerDelegate

extension WeatherViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            manager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("\(lat) and \(lon)")
            weatherManager.fetchWeather(latitude : lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
}


