//
//  SBTextField.swift
//  TestCode
//
//  Created by Sandeep Bhandari on 08/08/16.
//  Copyright © 2016 Sandeep Bhandari. All rights reserved.
//

import UIKit

var SBKeyboardDelegate: UInt8 = 100
var SBKeyboardShouldInformContinousKeyBoardFrameChange: UInt8 = 101
var SBKeyboardShouldHandleUI : UInt8 = 102

@objc public protocol SBKeyBoardProtocol : NSObjectProtocol {
    optional func keyboardWillAppear(forTextField textField : UITextField);
    optional func keyboardDidHide(forTextField textField : UITextField);
    optional func keyboardFrameDidChange(changedFrame : CGRect, forTextField textField : UITextField);
}

extension UITextField : KeyBoardObserverProtocol{
    
    var sbkeyboardDelegate:SBKeyBoardProtocol? {
        get {
            return objc_getAssociatedObject(self, &SBKeyboardDelegate) as? SBKeyBoardProtocol
        }
        set {
            objc_setAssociatedObject(self, &SBKeyboardDelegate, newValue as? AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var shouldInformContinousKeyBoardFrameChange:Bool {
        get {
            return objc_getAssociatedObject(self, &SBKeyboardShouldInformContinousKeyBoardFrameChange) as! Bool
        }
        set {
            objc_setAssociatedObject(self, &SBKeyboardShouldInformContinousKeyBoardFrameChange, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var shouldHandleUI:Bool {
        get {
            return objc_getAssociatedObject(self, &SBKeyboardShouldHandleUI) as! Bool
        }
        set {
            objc_setAssociatedObject(self, &SBKeyboardShouldHandleUI, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func keyboardFrameChanged(frame: CGRect) {
        if(frame.origin.x == 0 && frame.origin.y == 0){
            if self.isFirstResponder() == true {
                self.sbkeyboardDelegate?.keyboardWillAppear?(forTextField: self)
            }
            else{
                self.sbkeyboardDelegate?.keyboardDidHide?(forTextField: self)
            }
        }
        else{
            if(self.sbkeyboardDelegate?.respondsToSelector(#selector(SBKeyBoardProtocol.keyboardFrameDidChange(_:forTextField:))) == true && shouldInformContinousKeyBoardFrameChange){
                self.sbkeyboardDelegate?.keyboardFrameDidChange!(frame,forTextField: self)
            }
            
            if(self.shouldHandleUI == true) {
                var convertedRect = self.superview?.convertRect(frame, toView: nil)
                if self.traitCollection.displayScale == 1.0 {
                    convertedRect?.origin.y = (convertedRect?.origin.y)! - (self.frame.height + 5)
                }
                
                if CGRectContainsPoint(convertedRect!, self.frame.origin) == true {
                    UIApplication.sharedApplication().keyWindow?.frame = CGRectMake(0, -((self.frame.origin.y - convertedRect!.origin.y) + (self.frame.size.height + 5)),  (UIApplication.sharedApplication().keyWindow?.frame.size.width)!,  (UIApplication.sharedApplication().keyWindow?.frame.size.height)!)
                }
                else{
                    UIApplication.sharedApplication().keyWindow?.frame = CGRectMake(0, 0,  (UIApplication.sharedApplication().keyWindow?.frame.size.width)!,  (UIApplication.sharedApplication().keyWindow?.frame.size.height)!)
                }
            }
        }
    }
    
    func configure(){
        if( self.inputAccessoryView != nil){
            if self.inputAccessoryView is SBKeyBoardInputAccessoryView {
                (self.inputAccessoryView as! SBKeyBoardInputAccessoryView).delegate = self
                self.shouldHandleUI = true;
            }
        }
        else{
            let inputAccessoryView = SBKeyBoardInputAccessoryView()
            self.inputAccessoryView = inputAccessoryView;
            (self.inputAccessoryView as! SBKeyBoardInputAccessoryView).delegate = self
        }
        
        self.shouldHandleUI = true;
    }
}
