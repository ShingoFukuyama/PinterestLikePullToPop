//
//  UIColor+Extension.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

extension Extension where T: UIColor {
    static var random: UIColor {
        let red: CGFloat = CGFloat(arc4random_uniform(255)) / 255.0
        let green: CGFloat = CGFloat(arc4random_uniform(255)) / 255.0
        let blue: CGFloat = CGFloat(arc4random_uniform(255)) / 255.0
        return UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 1.0)
    }

    var complementary: UIColor {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(
            red: 1.0 - red,
            green: 1.0 - green,
            blue: 1.0 - blue,
            alpha: alpha)
    }

    /// Returns: tuple (red, green, blue)
    var rgb: (CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        base.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red, green, blue)
    }

    /// Returns: tuple (red, green, blue, alpha)
    var rgba: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }

    /// Returns: tuple (hue, saturation, brightness)
    var hsb: (CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat = 1.0
        var saturation: CGFloat = 1.0
        var brightness: CGFloat = 1.0
        base.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return (hue, saturation, brightness)
    }

    /// Returns: tuple (hue, saturation, brightness, alpha)
    var hsba: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat = 1.0
        var saturation: CGFloat = 1.0
        var brightness: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        base.getHue(
            &hue,
            saturation: &saturation,
            brightness: &brightness,
            alpha: &alpha)
        return (hue, saturation, brightness, alpha)
    }

    var red: CGFloat {
        var value: CGFloat = 1.0
        base.getRed(&value, green: nil, blue: nil, alpha: nil)
        return value
    }

    var green: CGFloat {
        var value: CGFloat = 1.0
        base.getRed(nil, green: &value, blue: nil, alpha: nil)
        return value
    }

    var blue: CGFloat {
        var value: CGFloat = 1.0
        base.getRed(nil, green: nil, blue: &value, alpha: nil)
        return value
    }

    var alpha: CGFloat {
        var value: CGFloat = 1.0
        base.getRed(nil, green: nil, blue: nil, alpha: &value)
        return value
    }

    var hue: CGFloat {
        var value: CGFloat = 1.0
        base.getHue(&value, saturation: nil, brightness: nil, alpha: nil)
        return value
    }

    var saturation: CGFloat {
        var value: CGFloat = 1.0
        base.getHue(nil, saturation: &value, brightness: nil, alpha: nil)
        return value
    }

    var brightness: CGFloat {
        var value: CGFloat = 1.0
        base.getHue(nil, saturation: nil, brightness: &value, alpha: nil)
        return value
    }

    /// Adjust alpha.
    ///
    /// - Parameter alpha:
    /// - Returns: Adjusted color
    func with(alpha: CGFloat) -> UIColor {
        let (oRed, oGreen, oBlue, _) = rgba
        return UIColor(
            red: oRed,
            green: oGreen,
            blue: oBlue,
            alpha: alpha)
    }

    /// Adjust red, green, blue
    ///
    /// - Parameters:
    ///   - red:
    ///   - green:
    ///   - blue:
    /// - Returns: Adjusted color
    func with(
        red: CGFloat? = nil,
        green: CGFloat? = nil,
        blue: CGFloat? = nil) -> UIColor {
        let (oRed, oGreen, oBlue, oAlpha) = rgba
        return UIColor(
            red: red ?? oRed,
            green: green ?? oGreen,
            blue: blue ?? oBlue,
            alpha: oAlpha)
    }

    /// Adjust hue, saturation, brightness
    ///
    /// - Parameters:
    ///   - hue:
    ///   - saturation:
    ///   - brightness:
    /// - Returns: Adjusted color
    func with(
        hue: CGFloat? = nil,
        saturation: CGFloat? = nil,
        brightness: CGFloat? = nil) -> UIColor {
        let (oHue, oSaturation, oBrightness, oAlpha) = hsba
        return UIColor(
            hue: hue ?? oHue,
            saturation: saturation ?? oSaturation,
            brightness: brightness ?? oBrightness,
            alpha: oAlpha)
    }
}
