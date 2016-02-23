//
//  ViewController.swift
//  Calculator
//
//  Created by Himanshi Bhardwaj on 12/7/15.
//  Copyright (c) 2015 Himanshi Bhardwaj. All rights reserved.
//

import UIKit


class ViewController: UIViewController
{
    // display: Instance variable property
    // Holds current output of the calculator which gets displayed on the calculation bar
    @IBOutlet weak var display: UILabel! // Implicitely unwrapped optional
    
    var userIsInTheMiddleOfTypingNumber = false //: Bool = false
    
    var numberHasADecimalPoint = false
    
    // operandStack: of type Array<Double>
    // Holds the current operand Stack
    var operandStack = Array<Double>()
    
    // operandStack: of type Double
    // Gets value from display.text! String into Double
    // Sets value of display.text String into String
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }
    
    var changeCBack = false
    var cIsChangedToAC = false
    
    // Object oriented method appendDigit()
    // is called after a digit key is pressed
    // Input: sender is of type UIButton, takes digits as input
    // Appends the input's title to display
    @IBAction func appendDigit(sender: UIButton) {
        if cIsChangedToAC {
            changeCBack = true
            //see see ClearLastOrAll()
        }
        
        // let denotes constant, a good practice, increases readability
        let digit = sender.currentTitle! //! unwraps optional
        // if we try to unwrap an optional to be nil, then app crashes
        
        if( numberHasADecimalPoint && digit == ".") {
            // do nothing ; additional decimal point not allowed
        }
        else {
            if (digit == ".") {
                numberHasADecimalPoint = true
            }
            if userIsInTheMiddleOfTypingNumber && display.text != "0" {
                //println("digit = \(digit)")
                display.text = display.text! + digit
            }
            else {
                //println("digit = \(digit)")
                display.text = digit
                userIsInTheMiddleOfTypingNumber = true
                }
            }
    }
    
    
    // Object oriented method operate()
    // is called after an operator key is pressed
    // Input: sender is of type UIButton, takes operator as input
    // Performs an operation on the last two digits on the operandStack based on sender input
    // and replaces them(last two digits on the operandStack) with the output result
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        switch operation {
        case "✖️":
            // performOperation({(op1, op2) in return op1 * op2})
            // performOperation({(op1, op2) in op1 * op2})
            //performOperation({ $0 * $1 })
            //performOperation() {$0 * $1} //last argument can go out of paranthesis
            performOperationBinary { $0 * $1 }
        case "➗":
            if operandStack.last == 0 {
                display.text = "Undefined"
            }
            else {
                performOperationBinary { $1 / $0 }
            }
        case "➕":
            performOperationBinary { $1 + $0 }
        case "➖":
            performOperationBinary { $1 - $0 }
        case "%":
            performOperationBinary { $1 % $0 }
        case "sin":
            performOperationUnary { sin($0) }
        case "cos":
            performOperationUnary { cos($0) }
        case "tan":
            performOperationUnary { tan($0) }
        case "π":
            displayValue =  M_PI
            enter()
        case "√":
            performOperationUnary { sqrt($0) }
        case "±":
            performOperationUnary { -$0  }
        default:
            break
        }
    }
    
    
    // Method performOperationBinary
    // Input: Takes operator function as input
    // Changes the value of displayValue with the output of operation function and calls enter()
    // Method operation(overloaded)
    // Input: Two Double numbers
    // Returns the calculator result based on the specified operator used
    func performOperationBinary(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    
    // Method performOperationUnary
    // Input: Takes operator function as input
    // Changes the value of displayValue with the output of operation function and calls enter()
    // Method operation(overloaded)
    // Input: One Double number
    // Returns the calculator result based on the specified operator used
    func performOperationUnary(operation: Double -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
    // Object oriented method enter()
    // is called after the enter key is pressed
    // Updates operandStack and sets userIsInTheMiddleOfTypingNumber back to false
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        numberHasADecimalPoint = false
        if (display.text! != "Undefined") {
            operandStack.append(displayValue)
        }
        print("operandStack = \(operandStack)")
    }
    
    
    // Object oriented method clear()
    // is called after the AC key is pressed, AC = All Clear
    // Clears the operandStack and sets userIsInTheMiddleOfTypingNumber back to false
    @IBAction func clear() {
        display.text = "0"
        userIsInTheMiddleOfTypingNumber = false
        //operandStack.removeLast()
        if operandStack .isEmpty {
            //do nothing
        }
        else {
            operandStack.removeAll()
        }
        print("operandStack = \(operandStack)")
    }
    
    @IBAction func ClearLastOrAll(sender: UIButton) {
        userIsInTheMiddleOfTypingNumber = false
        if changeCBack {
            sender.setTitle("C", forState: UIControlState.Normal)
            changeCBack = false
            cIsChangedToAC = false
        }
        else if sender.currentTitle == "C" {
            sender.setTitle("AC", forState: UIControlState.Normal)
            cIsChangedToAC = true
            if operandStack .isEmpty {
                display.text = "0"
            }
            else if operandStack.count == 1 {
                operandStack.removeLast()
                display.text = "0"
            }
            else {
                operandStack.removeLast()
                displayValue = operandStack.last!
            }
        }
        else if sender.currentTitle == "AC" {
            display.text = "0"
            userIsInTheMiddleOfTypingNumber = false
            //operandStack.removeLast()
            if operandStack .isEmpty {
                //do nothing
            }
            else {
                operandStack.removeAll()
            }
        }
        print("operandStack = \(operandStack)")
    }
    
    // Object oriented method clearLast()
    // is called after the C key is pressed, C = Clear Immediate
    // Clears the last value on operandStack and sets userIsInTheMiddleOfTypingNumber back to false
    @IBAction func clearLast() {
        userIsInTheMiddleOfTypingNumber = false
        if operandStack .isEmpty {
            display.text = "0"
        }
        else if operandStack.count == 1 {
            operandStack.removeLast()
            display.text = "0"
        }
        else {
            operandStack.removeLast()
            displayValue = operandStack.last!
        }
        print("operandStack = \(operandStack)")
    }
}