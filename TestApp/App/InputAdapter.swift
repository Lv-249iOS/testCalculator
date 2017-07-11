//
//  InputAdapter.swift
//  AC
//
//  Created by AndreOsip on 6/28/17.
//  Copyright © 2017 AndreOsip. All rights reserved.
//

import Foundation

class IntputAdapter: InputProtocol {
    static let shared = IntputAdapter()
    var startedNum = true
    var operationClicked = false
    var pickerIsScroling = false
    var buffer: String = "0"
    var resultCollection: [String] = []
    let brain = Brain.shared
    
    
    func enterNum(_ number: Int) {
        if buffer == "" || buffer == "0" || startedNum {
            buffer = String(number)
            startedNum = false
        } else if buffer.characters.last == "." || lastCharacterIsNum(buffer) {
            if pickerIsScroling {
                BufferRemoveSubRange()
            buffer+=" "
                pickerIsScroling = false
            }
            buffer = buffer + "\(number)"
        } else {
            buffer = buffer + " \(number)"
        }
      brain.procces(buffer)
    }
    
    func enterUtility(_ symbol: Operation) {
        operationClicked = true
        
        if OperationBinary(symbol) {
            if characterOperationBinary(buffer) {
        buffer.characters.removeLast()
                switch symbol {
                case .pls: buffer += "+"
                case .mns: buffer += "-"
                case .mul: buffer += "×"
                case .div: buffer += "÷"
                default: break
                }
            } else if lastCharacterIsNum(buffer) || buffer.characters.last == ")" {
                switch symbol {
                case .pls: buffer += " +"
                case .mns: buffer += " -"
                case .mul: buffer += " ×"
                case .div: buffer += " ÷"
                default: break
                }
            }
            //else rimuvsub switch symbol buf+=
            startedNum = false
        }
        if symbol == .leftBracket {
            //if characterOperationBinary(buffer) {
            //buffer += " ("
                //brain.countOfLeftParentheses += 1
            //}
            if lastCharacterIsNum(buffer) {
            buffer += " × ("
            } else {
            buffer += " ("
            }
            brain.countOfLeftParentheses += 1
        }
            if symbol == .rightBracket {
                if !characterOperationBinary(buffer) && brain.countOfLeftParentheses > brain.countOfRightParentheses {
                buffer += " )"
                    brain.countOfRightParentheses += 1
                }
            }
        
        if symbol == .equal {
            
            
            brain.EnterEquation(equation: buffer)
            brain.equal()
            
            resultCollection.insert((buffer + " = \(brain.result!)"), at: 0)
            buffer = "\(brain.result!)"
            startedNum = true
            
            OutputAdapter.shared.reloadPicker()
            
            operationClicked = false
        }
        
        if symbol == .clear {
        buffer = "0.0"
            resultCollection = []
            OutputAdapter.shared.reloadPicker()
            brain.procces(buffer)
            startedNum = true
        
        }
        
        if OperationUnary(symbol) {
              if lastCharacterIsNum(buffer) && !startedNum || buffer.characters.last! == ")" {
                brain.countOfLeftParentheses += 1
                switch symbol {
                case .sin: buffer += " × sin ("
                case .cos: buffer += " × cos ("
                case .sqrt: buffer += " × sqrt ("
                case .log: buffer += " × ln ("
                default: break
                }
            } else if buffer.characters.last! == "(" || characterOperationBinary(buffer) {
                brain.countOfLeftParentheses += 1
                switch symbol {
                case .sin: buffer += " sin ("
                case .cos: buffer += " cos ("
                case .sqrt: buffer += " sqrt ("
                case .log: buffer += " ln ("
                default: break
                }
              } else if startedNum {
                brain.countOfLeftParentheses += 1
                startedNum = false
                switch symbol {
                case .sin: buffer = "sin ("
                case .cos: buffer = "cos ("
                case .sqrt: buffer = "sqrt ("
                case .log: buffer = "ln ("
                default: break
                }
            }
        }
        
        brain.procces(buffer)
        }
    

    
    func checkBufferEnding() -> Bool{
        if buffer.characters.last! >= "0" && buffer.characters.last! <= "9" {
        return true
        } else {
            return false
        }
    }
    func BufferRemoveSubRange () {
        let lastSpaceIndex = buffer.range(of: " ", options: String.CompareOptions.backwards, range: nil, locale: nil)?.lowerBound 
        let ending = buffer.index(before: buffer.endIndex)
        if buffer != "" {
            buffer.removeSubrange(lastSpaceIndex!...ending)}
    }
    
    
}
func OperationBinary (_ symbol: Operation) ->Bool {
    switch symbol {
    case .pls: fallthrough
    case .mns: fallthrough
    case .mul: fallthrough
    case .div: return true
    default: return false
        
    }
    }

func OperationUnary (_ symbol: Operation) ->Bool {
    switch symbol {
    case .sin: fallthrough
    case .cos: fallthrough
    case .sqrt: fallthrough
    case .log: return true
    default: return false
        
    }
}
func characterOperationBinary (_ symbol: String) ->Bool {
    switch symbol.characters.last! {
    case "+": fallthrough
    case "-": fallthrough
    case "×": fallthrough
    case "÷": return true
    default: return false
        
    }
}
func lastCharacterIsNum (_ str: String) -> (Bool) {
    if str.characters.last! >= "0" && str.characters.last! <= "9" {
    return true
    } else {return false}
}

//func lastCharacterIsBracket (_ str: String) -> (Bool) {
//    if str.characters.last! >= "0" && str.characters.last! <= "9" {
//        return true
//    } else {return false}
//}
