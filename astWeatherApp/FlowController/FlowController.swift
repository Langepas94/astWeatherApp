//
//  FlowController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import UIKit

//class FlowController: UIViewController, IFlowController {
//    
//    func configureMainScreen(fetchType: WeatherTypeFetch) {
//        
//        let mainScreenViewModel = WeatherViewModel(type: fetchType)
//        let mainScreenView = MainWeatherScreen(viewModel: mainScreenViewModel)
//        
//        mainScreenViewModel.coordinator = self
//        addChild(mainScreenView)
//        view.addSubview(mainScreenView.view)
//        mainScreenView.didMove(toParent: self)
//    }
//    
//    func configureCoordinator() {
//        
//    }
//    
//    func showTable() {
//        let viewController = UIViewController()
//        
//        viewController.view.backgroundColor = .red
//        
//        present(viewController, animated: true, completion: nil)
//    }
//    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        self.configureMainScreen(fetchType: .geo)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

