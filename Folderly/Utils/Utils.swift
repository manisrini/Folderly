//
//  Utils.swift
//  Folderly
//
//  Created by Manikandan on 15/01/25.
//

import Foundation

class Utils {
    
    public static func formatDate(date : Date,format : String = "dd-MM-yyyy HH:mm") -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}
