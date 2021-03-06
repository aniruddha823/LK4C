//
//  FMPquery.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/7/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FMPquery {
    static var baseURL = "https://www.financialmodelingprep.com/api/v3/"
    static let apikey = "86e6aa7801cc28243c6066cf7e65712d"
    // private var context = PersistenceService.context
    
    // Gets the current price of a stock by its ticker/symbol
    class func getCurrentPrice(symbol: String, completionHandler: @escaping (Double) -> ()) {
        guard let url = URL(string: baseURL + "stock/real-time-price/\(symbol)?apikey=\(apikey)" ) else { return }
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            guard response.result.isSuccess else { return }
            
            let json = JSON(response.result.value)
            let price = json["price"].doubleValue
            
            completionHandler(price)
        }
    }
    
    class func getProfile(symbol: String, completionHandler: @escaping (String, Double, Double, String, String, String, String, String, String, String, Int) -> ()) {
        guard let url = URL(string: baseURL + "profile/\(symbol)?apikey=\(apikey)") else { return }
        
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
            
            let json = JSON(response.result.value)
            
            let ticker = json[0]["symbol"].stringValue
            let mkcp = json[0]["mktCap"].doubleValue
            let avgv = json[0]["volAvg"].doubleValue
            let pchg = json[0]["changes"].stringValue
            let cmpn = json[0]["companyName"].stringValue
            let cmpi = json[0]["industry"].stringValue
            let cmpw = json[0]["website"].stringValue
            let cmpd = json[0]["description"].stringValue
            let cmpc = json[0]["ceo"].stringValue
            let cmpl = json[0]["image"].stringValue
            let cmpe = json[0]["fullTimeEmployees"].intValue
            
            completionHandler(ticker, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl, cmpe)
        }
    }
    
    class func getQuote(symbol: String, completionHandler: @escaping (Double, Double, Double, Double, Double, Double) -> ()) {
        guard let url = URL(string: baseURL + "quote/\(symbol)?apikey=\(apikey)") else { return }

        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }

            let json = JSON(response.result.value)

            let open = json[0]["open"].doubleValue
            let high = json[0]["dayHigh"].doubleValue
            let low = json[0]["dayLow"].doubleValue
            let volume = json[0]["volume"].doubleValue
            let per = json[0]["pe"].doubleValue
            let mcap = json[0]["marketCap"].doubleValue

            completionHandler(open, high, low, volume, per, mcap)
        }
    }
    
    class func getAlternateQuote(symbol: String, completionHandler: @escaping (Double, String, Double, Double, String, String) -> ()) {
        guard let url = URL(string: baseURL + "historical-price-full/\(symbol)?timeseries=1&apikey=\(apikey)") else { return }
        
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
            
            let json = JSON(response.result.value)
            
            let date = json["historical"][0]["date"].stringValue
            let open = json["historical"][0]["open"].doubleValue
            let close = json["historical"][0]["close"].stringValue
            let high = json["historical"][0]["high"].doubleValue
            let low = json["historical"][0]["low"].doubleValue
            let pchg = json["historical"][0]["changePercent"].stringValue
            
            completionHandler(open, close, high, low, pchg, date)
        }
    }
    
    class func getDayChart(symbol: String, completionHandler: @escaping ([Double], [Double], [String]) -> ()) {
        guard let url = URL(string: baseURL + "historical-chart/5min/\(symbol)?apikey=\(apikey)") else { return }
            
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
                
            let json = JSON(response.result.value)
            var dayPrices = [Double]()
            var dayPercentages = [Double]()
            var dayDates = [String]()
            
            for i in 0...79 {
                dayPrices.insert(json[i]["close"].doubleValue, at: 0)
            }
            
            for i in 1...79 {
                let percentage = ((dayPrices[i] / dayPrices[i - 1]) - 1) * 100
                
                dayPercentages.insert(percentage, at: 0)
                dayDates.insert(json[i - 1]["date"].stringValue, at: 0)
            }
            
            print(dayPrices)
            
            completionHandler(dayPrices.suffix(79), dayPercentages, dayDates)
        }
    }
    
    class func getWeekChart(symbol: String, completionHandler: @escaping ([Double], [Double], [String]) -> ()) {
        guard let url = URL(string: baseURL + "historical-price-full/\(symbol)?timeseries=7&apikey=\(apikey)") else { return }
            
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
                
            let json = JSON(response.result.value)
            var weekPrices = [Double]()
            var weekPercentages = [Double]()
            var weekDates = [String]()
                
            // Should only loop once
            for (_, day) in json["historical"] {
                weekPrices.insert(day["vwap"].doubleValue, at: 0)
                weekPercentages.insert(day["changePercent"].doubleValue, at: 0)
                weekDates.insert(day["date"].stringValue, at: 0)
            }
                
            completionHandler(weekPrices, weekPercentages, weekDates)
        }
    }
    
    class func getMonthChart(symbol: String, completionHandler: @escaping ([Double], [Double], [String]) -> ()) {
        guard let url = URL(string: baseURL + "historical-price-full/\(symbol)?timeseries=30&apikey=\(apikey)") else { return }
        
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
            
            let json = JSON(response.result.value)
            var monthPrices = [Double]()
            var monthPercentages = [Double]()
            var monthDates = [String]()
            
            // Should only loop once
            for (_, day) in json["historical"] {
                monthPrices.insert(day["vwap"].doubleValue, at: 0)
                monthPercentages.insert(day["changePercent"].doubleValue, at: 0)
                monthDates.insert(day["date"].stringValue, at: 0)
            }
            
            completionHandler(monthPrices, monthPercentages, monthDates)
        }
    }
    
    class func getYearChart(symbol: String, completionHandler: @escaping ([Double], [Double], [String]) -> ()) {
        guard let url = URL(string: baseURL + "historical-price-full/\(symbol)?timeseries=252&apikey=\(apikey)") else { return }
            
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
                
            let json = JSON(response.result.value)
            var yearPrices = [Double]()
            var yearPercentages = [Double]()
            var yearDates = [String]()
                
            // Should only loop once
            for (_, day) in json["historical"] {
                yearPrices.insert(day["vwap"].doubleValue, at: 0)
                yearPercentages.insert(day["changePercent"].doubleValue, at: 0)
                yearDates.insert(day["date"].stringValue, at: 0)
            }
                
            completionHandler(yearPrices, yearPercentages, yearDates)
        }
    }
    
    class func getTwoYearChart(symbol: String, completionHandler: @escaping ([Double], [Double], [String]) -> ()) {
        guard let url = URL(string: baseURL + "historical-price-full/\(symbol)?timeseries=504&apikey=\(apikey)") else { return }
            
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
                
            let json = JSON(response.result.value)
            var twoYearPrices = [Double]()
            var twoYearPercentages = [Double]()
            var twoYearDates = [String]()
                
            // Should only loop once
            for (_, day) in json["historical"] {
                twoYearPrices.insert(day["vwap"].doubleValue, at: 0)
                twoYearPercentages.insert(day["changePercent"].doubleValue, at: 0)
                twoYearDates.insert(day["date"].stringValue, at: 0)
            }
                
            completionHandler(twoYearPrices, twoYearPercentages, twoYearDates)
        }
    }
    
    class func getMChart(symbol: String, datefrom: String, dateto: String, completionHandler: @escaping ([Double], [Double], [String]) -> ()) {
        guard let url = URL(string: baseURL + "historical-price-full/\(symbol)?from=\(datefrom)&to=\(dateto)&apikey=\(apikey)") else { return }
    
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
    
            let json = JSON(response.result.value)
            var weekPrices = [Double]()
            var weekPercentages = [Double]()
            var weekDates = [String]()
    
            // Should only loop once
            for (_, day) in json["historical"] {
                weekPrices.insert(day["vwap"].doubleValue, at: 0)
                weekPercentages.insert(day["changePercent"].doubleValue, at: 0)
                weekDates.insert(day["date"].stringValue, at: 0)
            }
    
            completionHandler(weekPrices, weekPercentages, weekDates)
        }
    }
    
    class func getStockList(completionHandler: @escaping ([String:String]) -> ()) {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/company/stock/list?apikey=\(apikey)") else { return }
        
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
            
            let json = JSON(response.result.value)
            var result = [String:String]()
            
            for (_, object) in json["symbolsList"] {
                let symbol = object["symbol"].stringValue
                let name = object["name"].stringValue
                
                result[symbol] = name
            }
            
            completionHandler(result)
        }
    }
    
    class func getBalanceSheet(symbol: String, completionHandler: @escaping (Data) -> ()) {
        guard let url = URL(string: baseURL + "balance-sheet-statement/\(symbol)?period=quarter&limit=12&apikey=\(apikey)") else { return }
            
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
                
            let json = JSON(response.result.value)
            let bs = response.data!
            
            completionHandler(bs)
        }
        
    }
    
    class func getIncomeStatement(symbol: String, completionHandler: @escaping (Data) -> ()) {
        guard let url = URL(string: baseURL + "income-statement/\(symbol)?period=quarter&limit=12&apikey=\(apikey)") else { return }
            
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
                
            let json = JSON(response.result.value)
            let incst = response.data!
            
            completionHandler(incst)
        }
        
    }
    
    class func getCashFlowStatement(symbol: String, completionHandler: @escaping (Data) -> ()) {
        guard let url = URL(string: baseURL + "cash-flow-statement/\(symbol)?period=quarter&limit=12&apikey=\(apikey)") else { return }
            
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
                
            let json = JSON(response.result.value)
            let cft = response.data!
            
            completionHandler(cft)
        }
        
    }
    
    class func getNews(symbol: String, completionHandler: @escaping ([Article]) -> ()) {
        guard let url = URL(string: baseURL + "stock_news?tickers=\(symbol)&limit=10&apikey=\(apikey)") else { return }
            
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else { return }
                
            let json = JSON(response.result.value)
            var articles = [Article]()
            
            for (_, object) in json {
                let title = object["title"].stringValue
                let imageURL = object["image"].stringValue
                let siteName = object["site"].stringValue
                let articleURL = object["url"].stringValue
                let datePublished = object["publishedDate"].stringValue
                
                articles.append(Article(title: title, imageURL: imageURL, siteName: siteName, articleURL: articleURL, datePublished: datePublished))
            }
            
            completionHandler(articles)
        }
        
    }
}

struct Article {
    var title: String
    var imageURL: String
    var siteName: String
    var articleURL: String
    var datePublished: String
}
