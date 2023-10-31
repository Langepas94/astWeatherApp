//
//  AppResources.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 25.10.2023.
//

import Foundation
import UIKit

struct AppResources {
    
    // MARK: - Main Screen
    struct MainScreen {
        // MARK: Fonts
        struct Fonts {
            struct ViewController {
                static let cityNameLabel = UIFont(name: "AppleSDGothicNeo-Medium", size: 32)
                static let degreesLabel = UIFont(name: "AppleSDGothicNeo-Bold", size: 63)
                static let desxcriptionLabel = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
            }
            struct WeatherCell {
                static let cellFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
            }
        }
        // MARK: Labels
        struct Labels {
            struct WeatherCell {
                static let defaulCellLabel = "Loading"
            }
            struct TabBar {
                static let image = UIImage(systemName: "location.circle.fill")
                static let title = "Location weather"
                
            }
        }
        // MARK: Colors
        struct Colors {
            struct WeatherCell {
                static let cellTextColor = UIColor.label
            }
            struct ViewController {
                static let label = UIColor.label
            }
        }
        // MARK: Constraints
        struct Constraints {
            struct WeatherCell {
                static let leadingOffset = 5
                static let height = 50
                static let trailingOffset = -5
            }
            
            struct ViewController {
                struct CityNameLabel {
                    static let top = 16
                }
                struct DegreesLabel {
                    static let top = 22
                }
                struct DescriptionLabel {
                    static let top = 22
                }
                
                struct Table {
                    static let top = 22
                    static let leading = 25
                    static let trailing = -25
                }
            }
        }
    }
    
    //MARK: - Table Screen
    struct TableWithCities {
        struct Labels {
            struct TabBar {
                static let image = UIImage(systemName: "map.fill")
                static let title = "Favorites"
            }
            
            struct AddCityViewController {
                static let buttonTitle = "Add city to Favorites"
            }
            
            struct ResultTableCitiesViewController {
                static let resultTable = "ResultTableView"
                static let searchBarText = "Search for your new favorite city"
            }
            
            struct CityTableViewController {
                static let basicCellID = "CityNameCell"
                static let geoCellID = "GeoCell"
                static let screenTitle = "Favorites"
                
            }
        }
        // MARK: Constraints
        struct Constraints {
            struct AddCityViewController {
                static let cornerRadius = CGFloat(10)
                static let topOffsetLarge = 36
                static let typicalOffset = 16
            }
            
            
        }
        // MARK: Colors
        struct Colors {
            static let buttonTitle = UIColor.white
            static let buttonBackground = UIColor.lightGray
            static let textColor = UIColor.label
            static let background = UIColor.systemBackground
        }
        
        // MARK: Fonts
        struct Fonts {
            struct AddCityViewController {
                static let degreeLabel = UIFont(name: "AppleSDGothicNeo-Medium", size: 37)
                static let cityName = UIFont(name: "AppleSDGothicNeo-Medium", size: 30)
                static let smallText = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
            }
        }
    }
    
    // MARK: - DB
    struct DB {
        static let userDefaultsKey = "city"
    }
}


