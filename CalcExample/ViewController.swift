//
//  ViewController.swift
//  CalcExample
//
//  Created by Admin on 2016-07-19.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Foundation
import Darwin


struct StringStack {
    var items = [String]()
    mutating func push(item: String) {
        items.append(item)
    }
    mutating func pop() -> String {
        return items.removeLast()
    }
    mutating func peek() -> String {
        return items.last!;
    }
    mutating func count() -> Int {
        return items.count
    }
    mutating func show() {
        print(items)
    }
}

class ViewController: UIViewController {
    
    private var decimalFlag:Bool = false;
    private var radiansFlag:Bool = false;
    
    @IBOutlet weak var calcDisplay: UILabel!;
    
    private var operations = StringStack();
    
    
    // MARK - Private methods
    
    //Fired when device's orientation changes
    func orientationChanged()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("orientation is landscape");
            hideOrShowButtons(false);
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("orientation is portrait");
            hideOrShowButtons(true);
        }
        
    }
    
    func hideOrShowButtons(shouldHide: Bool){
        for view in self.view.subviews as [UIView] {
            if let btn = view as? ExtraCommandButton {
                btn.hidden = shouldHide;
            }
        }
    }
    
    //Calculates total from operations stack
    func caculateTotal() -> Float {
        if operations.count() == 0 {
            return 0;
        }
        if operations.count()%2 == 0 {
            operations.pop();
        }
        
        var currTotal:Float = Float(operations.pop())!;
        while(operations.count() > 0){
            let currCommand:String = operations.pop();
            let nextNumber:Float = Float(operations.pop())!;
            
            if(currCommand == "DIV"){
                currTotal = nextNumber/currTotal;
            }else if(currCommand == "MUL"){
                currTotal = currTotal*nextNumber;
            }else if(currCommand == "SUB"){
                currTotal = nextNumber - currTotal;
            }else if(currCommand == "ADD"){
                currTotal = currTotal + nextNumber;
            }
        }
        return currTotal;
    }
    
    func factorial(n: Float) -> Float {
        if n >= 0 {
            return n == 0 ? 1 : n * self.factorial(n - 1)
        } else {
            return 0 / 0
        }
    }

    // MARK - Overrides
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)

    }
    
    // MARK - Event handlers
    
    @IBAction func buttonSingleAction(sender: ExtraCommandButton){
        let resultButton = sender;
        var resultString:String = resultButton.currentTitle!;
    
        if operations.count()%2 != 0 {
            var currOutput:Float = Float(operations.pop())!;

            switch resultString {
                case ("1/x"):
                    currOutput = 1/currOutput;
                case ("x^2"):
                    currOutput = pow(currOutput,2);
                case ("x^3"):
                    currOutput = pow(currOutput,3);
                case ("x^1/2"):
                    currOutput = pow(currOutput, 1/2);
                case ("x^1/3"):
                    currOutput = pow(currOutput, 1/3);
                case ("10^x"):
                    currOutput = pow(10, currOutput);
                case ("log10"):
                    currOutput = log10(currOutput);
                case ("ln"):
                    currOutput = log(currOutput);
                case ("x!"):
                    currOutput = factorial(currOutput);
                case ("sin"):
                    currOutput = sin(currOutput);
                case ("cos"):
                    currOutput = cos(currOutput);
                case ("tan"):
                    currOutput = tan(currOutput);
                case("tanh"):
                    currOutput = atan(currOutput);
                case("cosh"):
                    currOutput = atan(1/currOutput);
                case("sinh"):
                    currOutput = Float(M_PI/2) - Float(atan(1/currOutput))
                case(_):
                    print("could not find match")
            }
            
            print(String(currOutput));
            operations.push(String(currOutput));
            resultString = String(currOutput);
        }
        
        calcDisplay.text = resultString;
    }
    
    @IBAction func numberButtonAction(sender: ExtraCommandButton){
        let resultButton = sender;
        var resultString:String = resultButton.currentTitle!;
        var oldString:String = "";
        
        if operations.count()%2 == 0 {
            operations.push(resultString);
        }else if(decimalFlag){
            oldString = operations.pop();
            let needle:Character = "."
            
            if let idx = oldString.characters.indexOf(needle) {
                resultString = oldString + resultString;
            } else {
                resultString = oldString + "." + resultString;
            }
            operations.push(resultString);
        } else {
            oldString = operations.pop();
            resultString = oldString + resultString;
            operations.push(resultString);
        }
        
        calcDisplay.text = resultString;
    }
    
    @IBAction func commandButtonAction(sender: UIButton){
        let resultButton = sender;
        let resultString:String = resultButton.currentTitle!;
        
        switch resultString {
            case("C"):
                calcDisplay.text = "0";
                decimalFlag = false;
                operations = StringStack();
                radiansFlag = false;
            case("π"):
                if(operations.count()%2 == 0){
                    operations.push(String(M_PI));
                }else {
                    operations.pop();
                    operations.push(String(M_PI));
                }
                calcDisplay.text = String(M_PI);
            case("Φ"):
                if(operations.count()%2 == 0){
                    operations.push(String(M_PI));
                }else {
                    operations.pop();
                    operations.push(String(M_PI));
                }
                calcDisplay.text = String(M_PI);
            case("-/+"):
                if(operations.count()%2 != 0){
                    var lastInt:Float = Float(operations.pop())!;
                    lastInt = 0 - lastInt;
                    operations.push(String(lastInt));
                    calcDisplay.text = String(lastInt);
                }
            case("."):
                decimalFlag = true;
            case("Rad"):
                radiansFlag = true;
            case("="):
                decimalFlag = false;
                if(operations.count()%2 != 0 && operations.count() > 1){
                    let total:Float = caculateTotal();
                    operations.push(String(total));
                    print(total);
                    calcDisplay.text = String(total);
                    radiansFlag = false;
                }
            case(_):
                if(operations.count()%2 != 0){
                    if(resultString == "/"){
                        operations.push("DIV");
                    }else if(resultString == "*"){
                        operations.push("MUL");
                    }else if(resultString == "-"){
                        operations.push("SUB");
                    }else if(resultString == "+"){
                        operations.push("ADD");
                    }
                }else{
                    print("Command key not recognized");
                }
        }
        

    
    }

}

