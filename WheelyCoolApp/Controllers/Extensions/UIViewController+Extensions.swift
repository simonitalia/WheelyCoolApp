//
//  UIViewController+Extensions.swift
//  WheelyCoolApp
//
//  Created by Simon Italia on 7/2/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum ColorType {
        case primary, secondary
    }
    
    
    func createColorSet(for type: ColorType) -> [Color] {
        switch type {
        case .primary:
            return [Red(), Blue(), Yellow()]
            
        case .secondary:
            return [Orange(), Purple(), Green()]
        }
    }
}
