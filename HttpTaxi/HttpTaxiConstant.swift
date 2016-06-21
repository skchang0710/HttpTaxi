//
//  HttpTaxiConstant.swift
//  Ticket
//
//  Created by Quincy Chang on 2016/6/21.
//  Copyright © 2016年 Q_mac. All rights reserved.
//

public enum HttpAction{
    case GET
    case POST
    case PUT
    case DELETE
}

public enum HttpTaxiState{
    case PROCESSING
    case ERROR
    case TIMEOUT
    case NORMAL
}
    