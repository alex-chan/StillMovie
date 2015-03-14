//
//  BorderTextView.swift
//  TryDemo
//
//  Created by Alex Chan on 15/2/6.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation
import UIKit




@IBDesignable class BorderTextView: UITextView, UITextViewDelegate {
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor(){
        didSet{
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        println(" init with frame")
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidEndEditingNotification, object: nil)
    }

//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//    }

    required init(coder aDecoder: NSCoder) {
        println(" init with coder")
        
        super.init(coder: aDecoder)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textBeginEditing:", name:UITextViewTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textEndEditing:", name:
            UITextViewTextDidEndEditingNotification, object: nil)
        
    }
    
    @IBInspectable var placeHolder: String = "" {
        didSet {
            self.text = placeHolder
            self.textColor = UIColor.lightGrayColor()
        }
    }
    
    // MARK: selectors
    func textBeginEditing(notification: NSNotification){
        self.textColor = UIColor.blackColor()
        if self.text == self.placeHolder{
            self.text = ""
        }

        
    }
    
    func textEndEditing(notification: NSNotification){
        if countElements(self.text) == 0{
            self.textColor = UIColor.lightGrayColor()
            self.text = self.placeHolder
        }
        
    }
    
//    func textViewDidBeginEditing(textView: UITextView) {
//        textView.text = ""
//    }
//    
//    func textViewDidEndEditing(textView: UITextView) {
//        if countElements(textView.text) == 0 {
//            textView.text = self.placeHolder
//        }
//    }
//    

}
