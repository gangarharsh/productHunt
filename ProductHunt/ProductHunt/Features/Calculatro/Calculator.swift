//
//  Calculator.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 21/02/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation
class Calculator{
    class func calculate(a:Any, b:Any) -> Int?{
        if let a1 = a as? Int, let b1 = b as? Int{
               return a1 + b1
        }
        return nil
    }
    class func calculateMe(a:Any, b:Any) -> Int?{
        if let a1 = a as? Int, let b1 = b as? Int{
               return a1 + b1
        }
        return nil
    }
}

