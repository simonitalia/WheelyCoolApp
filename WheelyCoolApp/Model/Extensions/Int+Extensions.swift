//
//  Int+Extensions.swift
//  WheelyCoolApp
//
//  Created by Simon Italia on 7/4/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

extension Int {
    func degreesToRadians() -> CGFloat {
        return CGFloat(self) * .pi / 180.0
    }
}
