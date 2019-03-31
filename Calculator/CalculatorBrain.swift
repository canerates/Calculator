//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Django on 4/22/18.
//  Copyright © 2018 Caner Ates. All rights reserved.
//

import Foundation

struct CalculatorBrain
{
    var accumulator: Double!
    
    var operationSymbol: Dictionary<Int, String> =
    [
        11: "+",
        12: "-",
        13: "×",
        14: "÷",
        15: "=",
        16: "%",
        20: "±"
    ]
    
    enum Operation
    {
        case addition((Double, Double) -> Double)
        case subtraction((Double, Double) -> Double)
        case multiplication((Double, Double) -> Double)
        case division((Double, Double) -> Double)
        case changeSign((Double) -> Double)
        case percentage((Double) -> Double)
        case equal
    }
    
    var operations: Dictionary <Int, Operation> =
    [
        11: Operation.addition({$0 + $1}),
        12: Operation.subtraction({$0 - $1}),
        13: Operation.multiplication({$0 * $1}),
        14: Operation.division({$0 / $1}),
        15: Operation.equal,
        20: Operation.changeSign({-$0}),
        16: Operation.percentage({$0 / 100})
    ]
    
    mutating func performOperation(index: Int) {
        if let operation = operations[index] {
            switch operation {
            case .addition(let function):
                if accumulator != nil {
                    pendingOperation = pendingOperator(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .subtraction(let function):
                if accumulator != nil {
                    pendingOperation = pendingOperator(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .multiplication(let function):
                if accumulator != nil {
                    pendingOperation = pendingOperator(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .division(let function):
                if accumulator != nil {
                    pendingOperation = pendingOperator(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .changeSign(let function):
                accumulator = function(accumulator)
            case .equal:
                executePendingOperation()
            case .percentage(let function):
                accumulator = function(accumulator)
            }
        }
    }
    
    mutating func executePendingOperation() {
        if pendingOperation != nil && accumulator != nil {
            accumulator = pendingOperation!.calculate(with: accumulator!)
            pendingOperation = nil
        }
    }
    
    private var pendingOperation: pendingOperator?
    
    struct pendingOperator {
        let function: (Double, Double) -> (Double)
        let firstOperand: Double
        
        func calculate(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setAccumulator(operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func cleanData() {
        pendingOperation = nil
    }
}
