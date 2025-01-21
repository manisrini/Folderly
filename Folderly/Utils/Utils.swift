//
//  Utils.swift
//  Folderly
//
//  Created by Manikandan on 15/01/25.
//

import Foundation
import UIKit

class Utils {
    
    public static func formatDate(date : Date,format : String = "dd-MM-yyyy HH:mm") -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    public static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
