//
//  ViewController.swift
//  SBIntelligentKeyBoardDemo
//
//  Created by Sandeep Bhandari on 09/08/16.
//  Copyright © 2016 Sandeep Bhandari. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,SBKeyBoardProtocol{
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //all you have to write now is
        self.textField.configure()
        self.textField.sbkeyboardDelegate = self
        self.textField.delegate = self

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
}

