//
//  WeatherManager.swift
//  ClimateApp
//
//  Created by Saranya Kalyanasundaram on 6/30/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather : WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager{
    
    var delegate : WeatherManagerDelegate?
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(Constants.API_KEY)"
    
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with : urlString)
    }
    func fetchWeather(latitude : Double, longitude: Double){
           let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
           performRequest(with : urlString)
       }
       
    func performRequest(with urlString : String){
        
        //Create the URL
        if let weatherAPIUrl = URL(string: urlString){
            //Create the URL session
            let weatherURLSession = URLSession(configuration: .default)
            
            //create the datatask
            let task = weatherURLSession.dataTask(with: weatherAPIUrl) { (data, response, err) in
                if let err = err{
                    self.delegate?.didFailWithError(error: err)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //Start the task
            task.resume()
        }
        
        
    }
    
    func parseJSON(weatherData : Data) -> WeatherModel?{
        do{
            let weatherDataObj = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            let id = weatherDataObj.weather[0].id
            let name = weatherDataObj.name
            let temp = weatherDataObj.main.temp
            let weather = WeatherModel(cityName: name, conditionId: id, temperature: temp)
            return weather
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
