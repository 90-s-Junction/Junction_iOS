//
//  MapRouteModel.swift
//  junction_kids
//
//  Created by 성다연 on 2021/05/22.
//

import Foundation

struct Route {
    enum RouteType : String {
        case recommend
        case shortest
        case easiest
        
        func name() -> String {
            switch self {
            case .recommend : return "Recommended Route"
            case .shortest : return "Shortest Route"
            case .easiest : return "Easiest Route"
            }
        }
        
        func image() -> String {
            switch self {
            case .recommend : return "recommandimage1"
            case .shortest : return "recommandimage2"
            case .easiest : return "recommandimage3"
            }
        }
        
        func number() -> Int {
            switch self {
            case .recommend : return 1
            case .shortest : return 2
            case .easiest : return 3
            }
        }
    }
    
    enum DayNight : String {
        case day
        case night
        
        func image() -> String {
            switch self {
            case .day : return "daysun"
            case .night : return "daynight"
            }
        }
    }
    var type: RouteType
    var carType : String
    var time : Int
    var distance : Int
    var dayNight : DayNight
}

struct RouteFactory {
    static let shared : [Route] = [
        Route(type: .recommend, carType: "Sedan", time: 40, distance: 10, dayNight: .day),
        Route(type: .shortest, carType: "SUV", time: 20, distance: 5, dayNight: .night),
        Route(type: .easiest, carType: "SUV", time: 30, distance: 3, dayNight: .day)
    ]
}
