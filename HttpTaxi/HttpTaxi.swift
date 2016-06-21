//
//  HttpTaxi.swift
//
//  Created by Quincy Chang on 2015/12/24.
//  Copyright © 2015年 Q_mac. All rights reserved.
//
import Foundation

class HttpTaxi: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate  {

    var host:String
    var timeOutSec:Double
    var delegate:HttpTaxiDelegate
    
    init(hostURL:String, timeOutSec:Double, httpTaxiDelegate:HttpTaxiDelegate) {
        print("HostURL = "+hostURL)
        self.host = hostURL
        self.timeOutSec = timeOutSec
        self.delegate = httpTaxiDelegate
    }
    
    var task:NSURLSessionTask?
    
    // CORE API
    
    func callGET(url:String, requestStr:String) {
        let urlString = host+url+"?"+requestStr
        request(urlString, requestDic: nil, httpAction: .GET)
    }
    func callPOST(url:String, requestDic:Dictionary<String,AnyObject>) {
        let urlString = host+url
        request(urlString, requestDic: requestDic, httpAction: .POST)
    }
    func callPUT(url:String, requestDic:Dictionary<String,AnyObject>) {
        let urlString = host+url
        request(urlString, requestDic: requestDic, httpAction: .PUT)
    }
    func callDELETE(url:String, requestDic:Dictionary<String,AnyObject>) {
        let urlString = host+url
        request(urlString, requestDic: requestDic, httpAction: .DELETE)
    }
    func connectionExpired() {
        
        task?.cancel()
        task = nil
        delegate.httpTaxiCallBack(.TIMEOUT, statusCode:nil, json:nil)
    }
    func request(urlString: String, requestDic:Dictionary<String,AnyObject>?, httpAction: HttpAction){
        
        if task != nil {
            delegate.httpTaxiCallBack(.PROCESSING, statusCode:nil, json:nil)
            return
        }
        
        // Expiration Counting
        
        let timer = NSTimer(timeInterval: timeOutSec, target: self, selector: #selector(connectionExpired), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        // Before Request
        
        delegate.httpTaxiBeforeRequest(urlString)
        
        // Request
        
        let urlStr = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlStr)!)
        
        if let dic = requestDic {
            do {request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(dic, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch _ as NSError {}
        }
        
        switch httpAction {
        case .GET:
            request.HTTPMethod = "GET"
        case .POST:
            request.HTTPMethod = "POST"
        case .PUT:
            request.HTTPMethod = "PUT"
        case .DELETE:
            request.HTTPMethod = "DELETE"
        }
        task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, urlResponse, error in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                print("\(urlResponse)\n")
                
                self.task = nil
                timer.invalidate()
                
                if let httpResponse = urlResponse as? NSHTTPURLResponse {
                    let code = httpResponse.statusCode
                    
                    if let dataExisting = data {
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(dataExisting, options: []) as! [String:AnyObject]
                            self.delegate.httpTaxiCallBack(.NORMAL, statusCode:code, json:json)
                            
                        } catch let error as NSError {
                            print("json error: \(error.localizedDescription)")
                        }
                    }else{
                        print("no data")
                    }
                    
                }
            }
        }
        task?.resume()
    }
}

protocol HttpTaxiDelegate {
    func httpTaxiBeforeRequest(requestString:String)
    func httpTaxiCallBack (httpTaxiState:HttpTaxiState, statusCode:Int?, json:Dictionary<String, AnyObject>?)
}