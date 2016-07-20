//
//  ViewController.swift
//  CalcExample
//
//  Created by Admin on 2016-07-19.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var calcDisplay: UILabel!;
    
    private var operations = StringStack();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numberButtonAction(sender: UIButton){
        let resultButton = sender;
        var resultString:String = resultButton.currentTitle!;
    
        if operations.count()%2 == 0 {
            operations.push(resultString);
        }else if(decimalFlag){
            let oldString:String = operations.pop();
            let needle:Character = "."
            
            if let idx = oldString.characters.indexOf(needle) {
                resultString = oldString + resultString;
            } else {
                resultString = oldString + "." + resultString;
            }
            operations.push(resultString);
        }
        
        calcDisplay.text = resultString;
    }
    
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
    
    @IBAction func commandButtonAction(sender: UIButton){
        let resultButton = sender;
        let resultString:String = resultButton.currentTitle!;
        
        if(resultString == "C"){
            calcDisplay.text = "0";
            decimalFlag = false;
            operations = StringStack();
            
        }else if(resultString == "-/+"){
            if(operations.count()%2 != 0){
                var lastInt:Float = Float(operations.pop())!;
                lastInt = 0 - lastInt;
                operations.push(String(lastInt));
                calcDisplay.text = String(lastInt);
            }
        }else if(resultString == "."){
            decimalFlag = true;
        }else if(resultString == "="){
            decimalFlag = false;
            if(operations.count()%2 != 0 && operations.count() > 1){
                let total:Float = caculateTotal();
                operations.push(String(total));
                print(total);
                calcDisplay.text = String(total);
            }
        }else if(operations.count()%2 != 0){
        
            if(resultString == "/"){
                operations.push("DIV");
            }else if(resultString == "*"){
                operations.push("MUL");
            }else if(resultString == "-"){
                operations.push("SUB");
            }else if(resultString == "+"){
                operations.push("ADD");
            }
        }
    
    }

}

