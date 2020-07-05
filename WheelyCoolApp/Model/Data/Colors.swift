//
//  Colors.swift
//  WheelyCoolApp
//
//  Created by Simon Italia on 7/2/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

//MARK: - Primary Colors

class Blue: Color {
    init() {
        super.init(name: "blue", type: "primary", shade: .systemBlue)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class Red: Color {
    init() {
        super.init(name: "red", type: "primary", shade: .systemRed)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class Yellow: Color {
    init() {
        super.init(name: "yellow", type: "primary", shade: .systemYellow)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}



//MARK: - Secondary Colors

class Orange: Color {
    let baseColors: [Color]
    
    init() {
        baseColors = [Red(), Yellow()]
        super.init(name: "orange", type: "secondary", shade: .systemOrange)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}


class Purple: Color {
    
    let baseColors: [Color]
    
    init() {
        baseColors = [Red(), Blue()]
        super.init(name: "purple", type: "secondary", shade: .systemPurple)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}


class Green: Color {
    let baseColors: [Color]
    
    init() {
        baseColors = [Yellow(), Blue()]
        super.init(name: "green", type: "secondary", shade: .systemGreen)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
