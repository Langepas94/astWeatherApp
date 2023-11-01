//
//  double + extension.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 31.10.2023.
//

import Foundation

extension Double {
    func rounded(numAfter: Int) -> Double {
        let divisor = pow(10.0, Double(numAfter))
        return (self * divisor).rounded() / divisor
    }
}
