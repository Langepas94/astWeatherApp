//
//  WeatherTableViewCell.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import UIKit

class WeekWeatherCell: UITableViewCell {
    
    static let id = "WeekWeatherCellID"
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        return label
    }()
    
    let weatherImage: UIImageView = {
        let image = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        image.contentMode = .center
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let degreeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: List) {
        let date = item.dt ?? 0
        let convertDate = Date(timeIntervalSince1970: TimeInterval(date))
        let formats = convertDate.formatted(.dateTime.day().month(.twoDigits).hour().minute())
        self.timeLabel.text = String(formats)
        self.weatherImage.image = UIImage(named: item.weather?[0].icon ?? "")
        self.degreeLabel.text = String(item.main?.temp ?? 0.0) + "°"
    }
}

extension WeekWeatherCell {
    func setupUIs() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(degreeLabel)
       
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        weatherImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        degreeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
    }
}
