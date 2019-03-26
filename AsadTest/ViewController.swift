//
//  ViewController.swift
//  AsadTest
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate
{
    
    
    var m_locManager = CLLocationManager()
    var m_currentLocation: CLLocation!
    var m_weatherData : Welcome?
    @IBOutlet weak var m_tableView: UITableView!
    fileprivate func refreshData() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = m_locManager.location else {
                return
            }
            m_currentLocation =  currentLocation
            print(m_currentLocation.coordinate.latitude)
            print(m_currentLocation.coordinate.longitude)
            getData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        m_locManager.delegate = self
        m_locManager.requestWhenInUseAuthorization()
    
//        m_tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherTableViewCell")
        m_tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        refreshData()
       
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         refreshData()
    }
    func getData()
    {
        let urlStr =  "http://api.openweathermap.org/data/2.5/find?lat=\(m_currentLocation.coordinate.latitude)&lon=\(m_currentLocation.coordinate.longitude)&cnt=10&appid=9504822cc754769f8273f798a9b7b5fc"
        executeGetRequest(url: urlStr)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let weatherData = m_weatherData
        {
            return weatherData.list.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell

        if let weatherData = m_weatherData
        {
            let weatherInfo = weatherData.list[indexPath.row]
            cell.m_cityNamelbl.text = "\(weatherInfo.name)"
            cell.m_tempraturelbl.text = "Temprature:\(weatherInfo.main.temp)"
            cell.m_humiditylbl.text = "Humidity:\(weatherInfo.main.humidity)"
           
        }
        
        return cell
            
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    public func executeGetRequest(url:String)
    {
        
        
        guard let url = URL(string: url) else {
            print("Error: cannot create url")
            return
        }
        var urlRequest = URLRequest(url: url)
        
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            
            if(error != nil)
            {
                print( "Fail Error not null : \(error.debugDescription)")
            }
            else
            {
                if (response as? HTTPURLResponse) != nil
                {
                    DispatchQueue.main.async
                    {
                        guard let data = data else {return}
                        let decoder = JSONDecoder()
                        do {
                            let responseObject = try decoder.decode(Welcome.self, from: data)
                            self.m_weatherData = responseObject
                            print(responseObject)
                        } catch {
                            print(error)
                        }
                        self.m_tableView.reloadData()
                       
                    }
                    
                }
            }
            
        })
        task.resume()
    }
    
}

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)


// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)


struct Welcome: Codable {
    let message, cod: String
    let count: Int
    let list: [List]
}

struct List: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let main: Main
    let dt: Int
    let wind: Wind
    let sys: Sys
    let rain, snow: JSONNull?
    let clouds: Clouds
    let weather: [Weather]
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lat, lon: Double
}

struct Main: Codable {
    let temp, pressure: Double
    let humidity: Int
    let tempMin, tempMax, seaLevel, grndLevel: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Sys: Codable {
    let country: String
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed, deg: Double
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

/*
struct WeatherData : Codable
{
    var message: String?
    var cod: Int?
    var count: Int?
    var list: Bool?
}
struct WeatherList: Codable
{
    var id: Double?
    var name: String?
    var coord : Coordinate?
    var main : Main?
    var dt: Double?
    var wind: Wind?
    var sys: Sys?
    var rain: String?
    var snow: String?
}
struct Coordinate: Codable {
    let lat: Double?
    let lng: Double?
}
struct Main: Codable
{
    let temp: Double?
    let pressure: Double?
    let temp_min: Double?
    let temp_max: Double?
    let sea_level: Double?
    let grnd_level: Double?
   
}
struct Wind: Codable
{
    let speed : Double?
    let deg: Double?
    
}
struct Sys: Codable
{
    var country: String?
    
}*/

