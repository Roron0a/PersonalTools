//
//  NSDate+Extension.swift
//  Hot-Hu
//
//  Created by mac on 4/18/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import Foundation


extension Date {
    static func today() -> String {
        let dataFormmater : DateFormatter = DateFormatter()
        dataFormmater.dateFormat = "yyyy-MM-dd"
        let now : Date = Date()
        return dataFormmater.string(from: now)
    }
    
    //check if it is today
    static func isToday (dateString:String) -> Bool {
        return dateString == self.today()
    }
    
    //check if it is yesterday
    static func isYesterday (dateString:String) -> Bool {
        let todayTimestamp = self.getTimestamp(dateString: today())
        let yesterdayTimestamp = self.getTimestamp(dateString: dateString)
        return yesterdayTimestamp == todayTimestamp - (24*60*60)
    }
    
    
    
    // yyyy-MM-dd to MM-dd
    static func formatDay(dateString:String) -> String {
        if dateString.Lengh <= 0 {
            return "errorDate"
        }
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date:Date = dateFormatter.date(from: dateString)!
        
        //convert to MM-DD
        let newDateFormmater:DateFormatter = DateFormatter()
        newDateFormmater.dateFormat = "MM月dd日"
        return newDateFormmater.string(from:date)
    }
    
    //get timestamp by time
    static func getTimestamp (dateString:String) -> TimeInterval {
        if dateString.Lengh <= 0 {
            return 0
        }
        let newDateString = dateString.appending("00:00:00")
        let formatter:DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.dateStyle = DateFormatter.Style.short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Beijing")
        
        let dateNow = formatter.date(from: newDateString)
        
        return (dateNow?.timeIntervalSince1970)!
    }
    
    //get week by timestamp
    static func weekWithDateString(dateString:String) -> String {
        let timestamp = Date.getTimestamp(dateString:dateString)
        let day = Int(timestamp/86400)
        let array : Array = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"];
        return array[(day-3)%7]
    }
}
