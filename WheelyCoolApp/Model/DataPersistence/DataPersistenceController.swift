//
//  DataController.swift
//  WheelyCoolApp
//
//  Created by Simon Italia on 7/3/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

class DataPersistenceController {
    
    enum UserDefaultsKey {
        static let colors = "colors"
    }
    
    static let shared = DataPersistenceController()
    private init(){}
    
    
    //MARK: - Save Colors Data
    
    func save(colors: [Color]) {
        let userDefaults = UserDefaults.standard
        
        do {
            let data = try JSONEncoder().encode(colors)
            userDefaults.set(data, forKey: UserDefaultsKey.colors)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    

    //MARK: - Load Colors Data
    
    func loadColors() -> [Color]? {
        let userDefaults = UserDefaults.standard
        
        guard let data = userDefaults.object(forKey: UserDefaultsKey.colors) as? Data else {
            print("Failed to load [Color] data.")
            return nil
        }
        
        do {
            let colors = try JSONDecoder().decode([Color].self, from: data)
            return colors
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
