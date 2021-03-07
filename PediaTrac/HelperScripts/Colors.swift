//
//  Colors.swift
//  InfluPeach
//
//  Created by Ethan Hanlon on 2/20/21.
//
//  Defines some default colors for InfluPeach
//  Right now it just has a value for the background color

import Foundation
import SwiftUI

class Colors {
    public static let defaultBackgroundColor = Gradient(colors:
                                                            [Color(Color.RGBColorSpace.sRGB, red: 102, green: 3, blue: 31, opacity: 1),
                                                                Color(Color.RGBColorSpace.sRGB, red: 204, green: 118, blue: 161, opacity: 1)
                                                            ]
    )
    
}
