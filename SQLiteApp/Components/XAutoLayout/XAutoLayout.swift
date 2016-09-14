//
//  XAutoLayout.swift
//  SQLiteApp
//
//  Created by iDevFans on 16/9/4.
//  Copyright © 2016年 macdev. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif


#if os(iOS) || os(tvOS)
    import UIKit
    public typealias View = UIView
    public typealias LayoutPriority = UILayoutPriority
#else
    import AppKit
    public typealias View = NSView
    public typealias LayoutPriority = NSLayoutPriority
#endif

public typealias ViewLayoutAttribute = (View,NSLayoutAttribute)

public typealias LayoutRelation = (item1:AnyObject,attr1:NSLayoutAttribute,op:NSLayoutRelation,item2:AnyObject?,attr2:NSLayoutAttribute,m:CGFloat,c:CGFloat)

public typealias ConstantLayoutRelation = (attr:NSLayoutAttribute,op:NSLayoutRelation,c:CGFloat)

extension View {

    // MARK: Helper Function

    func constraint(_ layoutRelation:LayoutRelation) ->NSLayoutConstraint {
        let item1 = layoutRelation.item1
        let attr1 = layoutRelation.attr1
        let op = layoutRelation.op
        let item2 = layoutRelation.item2
        let attr2 = layoutRelation.attr2
        let m = layoutRelation.m
        let c = layoutRelation.c

        let constraint = NSLayoutConstraint.init(item:item1 , attribute: attr1, relatedBy: op, toItem:item2, attribute: attr2, multiplier: m, constant: c)
   
        return constraint
    }

    func constraint(_ constant:ConstantLayoutRelation) ->NSLayoutConstraint {
        let item1 = self
        let attr1 = constant.attr
        let op = constant.op
        let attr2 = attr1
        let c = constant.c

        let constraint = NSLayoutConstraint.init(item:item1 , attribute: attr1, relatedBy: op, toItem:nil, attribute: attr2, multiplier: 1.0, constant: c)
   
        return constraint
    }
    
