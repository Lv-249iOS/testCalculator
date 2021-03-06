//
//  Protocols.swift
//  AC
//
//  Created by AndreOsip on 6/28/17.
//  Copyright © 2017 AndreOsip. All rights reserved.
//

import Foundation

protocol InputProtocol {
    func enterNum(_ number: Int)
    func enterUtility(_ symbol: Operation)
}

protocol OutputProtocol {
    func presentResult(result: String)
}

protocol Model {
    func EnterEquation(equation: String)
}

enum Operation: Int {
    case pls = 10001
    case mns = 10002
    case mul = 10003
    case div = 10004
    case pow = 10005
    case sqrt = 10006
    case sin = 10007
    case cos = 10008
    case log = 10009
    case leftBracket = 10010
    case rightBracket = 10011
    case pi = 10012
    case equal = 10013
    case clear = 10014
    case dot = 10015
    case sign = 10016
}
