//
//  HttpTaxiDelegate.swift
//  HttpTaxi
//
//  Created by Quincy Chang on 2016/6/22.
//  Copyright © 2016年 Quincy Chang. All rights reserved.
//

public protocol HttpTaxiDelegate {
    
    // use this function to make loading effect.
    
    func httpTaxiBeforeRequest(requestString:String)
    
    // use this function to fetch response message. ( json or error or timeout )
    
    func httpTaxiCallBack(httpTaxiState:HttpTaxiState, statusCode:Int?, json:Dictionary<String, AnyObject>?)
}