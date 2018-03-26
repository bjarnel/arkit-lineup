//
//  Position.swift
//  LineUp
//
//  Created by Bjarne Møller Lundgren on 26/03/2018.
//  Copyright © 2018 Bjarne Møller Lundgren. All rights reserved.
//

import Foundation

enum Position {
    case keeper
    case defense
    case midfield
    case forward
    
    static func all() -> [Position] {
        return [.keeper, .defense, .midfield, .forward]
    }
}
