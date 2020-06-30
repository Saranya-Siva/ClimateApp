//
//  WeatherManager.swift
//  ClimateApp
//
//  Created by Saranya Kalyanasundaram on 6/30/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather (weather : WeatherModel)
}
struct WeatherManager{
    
    var delegate : WeatherManagerDelegate?
    var weatherURL = "https://api.openweathermap.org/data/2.5/find?units=metric&appid=\(Constants.API_KEY)"
    
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
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
                    print("error: \(err)")
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            
            //Start the task
            task.resume()
        }
        
        
    }
    
    func parseJSON(weatherData : Data) -> WeatherModel?{
        do{
            let decodedData = try JSONDecoder().decode(WeatherResult.self, from: weatherData)
            let weatherDataObj = decodedData.list[0]
            let id = weatherDataObj.weather[0].id
            let name = weatherDataObj.name
            let temp = weatherDataObj.main.temp
            let weather = WeatherModel(cityName: name, conditionId: id, temperature: temp)
            return weather
        }
        catch{
            print(error)
            return nil
        }
    }
    
    
}
