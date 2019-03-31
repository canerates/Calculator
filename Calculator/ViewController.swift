//
//  ViewController.swift
//  Calculator
//
//  Created by Django on 4/22/18.
//  Copyright © 2018 Caner Ates. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var brain: CalculatorBrain = CalculatorBrain()
    var isResultEmpty = true
    var isProgressEmpty = true
    var isOperationRunning = false
    var isDecimal = false
    var isSecondNumber = false
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBAction func touchNumber(_ sender: UIButton) {
        if !(resultLabel.text! == "0" && sender.tag == 0) {
            let currentResultLabel = resultLabel.text!
            if currentResultLabel.count <= 6 || isResultEmpty
            {
                displayResultLabelWithTag(tag: sender.tag)
                displayProgressLabelWithTag(tag: sender.tag)
            }
            let number = progressLabel.text!
            if !(isOnlyNumber(text: number, delimiter: "+") && isOnlyNumber(text: number, delimiter: "-") && isOnlyNumber(text: number, delimiter: "×") && isOnlyNumber(text: number, delimiter: "÷"))
            {
                isSecondNumber = true
            }
        }
    }
    
    @IBAction func touchOperation(_ sender: UIButton) {
       
        if (!isResultEmpty && !isSecondNumber && sender.tag != 15) || (isSecondNumber && sender.tag == 15) {
            isOperationRunning = true
            isProgressEmpty = false
            displayProgressLabelWithTag(tag: sender.tag)
            brain.setAccumulator(operand: Double(resultLabel.text!)!)
            brain.performOperation(index: sender.tag)
            isResultEmpty = true
            isDecimal = false
            isSecondNumber = false
            getResult()
        }
        else if sender.tag != 15 && !isSecondNumber{
            isOperationRunning = true
            isProgressEmpty = false
            printProgressLabel(text: resultLabel.text! + brain.operationSymbol[sender.tag]!)
            isOperationRunning = false
            brain.setAccumulator(operand: Double(resultLabel.text!)!)
            brain.performOperation(index: sender.tag)
            isResultEmpty = true
            isDecimal = false
            getResult()
        }
    }
    
    @IBAction func touchAllClear(_ sender: UIButton) {
        printResultLabel(text: "0")
        printProgressLabel(text: "0")
        isResultEmpty = true
        isProgressEmpty = true
        isOperationRunning = false
        isSecondNumber = false
        isDecimal = false
        brain.cleanData()
    }
    
    @IBAction func touchDecimal(_ sender: UIButton) {
        if (!isResultEmpty && !isDecimal) || (isResultEmpty && resultLabel.text! == "0")
        {
            let currentResultLabel = resultLabel.text!
            printResultLabel(text: currentResultLabel + ".")
            
            let currentProgressLabel = progressLabel.text!
            printProgressLabel(text: currentProgressLabel + ".")
            
            isResultEmpty = false
            isProgressEmpty = false
            isDecimal = true
        }
    }
    
    func displayProgressLabelWithTag(tag: Int)
    {
        if isProgressEmpty
        {
            printProgressLabel(text: String(tag))
            isProgressEmpty = false
        }
        else
        {
            let currentProgressLabel = progressLabel.text!
            if !isOperationRunning
            {
                printProgressLabel(text: currentProgressLabel + String(tag))
            }
            else
            {
                if 11...16 ~= tag
                {
                    printProgressLabel(text: currentProgressLabel + brain.operationSymbol[tag]!)
                }
                else if tag == 20
                {
                    printProgressLabel(text: brain.operationSymbol[tag]! + "(" + currentProgressLabel + ")=")
                }
                isOperationRunning = false
            }
        }
    }
    func displayResultLabelWithTag(tag: Int)
    {
        if isResultEmpty
        {
            printResultLabel(text: String(tag))
            isResultEmpty = false
        }
        else
        {
            let currentResultLabel = resultLabel.text!
            printResultLabel(text: currentResultLabel + String(tag))
        }
    }
    
    func getResult() {
        if let result = brain.result {
            if String(result) != "inf" {
                let isInteger = floor(result)
                if isInteger == result {
                    printResultLabel(text: String(Int(result)))
                }
                else
                {
                    printResultLabel(text: String(result))
                }
            }
            else {
                printResultLabel(text: "0")
            }
            isProgressEmpty = true
        }
    }
    
    func printResultLabel(text: String) {
        var textOnLabel = text
        if textOnLabel.count > 8
        {
            textOnLabel = String(textOnLabel[textOnLabel.startIndex..<textOnLabel.index(textOnLabel.startIndex, offsetBy: 8)])
        }
        resultLabel.text = textOnLabel
    }
    
    func printProgressLabel(text: String) {
        progressLabel.text = text
    }
    
    func isOnlyNumber (text: String, delimiter: String) -> Bool {
        if text.range(of: delimiter) == nil {
            return true
        }
        else {return false}
    }
}

