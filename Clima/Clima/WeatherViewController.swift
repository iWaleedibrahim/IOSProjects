//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.


import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "fd318512c96470ce1edb290360840f02"
    
    
    //TODO: Declare instance variables here
    let locationManger = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:Set up the location manager here.
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getWeatherData(url: String, parameters: [String:String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data.")                // casting reterning value into a json object.
                let weatherJSON: JSON = JSON(response.result.value!) //force unwrapping
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print ("Error! \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Error!"
            }
        }
    }
    
    //Write the getWeatherData method here:
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    
        // BEAUTY IS HERE, this makes app safe and consistent.
    func updateWeatherData(json: JSON) {
        // this happens as the next step of getting the correct data
        // this won't be excuted in case of non-valid-data to be shown response
        if let tempResult = json["main"]["temp"].double {
        weatherDataModel.temperture = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"]["id"].intValue
        weatherDataModel.weatherIconName =  weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
    }
        else  {
            cityLabel.text = "Weather Unavailable"
        }
}
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperture)
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            // stop recieving messages from loc.Manger while in process of being stopped.
            locationManger.delegate = nil
            print ( "location = \(location.coordinate.longitude), latiude = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat": latitude, "lon": longitude, "appid": APP_ID ]
            getWeatherData(url: WEATHER_URL, parameters:params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavaiable!"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName (city: String) {
        cityLabel.text = city
    }

    
    //Write the PrepareForSegue Method here
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
        let destinationVC = segue.destination as! ChangeCityViewController
        destinationVC.delegate = self
            
    }
  }
}



