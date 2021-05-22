//
//  MapModel.swift
//  junction_kids
//
//  Created by 성다연 on 2021/05/22.
//

import Foundation
import CoreLocation

struct Course {
    var startPoint : CLLocationCoordinate2D
    var endPoint: CLLocationCoordinate2D
    var points : [CLLocationCoordinate2D] = []
}
