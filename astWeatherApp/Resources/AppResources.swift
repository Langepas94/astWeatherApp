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
        struct Fonts {
            struct ViewController {
                static let cityNameLabel = UIFont(name: "AppleSDGothicNeo-Medium", size: 32)
                static let degreesLabel = UIFont(name: "AppleSDGothicNeo-Bold", size: 63)
                static let desxcriptionLabel = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
            }
        }
        
        struct Labels {
            struct WeatherCell {
                static let defaulCellLabel = "Loading"
            }
        }
        
        struct Colors {
            struct WeatherCell {
                static let cellTextColor = UIColor.black
            }
        }
        
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
    
    struct UniversalElements {
        struct Fonts {
            static let cellFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        }
    }
}