    func constraint(attribute attr1: NSLayoutAttribute , op:NSLayoutRelation, toView: AnyObject?, attribute attr2: NSLayoutAttribute,  multiplier: CGFloat, constant: CGFloat, priority: LayoutPriority ) ->NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attr1, relatedBy: op, toItem: toView, attribute: attr2, multiplier: 1.0, constant: constant)
        constraint.priority = priority
    
        return constraint
    }
    

    func constraint(_ any:Any,_ newValue:Any) ->NSLayoutConstraint {
        
        var c: CGFloat = 0
        var op: NSLayoutRelation = .equal
        
        let viewAttr = any as! ViewLayoutAttribute
        
        var value:(Any,CGFloat,NSLayoutRelation)
        
        if newValue is (Any,CGFloat,NSLayoutRelation) {
            // item2,constant,op
            value = newValue as! (Any,CGFloat,NSLayoutRelation)
        }
        else if newValue is ViewLayoutAttribute {
            // item2,0,op
            value = (newValue,0,.equal)
        }
        else {
            // = constant and  >= 10
            if newValue is (CGFloat,NSLayoutRelation) {
               let temp = newValue as!  (CGFloat,NSLayoutRelation)
               c  = temp.0
               op = temp.1
            }
            else {
                if newValue is Int {
                    let v = newValue as! Int
                    c = CGFloat(v)
                }
                else if newValue is Double {
                    let v = newValue as! Double
                    c = CGFloat(v)
                }
                else if newValue is Float {
                    let v = newValue as! Float
                    c = CGFloat(v)
                }
                else {
                    c = newValue as! CGFloat
                }
            }
            value = (0,c,op)
        }
        
        let constant = value.1
        
        op = value.2
        
        let value0 = value.0
        
        let attr1 = viewAttr.1
        
        var constraint:NSLayoutConstraint
        var item2: AnyObject?
        var attr2: NSLayoutAttribute
        if value0 is ViewLayoutAttribute {
    
            let toViewAttr = value.0 as! ViewLayoutAttribute
            item2 = toViewAttr.0
            attr2 = toViewAttr.1
        }
        else {
            item2 = nil
            attr2 = attr1
            let attrs: [NSLayoutAttribute] = [.top,.bottom,.left,.right,.leading,.trailing]
            if attrs.contains(attr2) {
                item2 = self.superview!
            }
        }
        
        constraint = self.constraint(attribute: attr1, op:op, toView: item2, attribute: attr2, multiplier: 1, constant: constant, priority: 1000)
        
        return constraint
    }
    
    
    func addPaddingsConstraint(_ view:View,_ paddings:(CGFloat,CGFloat,CGFloat,CGFloat)) {
       
        let leftMargin = paddings.0
        let rightMargin = paddings.1
        let topMargin =  paddings.2
        let bottomMargin = paddings.3
        
        let viewTopAttr:ViewLayoutAttribute = (view,.top)
        let viewRightAttr:ViewLayoutAttribute = (view,.right)
        let viewBottomAttr:ViewLayoutAttribute = (view,.bottom)
        let viewLeftAttr:ViewLayoutAttribute = (view,.left)
        
        let tValue: (Any,CGFloat,NSLayoutRelation) =  (viewTopAttr,topMargin,.equal)
        let rValue: (Any,CGFloat,NSLayoutRelation) =  (viewRightAttr,rightMargin,.equal)
        let bValue: (Any,CGFloat,NSLayoutRelation) =  (viewBottomAttr,bottomMargin,.equal)
        let lValue: (Any,CGFloat,NSLayoutRelation) =  (viewLeftAttr,leftMargin,.equal)
        
        let top = self.constraint(self.top,tValue)
        let right = self.constraint(self.right,rValue)
        let bottom = self.constraint(self.bottom,bValue)
        let left = self.constraint(self.left,lValue)
        NSLayoutConstraint.activate([top,right,bottom,left])
    }

    
    func formatValue(_ view: View , _ newValue: Any) -> (View,(CGFloat,CGFloat,CGFloat,CGFloat)){
        
        var value:(View,(CGFloat,CGFloat,CGFloat,CGFloat))
        if newValue is (View,(CGFloat,CGFloat,CGFloat,CGFloat)) {
            value = newValue as! (View,(CGFloat,CGFloat,CGFloat,CGFloat))
        }
        else if newValue is (View,(Double,Double,Double,Double)) {
            let temp = newValue as! (View,(Double,Double,Double,Double))
            value =  (view,(CGFloat(temp.1.0),CGFloat(temp.1.1),CGFloat(temp.1.2),CGFloat(temp.1.3)))
        }
        else if newValue is (View,(Int,Int,Int,Int)) {
            let temp = newValue as! (View,(Int,Int,Int,Int))
            value =  (view,(CGFloat(temp.1.0),CGFloat(temp.1.1),CGFloat(temp.1.2),CGFloat(temp.1.3)))
        }
        else if newValue is (CGFloat,CGFloat,CGFloat,CGFloat) {
            let paddings = newValue as! (CGFloat,CGFloat,CGFloat,CGFloat)
            value = (view, paddings)
        }
        else if newValue is (Double,Double,Double,Double) {
            let temp = newValue as! (Double,Double,Double,Double)
            value = (view, (CGFloat(temp.0),CGFloat(temp.1),CGFloat(temp.2),CGFloat(temp.3)))
        }
        else if newValue is (Int,Int,Int,Int) {
            let temp = newValue as! (Int,Int,Int,Int)
            value = (view, (CGFloat(temp.0),CGFloat(temp.1),CGFloat(temp.2),CGFloat(temp.3)))
        }
        else {
            value = (newValue as! View ,(0,0,0,0))
        }
        
        NSLog(" view = \(value.0), margin= \(value.1)")
        
        return value
    }
    
    
    func formatValue(_ viewMargin: (View,Any)
) -> (View,(CGFloat,CGFloat,CGFloat,CGFloat)){
    
        let view = viewMargin.0
        let newValue = viewMargin.1
        
        NSLog("newValue = \(newValue) ")
        
        var value:(View,(CGFloat,CGFloat,CGFloat,CGFloat))
        if newValue is (CGFloat,CGFloat,CGFloat,CGFloat) {
            let margin = newValue as! (CGFloat,CGFloat,CGFloat,CGFloat)
            value = (view,margin)
        }
        else if newValue is (Double,Double,Double,Double) {
            let temp = newValue as! (Double,Double,Double,Double)
            let margin =  (CGFloat(temp.0),CGFloat(temp.1),CGFloat(temp.2),CGFloat(temp.3))
            value = (view,margin)
        }
        else if newValue is (Int,Int,Int,Int) {
            let temp = newValue as! (Int,Int,Int,Int)
            let margin =  (CGFloat(temp.0),CGFloat(temp.1),CGFloat(temp.2),CGFloat(temp.3))
            value = (view,margin)
        }
        else if newValue is (CGFloat,CGFloat,CGFloat,CGFloat) {
            let margin = newValue as! (CGFloat,CGFloat,CGFloat,CGFloat)
            value = (view,margin)
        }
        else {
            let margin =  (CGFloat(0),CGFloat(0),CGFloat(0),CGFloat(0))
            value = (view,margin)
        }
        
        return value
    }

    
    func cgFloatFormatValues(_ value:Any) -> [CGFloat] {
        let formatValues = self.cgFloatFormat(value)
        var values: [CGFloat] = []
        if formatValues is CGFloat {
            values = [formatValues as! CGFloat]
        }
        else if formatValues is (CGFloat,CGFloat) {
            let v = formatValues as! (CGFloat,CGFloat)
            values = [v.0,v.1]
        }
        else if formatValues is (CGFloat,CGFloat,CGFloat) {
            let v = formatValues as! (CGFloat,CGFloat,CGFloat)
            values = [v.0,v.1,v.2]
        }
        else if formatValues is (CGFloat,CGFloat,CGFloat,CGFloat) {
            let v = formatValues as! (CGFloat,CGFloat,CGFloat,CGFloat)
            values = [v.0,v.1,v.2,v.3]
        }
        return values
    }
    
    func cgFloatFormat(_ value:Any) ->Any? {
        
        let oneNum = value as? NSNumber
        if oneNum != nil {
            return CGFloat((oneNum?.floatValue)!)
        }
        else if value is (Any,Any) {
            let twoNum = value as! (Any,Any)
            let one = self.anyToCGFloat(twoNum.0)
            let two = self.anyToCGFloat(twoNum.1)
            return (one,two)
        }
        else if value is (Int,Int) {
            let twoNum = value as! (Int,Int)
            let one = self.anyToCGFloat(twoNum.0)
            let two = self.anyToCGFloat(twoNum.1)
            return (one,two)
        }
        else if value is (Double,Double) {
            let twoNum = value as! (Double,Double)
            let one = self.anyToCGFloat(twoNum.0)
            let two = self.anyToCGFloat(twoNum.1)
            return (one,two)
        }
        else if value is (Any,Any,Any) {
            let threeNum = value as! (Any,Any,Any)
            let one = self.anyToCGFloat(threeNum.0)
            let two = self.anyToCGFloat(threeNum.1)
            let three = self.anyToCGFloat(threeNum.2)
            return (one,two,three)
        }
        else if value is (Int,Int,Int) {
            let threeNum = value as! (Int,Int,Int)
            let one = self.anyToCGFloat(threeNum.0)
            let two = self.anyToCGFloat(threeNum.1)
            let three = self.anyToCGFloat(threeNum.2)
            return (one,two,three)
        }
        else if value is (Double,Double,Double) {
            let threeNum = value as! (Double,Double,Double)
            let one = self.anyToCGFloat(threeNum.0)
            let two = self.anyToCGFloat(threeNum.1)
            let three = self.anyToCGFloat(threeNum.2)
            return (one,two,three)
        }
        else if value is (Any,Any,Any,Any) {
            let fourNum = value as! (Any,Any,Any,Any)
            let one = self.anyToCGFloat(fourNum.0)
            let two = self.anyToCGFloat(fourNum.1)
            let three = self.anyToCGFloat(fourNum.2)
            let four = self.anyToCGFloat(fourNum.3)
            return (one,two,three,four)
        }
        else if value is (Int,Int,Int,Int) {
            let fourNum = value as! (Int,Int,Int,Int)
            let one = self.anyToCGFloat(fourNum.0)
            let two = self.anyToCGFloat(fourNum.1)
            let three = self.anyToCGFloat(fourNum.2)
            let four = self.anyToCGFloat(fourNum.3)
            return (one,two,three,four)
        }
        else  if value is (Double,Double,Double,Double) {
            let fourNum = value as! (Double,Double,Double,Double)
            let one = self.anyToCGFloat(fourNum.0)
            let two = self.anyToCGFloat(fourNum.1)
            let three = self.anyToCGFloat(fourNum.2)
            let four = self.anyToCGFloat(fourNum.3)
            return (one,two,three,four)
        }
        else {
            return nil
        }
    }
    
    func anyToCGFloat(_ v:Any) ->CGFloat {
        let oneNum = v as? NSNumber
        if oneNum != nil {
            return CGFloat((oneNum?.floatValue)!)
        }
        return 0.0
    }
    
    func attrConstraint(toView view: View,attrs:[NSLayoutAttribute],constants:[CGFloat]) -> [NSLayoutConstraint] {
        var constraints:[NSLayoutConstraint] = []
        var viewAttr: ViewLayoutAttribute
        var item2Attr: (Any,CGFloat,NSLayoutRelation)
        if constants.count < 2 {
            NSLog("constants elements must > 2")
            return []
        }
        var index: Int = 0
        var anchor: Any
        for attr in attrs {
            switch (attr) {
            case .centerX:
                viewAttr = (view,.centerX)
                anchor = self.centerX
                break
            case .centerY:
                viewAttr = (view,.centerY)
                anchor = self.centerY
                break
            case .width:
                viewAttr = (view,.width)
                anchor = self.width
                break
            
            default:
                viewAttr = (view,.height)
                anchor = self.height
                break
             
            }
            item2Attr = (viewAttr,constants[index],.equal)
            index = index + 1
            
            let constraint = self.constraint(anchor,item2Attr)
            
            constraints.append(constraint)
        }
        return constraints
    }
    
    
    func constraintCenter(_ any:Any,_ newValue:Any) -> [NSLayoutConstraint] {
        
        let formatValue = self.cgFloatFormatValues(newValue)
        var constants:[CGFloat] = [0,0]

        if formatValue.count > 0  {
            if formatValue.count == 1 {
                constants[0] = formatValue[0]
                constants[1] = formatValue[1]
            }
            else{
                constants = formatValue
            }
            
            let cententXRelation: ConstantLayoutRelation = (attr:.width,op:.equal,c:constants[0])
            let centerYRelation: ConstantLayoutRelation = (attr:.height,op:.equal,c:constants[1])
            let cententXConstraint = self.constraint(cententXRelation)
            let cententYConstraint = self.constraint(centerYRelation)

            return [cententXConstraint,cententYConstraint]
        }
        else if newValue is View {
            let view = newValue as! View
            let cententXConstraint = self.constraint(self.centerX,view.centerX)
            let cententYConstraint = self.constraint(self.centerY,view.centerY)
            return [cententXConstraint,cententYConstraint]

        }
        else if newValue is (Any,CGFloat,NSLayoutRelation) {
            // center + 10
            let viewSizeAttribute = newValue as! (Any,CGFloat,NSLayoutRelation)
            let view = viewSizeAttribute.0 as! View
            let constant = viewSizeAttribute.1

            return self.attrConstraint(toView: view, attrs: [.centerX,.centerY], constants: [constant,constant])
        }
        else if newValue is  (View,Any) {
            //cneter + (10,30)
            let value = newValue as! (View,Any)
            let view = value.0
            let size:(CGFloat,CGFloat) = self.cgFloatFormat(value.1) as! (CGFloat,CGFloat)
            
            return self.attrConstraint(toView: view, attrs: [.centerX,.centerY], constants: [size.0,size.1])

        }
        else if newValue is  (View,[NSLayoutAttribute])  {
            //center = center
            let value = newValue as! (View,[NSLayoutAttribute])
            let view = value.0
            let cententXConstraint = self.constraint(self.centerX,view.centerX)
            let cententYConstraint = self.constraint(self.centerY,view.centerY)
            return [cententXConstraint,cententYConstraint]
        }
    
        return []
    }
    
    func constraintSize(_ any:Any,_ newValue:Any) ->[NSLayoutConstraint] {
        //let viewAttr = any as! (View,[NSLayoutAttribute])
        let formatValue = self.cgFloatFormat(newValue)
        var size:(CGFloat,CGFloat) = (0,0)
        
        if formatValue is (CGFloat,CGFloat) {
            size = formatValue as! (CGFloat,CGFloat)
            let widthConstraint  = self.constraint(self.width,size.0)
            let heigthConstraint = self.constraint(self.height,size.1)
            return [widthConstraint,heigthConstraint]
        }
        else if newValue is View {
            //self.size = view2
            let view = newValue as! View
            let widthConstraint = self.constraint(self.width,view.width)
            let heigthConstraint = self.constraint(self.height,view.height)
            return [widthConstraint,heigthConstraint]
        }
        else if newValue is (Any,CGFloat,NSLayoutRelation) {
            // size + 10
            let viewSizeAttribute = newValue as! (Any,CGFloat,NSLayoutRelation)
            let view = viewSizeAttribute.0 as! View
            let constant = viewSizeAttribute.1
            return self.sizeConstraint(from:view,size:(constant,constant))
        }
        else if newValue is  (View,Any) {
            //size + (10,30)
            let value = newValue as! (View,Any)
            let view = value.0
            let size:(CGFloat,CGFloat) = self.cgFloatFormat(value.1) as! (CGFloat,CGFloat)
            return self.sizeConstraint(from:view,size:size)
        }
        else if newValue is  (View,[NSLayoutAttribute])  {
            //size = size
            let value = newValue as! (View,[NSLayoutAttribute])
            let view = value.0
            
            let widthConstraint = self.constraint(self.width,view.width)
            let heigthConstraint = self.constraint(self.height,view.height)
            return [widthConstraint,heigthConstraint]
        }
        return []
    }
    
    //Size
    func sizeConstraint(from view:View , size:(CGFloat,CGFloat)) -> [NSLayoutConstraint] {
        
        let widthAttr: ViewLayoutAttribute = (view,.width)
        let heightAttr: ViewLayoutAttribute = (view,.height)
        let item2WidthAttr: (Any,CGFloat,NSLayoutRelation) = (widthAttr,size.0,.equal)
        let item2HeightAttr: (Any,CGFloat,NSLayoutRelation) = (heightAttr,size.1,.equal)
        let widthConstraint = self.constraint(self.width,item2WidthAttr)
        let heigthConstraint = self.constraint(self.height,item2HeightAttr)
        return [widthConstraint,heigthConstraint]
    }
}


