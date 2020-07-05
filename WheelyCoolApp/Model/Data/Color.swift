//
//  Data.swift
//  WheelyCoolApp
//
//  Created by Simon Italia on 7/2/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit


//MARK: - Base Color Class

class Color: Codable {
    
    var name: String
    var type: String
    var shade: UIColor
    

    init(name: String, type: String, shade: UIColor) {
        self.name = name
        self.type = type
        self.shade = shade
    }
    
    
    //Codable conformance
    enum CodingKeys: String, CodingKey {
        case name, type, shade
    }
    
    
    required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)

        let data = try container.decode(Data.self, forKey: .shade)
        shade = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? UIColor.white //fallback color in case of issue
    }
    
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)

        let data = try NSKeyedArchiver.archivedData(withRootObject: shade, requiringSecureCoding: false)
        try container.encode(data, forKey: .shade)
    }
}
