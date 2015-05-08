//
//  CWTouchesGestureRecognizer.swift
//  CoreTextDemo_Swift
//
//  Created by cxjwin on 10/16/14.
//  Copyright (c) 2014 cxjwin. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class CWTouchesGestureRecognizer: UIGestureRecognizer {
	var startPoint: CGPoint?
	
	override init(target: AnyObject, action: Selector) {
		super.init(target: target, action: action)
	}
	
	override func touchesBegan(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		let touch: UITouch? = touches.first as? UITouch
		startPoint = touch!.locationInView(self.view!)
		self.state = .Began
	}
	
	override func touchesMoved(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		let touch: UITouch? = touches.first as? UITouch
		let currentPoint = touch!.locationInView(self.view!)
		
		let distanceX = currentPoint.x - startPoint!.x
		let	distanceY = currentPoint.y - startPoint!.y
		let distance = sqrt(distanceX * distanceX + distanceY * distanceY)
		
		if distance > 10.0 {
			self.state = .Cancelled
		} else {
			self.state = .Changed
		}
	}
	
	override func touchesEnded(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		self.state = .Ended
	}
	
	override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		self.state = .Cancelled
	}
	
	override func reset() {
		self.state = .Possible
	}
}
