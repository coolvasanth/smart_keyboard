//
//  SBTextFieldObserver.swift
//  TestCode
//
//  Created by Sandeep Bhandari on 08/08/16.
//  Copyright © 2016 Sandeep Bhandari. All rights reserved.
//

import UIKit
import ObjectiveC

protocol KeyBoardObserverProtocol {
    func keyboardFrameChanged(frame : CGRect)
}


class SBKeyBoardInputAccessoryView : UIView {
    
    var delegate:KeyBoardObserverProtocol? = nil
    private var kvoContext: UInt8 = 1
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview == nil {
            self.superview?.removeObserver(self, forKeyPath: "center")
            self.delegate?.keyboardFrameChanged(CGRect.zero)
        }
        else{
            newSuperview?.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New, context: &kvoContext)
            self.delegate?.keyboardFrameChanged(CGRect.zero)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &kvoContext {
            if let theChange = change as [String : AnyObject]?{
                if theChange[NSKeyValueChangeNewKey] != nil{
                    if self.delegate != nil {
                        self.delegate?.keyboardFrameChanged((self.superview?.frame)!)
                    }
                }
            }
        }
    }
}
