//
//  TextFieldEffects.swift
//  SDKCheck
//
//  Created by ganesh on 16/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import UIKit

open class TextFieldEffects : UITextField {
    
    // animation type
    public enum AnimationType: Int {
        case textEntry
        case textDisplay
    }
    
    
    // local type alias
    public typealias AnimationCompletionHandler = (_ type: AnimationType)->()
    
    
    // local objects
    open let placeholderLabel = UILabel()
    open var animationCompletionHandler: AnimationCompletionHandler?
    
    
    // animate views for TextEntry
    open func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")
    }
    
    
    // animate views for text display
    open func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")
    }
    
    
    // draw views for rect
    open func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    
    // update views for bounds change
    open func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    
    // draw
    override open func draw(_ rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    
    // draw place holder
    override open func drawPlaceholder(in rect: CGRect) {
    }
    
    
    // text
    override open var text: String? {
        didSet {
            if let text = text, text.isNotEmpty {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }
    
    
    // will move
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    
    // text field did begin editing
    @objc open func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    
    // text field did end editing
    @objc open func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
    
    // prepare for interface builder
    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
}

public extension String {
    
    // is not empty
    public var isNotEmpty: Bool {
        return !isEmpty
    }
    
    
    // string by appending path component
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    
    // height with constrained width
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
}
