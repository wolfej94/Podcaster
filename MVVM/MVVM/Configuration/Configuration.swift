//
//  Configuration.swift
//  
//
//  Created by James Wolfe on 04/12/2024.
//

import Foundation

struct Configuration {
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
}
