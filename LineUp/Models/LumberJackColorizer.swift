//
//  LumberJackColorizer.swift
//  LineUp
//
//  Created by Bjarne Møller Lundgren on 26/03/2018.
//  Copyright © 2018 Bjarne Møller Lundgren. All rights reserved.
//

import UIKit

// taken from https://stackoverflow.com/questions/7171679/replace-a-particular-color-inside-an-image-with-another-color
// without much condiration :)
struct RGBA32: Equatable {
    private var color: UInt32
    
    var redComponent: UInt8 {
        return UInt8((self.color >> 24) & 255)
    }
    
    var greenComponent: UInt8 {
        return UInt8((self.color >> 16) & 255)
    }
    
    var blueComponent: UInt8 {
        return UInt8((self.color >> 8) & 255)
    }
    
    var alphaComponent: UInt8 {
        return UInt8((self.color >> 0) & 255)
    }
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        var col:UInt32 = 0
        col += (UInt32(red) << 24)
        col += (UInt32(green) << 16)
        col += (UInt32(blue) << 8)
        col += (UInt32(alpha) << 0)
        self.color = col
        
        // experession too complex! ha
        //self.color = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | (UInt32(alpha) << 0)
    }
    
    init(color: UIColor) {
        let components = color.cgColor.components ?? [0.0, 0.0, 0.0, 1.0]
        let colors = components.map { UInt8($0 * 255) }
        self.init(red: colors[0],
                  green: colors[1],
                  blue: colors[2],
                  alpha: colors[3])
    }
    
    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
    
    static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.color == rhs.color
    }
    
}

class LumberJackColorizer {
    // we make this a singleton, because we want to cache materials..
    static let shared = LumberJackColorizer()
    private let baseImage = UIImage(named: "art.scnassets/LumberJack/lumberJack_diffuse_flat.png")!
   // private var materials = [(shirt:UIColor, pants:UIColor, image:UIImage)]()
    
    static let shirtReplaceColor = UIColor(red:0.00, green:1.00, blue:1.00, alpha:1.0)// 00FFFF
    static let pantsReplaceColor = UIColor(red:1.00, green:1.0, blue:0.0, alpha:1.0)// FFFF00
    
    func material(forShirtColor shirtColor:UIColor,
                  pantsColor:UIColor,
                  playerNumber:Int?) -> UIImage? {
        
        // return cached material
      //  if let material = materials.filter({ $0.shirt == shirtColor && $0.pants == pantsColor}).first {
       //     return material.image
       // }
        
        // yeah yeah, should support more stuff in the replace func(!!) it should only be ONE operation to modify image!
     /*   guard let newMat = replace(color: LumberJackColorizer.shirtReplaceColor,
                                   withColor: shirtColor,
                                   in: baseImage),
              let newMat2 = replace(color: LumberJackColorizer.pantsReplaceColor,
                                    withColor: pantsColor,
                                    in: newMat) else { return nil }
       */
       // materials.append((shirt: shirtColor,
        //                  pants: pantsColor,
          //                image: newMat2))
        
        // number position: 739x583
        
        guard let newMat = replace(shirtColor: shirtColor,
                                   pantsColor: pantsColor,
                                   playerNumber: playerNumber,
                                   in: baseImage) else { return nil }
        
        return newMat
    }
    
    // taken from https://stackoverflow.com/questions/7171679/replace-a-particular-color-inside-an-image-with-another-color
    // without much condiration :)
    private func replace(shirtColor shirtColorIn: UIColor,
                         pantsColor pantsColorIn: UIColor,
                         playerNumber:Int?,
                         in image:UIImage) -> UIImage? {
        guard let inputCGImage = image.cgImage else { return nil }
        
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        let shirtColorSearch = RGBA32(color: LumberJackColorizer.shirtReplaceColor)
        let shirtColor = RGBA32(color: shirtColorIn)
        let pantsColorSearch = RGBA32(color: LumberJackColorizer.pantsReplaceColor)
        let pantsColor = RGBA32(color: pantsColorIn)
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if pixelBuffer[offset] == shirtColorSearch {
                    pixelBuffer[offset] = shirtColor
                }
                if pixelBuffer[offset] == pantsColorSearch {
                    pixelBuffer[offset] = pantsColor
                }
            }
        }
        
        guard let outputCGImage = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: outputCGImage,
                       scale: image.scale,
                       orientation: image.imageOrientation)
    }
    
}
