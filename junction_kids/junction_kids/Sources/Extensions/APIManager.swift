//
//  APIManager.swift
//  junction_kids
//
//  Created by 성다연 on 2021/05/23.
//

import Foundation

protocol APIManager {}

extension APIManager {
    static func url(_ path: String) -> String {
        return "http://49.50.162.246:443" + path
    }
}