//MARK: Autolayout  Properties

extension View {
    
    //MARK: Autolayout  Properties
    var left: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.left)
            return vl
        }
        set {
            let constraint = self.constraint(self.left,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    var right: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.right)
            return vl
        }
        set {
            let constraint = self.constraint(self.right,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    var top: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.top)
            return vl
        }
        set {
            let constraint = self.constraint(self.top,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    var bottom: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.bottom)
            return vl
        }
        set {
            let constraint = self.constraint(self.bottom,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    
    var leading: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.leading)
            return vl
        }
        set {
            let constraint = self.constraint(self.leading,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    var trailing: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.trailing)
            return vl
        }
        set {
            let constraint = self.constraint(self.trailing,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    var width: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.width)
            return vl
        }
        set {
            let constraint = self.constraint(self.width,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    var height: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.height)
            return vl
        }
        set {
            let constraint = self.constraint(self.height,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    

    
    var size: Any {
        get {
            let vl:  (View,[NSLayoutAttribute])  = (self,[.width,.height])
            return vl
        }
        set {
            let constraint = self.constraintSize(self.size,newValue)
            NSLayoutConstraint.activate(constraint)
        }
    }
    
    
    var centerX: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.centerX)
            return vl
        }
        set {
            let constraint = self.constraint(self.centerX,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    
    var centerY: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.centerY)
            return vl
        }
        set {
            let constraint = self.constraint(self.centerY,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    var center: Any {
        get {
            let vl: (View,[NSLayoutAttribute])  = (self,[.centerX,.centerY])
            return vl
        }
        set {
            let constraints = self.constraintCenter(self.center,newValue)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    var lastBaseline: Any {
        get {
            let vl: ViewLayoutAttribute  = (self,.lastBaseline)
            return vl
        }
        set {
            let constraint = self.constraint(self.lastBaseline,newValue)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    var margin: Any {
        get {
            return self
        }
        set {
            var viewMargin: (View,Any)
            if newValue is (View,Any) {
                viewMargin = newValue as! (View,Any)
            }
            else {
                viewMargin = (self.superview!,newValue)
            }
            
            
            let value = self.formatValue(viewMargin)
            
            let view = value.0
            
            let paddings = value.1
            
            let topMargin =  paddings.0
            let rightMargin = paddings.1
            let bottomMargin = paddings.2
            let leftMargin = paddings.3
            
            self.addPaddingsConstraint(view,(leftMargin,rightMargin,topMargin,bottomMargin))
          
        }
    }
    
    var insets: Any {
        get {
            return self
        }
        set {
            var viewMargin: (View,Any)
            if newValue is (View,Any) {
                viewMargin = newValue as! (View,Any)
            }
            else {
                viewMargin = (self.superview!,newValue)
            }
            
            let value = self.formatValue(viewMargin)
            
            let view = value.0
            
            let paddings = value.1
            
            let topMargin =  paddings.0
            let leftMargin = paddings.1
            let bottomMargin = paddings.2
            let rightMargin = paddings.3
            
            self.addPaddingsConstraint(view,(leftMargin,rightMargin,topMargin,bottomMargin))
          
        }
    }
    
    var padding: Any {
        get {
            return self
        }
        set {
            
            var viewMargin: (View,Any)
            
            if newValue is (View,Any) {
                viewMargin = newValue as! (View,Any)
            }
            else {
                viewMargin = (self.superview!,newValue)
            }
            
            let view          = viewMargin.0
            let formatPadding = self.cgFloatFormat(viewMargin.1)
            
            var topMargin: CGFloat
            var rightMargin: CGFloat
            var bottomMargin: CGFloat
            var leftMargin: CGFloat
            
            if formatPadding is (CGFloat,CGFloat,CGFloat,CGFloat) {
               
                let paddings = formatPadding  as! (CGFloat,CGFloat,CGFloat,CGFloat)
                
                topMargin    = paddings.0
                rightMargin   = paddings.1
                bottomMargin = paddings.2
                leftMargin  = paddings.3
                
                self.addPaddingsConstraint(view,(leftMargin,rightMargin,topMargin,bottomMargin))
            }
            else  if formatPadding is (CGFloat,CGFloat,CGFloat) {
               
                let paddings = formatPadding  as! (CGFloat,CGFloat,CGFloat)
                
                topMargin    = paddings.0
                leftMargin   = paddings.1
                rightMargin   = paddings.1 * (-1)
                bottomMargin = paddings.2
                
                self.addPaddingsConstraint(view,(leftMargin,rightMargin,topMargin,bottomMargin))
            }
            else if formatPadding is (CGFloat,CGFloat) {
               
                let paddings = formatPadding  as! (CGFloat,CGFloat)
                
                topMargin    = paddings.0
                bottomMargin = paddings.0 * (-1)
                leftMargin   = paddings.1
                rightMargin   = paddings.1 * (-1)
                
                self.addPaddingsConstraint(view,(leftMargin,rightMargin,topMargin,bottomMargin))
            }
            else {
                
                let paddings = formatPadding  as! CGFloat
                
                topMargin    = paddings
                bottomMargin = paddings * (-1)
                leftMargin   = paddings
                rightMargin   = paddings * (-1)
                
                self.addPaddingsConstraint(view,(leftMargin,rightMargin,topMargin,bottomMargin))
                
            }
           
        }
    }

}

// MARK: Operator Override

infix operator >= { associativity right precedence 90 }
infix operator <= { associativity right precedence 90 }

//infix operator &  { associativity left precedence 10  }
//infix operator +  { associativity right precedence 90  }


// @ priority
func &(lhs:Any, rhs:Int)-> Any {
    return (lhs,rhs)
}

 
//margin  view + (10,20,30,40)
func +(lhs:View, rhs:Any)-> (View,Any) {
    return (lhs,rhs)
}

//size + 10 or size + (10,20)
func +(lhs:Any, rhs:(CGFloat,CGFloat)) -> (View,Any) {
    let sizeAttr: (View,[NSLayoutAttribute]) = lhs as!  (View,[NSLayoutAttribute])
    return (sizeAttr.0,rhs)
}

func +(lhs:Any, rhs:(Int,Int)) -> (View,Any) {
    let sizeAttr: (View,[NSLayoutAttribute]) = lhs as!  (View,[NSLayoutAttribute])
    return (sizeAttr.0,rhs)
}

func +(lhs:Any, rhs:(Double,Double)) -> (View,Any) {
    let sizeAttr: (View,[NSLayoutAttribute]) = lhs as!  (View,[NSLayoutAttribute])
    return (sizeAttr.0,rhs)
}


func +(lhs:Any, rhs:CGFloat) -> (Any,CGFloat,NSLayoutRelation) {
    if lhs is (Any,CGFloat,NSLayoutRelation) {
        let tuple = lhs as! (Any,CGFloat,NSLayoutRelation)
        let ret:(Any,CGFloat,NSLayoutRelation) = (tuple.0,(tuple.1+rhs),.equal)
        return ret
    }
    else if lhs is (View,[NSLayoutAttribute]) {
        //size + 10
        let tuple = lhs as! (View,[NSLayoutAttribute])
        return (tuple.0,rhs,.equal)
    }
    else {
        return (lhs,rhs,.equal)
    }
}


func -(lhs:Any, rhs:CGFloat) -> (Any,CGFloat,NSLayoutRelation) {
    if lhs is (Any,CGFloat,NSLayoutRelation) {
        let tuple = lhs as! (Any,CGFloat,NSLayoutRelation)
        let ret:(Any,CGFloat,NSLayoutRelation) = (tuple.0,(tuple.1 - rhs),.equal)
        return ret
    }
    else if lhs is (View,[NSLayoutAttribute]) {
        //size - 10
        let tuple = lhs as! (View,[NSLayoutAttribute])
        return (tuple.0,rhs * (-1),.equal)
    }
    else {
         return (lhs,rhs * (-1),.equal)
    }
}

func >=( lhs:inout Any, rhs:Any) {
    if rhs is (Any,CGFloat,NSLayoutRelation) {
        let tuple = rhs as! (Any,CGFloat,NSLayoutRelation)
        let ret:(Any,CGFloat,NSLayoutRelation) = (tuple.0,tuple.1,.greaterThanOrEqual)
        lhs = ret
    }
    else if rhs is (View,[NSLayoutAttribute]) {
        //size - 10
        let tuple = rhs as! (View,[NSLayoutAttribute])
        let ret:(Any,CGFloat,NSLayoutRelation) = (tuple.0,0,.greaterThanOrEqual)
        lhs = ret
    }
    else {
         let const =  CGFloat((rhs as? NSNumber)!)
         let ret:(CGFloat,NSLayoutRelation) = (const,.greaterThanOrEqual)
         lhs = ret
    }
}

func <=(lhs:inout Any, rhs:Any) {
    if rhs is (Any,CGFloat,NSLayoutRelation) {
        let tuple = rhs as! (Any,CGFloat,NSLayoutRelation)
        let ret:(Any,CGFloat,NSLayoutRelation) = (tuple.0,tuple.1,.lessThanOrEqual)
        lhs = ret
    }
    else if rhs is (View,[NSLayoutAttribute]) {
        //size - 10
        let tuple = rhs as! (View,[NSLayoutAttribute])
        let ret:(Any,CGFloat,NSLayoutRelation) = (tuple.0,0,.lessThanOrEqual)
        lhs = ret
    }
    else {
         let const =  CGFloat((rhs as? NSNumber)!)
         let ret:(CGFloat,NSLayoutRelation) = (const,.lessThanOrEqual)
         lhs = ret
    }
}
