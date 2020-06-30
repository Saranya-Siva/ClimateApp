//
//  WeatherData.swift
//  ClimateApp
//
//  Created by Saranya Kalyanasundaram on 6/30/20.
//  Copyright © 2020 Saranya. All rights reserved.
//


import Foundation

struct WeatherResult : Decodable{
    let list : [WeatherData]
}
struct WeatherData : Decodable{
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Decodable{
    let temp : Double
}

struct Weather : Decodable{
    let id : Int
    let description : String
}
