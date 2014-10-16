//
//  CWCoreTextView.swift
//  CoreTextDemo_Swift
//
//  Created by cxjwin on 10/16/14.
//  Copyright (c) 2014 cxjwin. All rights reserved.
//

import UIKit

let kTouchedLinkNotification = "kTouchedLinkNotification"
let kCWInvalidRange = NSMakeRange(NSNotFound, 0)

class CWCoreTextView: UIView, NSLayoutManagerDelegate {
	
	var layoutManager: CWLayoutManager
	var textContainer: NSTextContainer
	var touchesGestureRecognizer: CWTouchesGestureRecognizer?
	
	var touchRange = kCWInvalidRange
	
	var textStorage: NSTextStorage? {
		didSet {
			if let _textStorage: NSTextStorage = textStorage {
				_textStorage.addLayoutManager(layoutManager)
				self.setNeedsUpdateConstraints()
				self.setNeedsDisplay()
			}
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		layoutManager = CWLayoutManager()
		textContainer = NSTextContainer(size: CGSizeMake(200, CGFloat.max))
		
		super.init(coder: aDecoder)
		
		layoutManager.delegate = self
		layoutManager.addTextContainer(textContainer)
		
		touchesGestureRecognizer = CWTouchesGestureRecognizer(target: self, action: "handleTouch:")
		self.addGestureRecognizer(touchesGestureRecognizer!)
	}
	
	override func drawRect(rect: CGRect) {
		if let _textStorage: NSTextStorage = textStorage {
			let glyphRange = layoutManager.glyphRangeForTextContainer(textContainer)
			let point = layoutManager.locationForGlyphAtIndex(glyphRange.location)
			layoutManager.drawGlyphsForGlyphRange(glyphRange, atPoint: point)
		}
	}
	
	func handleTouch(gestureRecognizer: UIGestureRecognizer) {
		let state = gestureRecognizer.state
		
		switch state {
			// began
		case .Began :
			var location = gestureRecognizer.locationInView(self)
			let startPoint = layoutManager.locationForGlyphAtIndex(0)
			location = CGPoint(x: location.x - startPoint.x, y: location.y - startPoint.y)
			
			var fraction: CGFloat = 0
			let index = layoutManager.glyphIndexForPoint(location, inTextContainer: textContainer, fractionOfDistanceThroughGlyph: &fraction)
			
			if (0.01 < fraction && fraction < 0.99) {
				var effectiveRange: NSRange = kCWInvalidRange
				var value: AnyObject? = textStorage?.attribute(NSLinkAttributeName, atIndex: index, effectiveRange: &effectiveRange)
				if let _value: AnyObject = value {
					touchRange = effectiveRange
					layoutManager.touchRange = touchRange
					layoutManager.isTouched = true
					
					NSNotificationCenter.defaultCenter().postNotificationName(kTouchedLinkNotification, object: _value)
					self.setNeedsDisplay()
				} else {
					touchRange = kCWInvalidRange
				}
			}
			
			// end or canceled
		case .Ended, .Cancelled :
			if (touchRange.location != NSNotFound) {
				touchRange = kCWInvalidRange
				layoutManager.isTouched = false
				self.setNeedsDisplay()
			}
			
			// other
		default :
			//println("do nothing")
			break
		}
	}
	
	override func intrinsicContentSize() -> CGSize {
		let rect = layoutManager.usedRectForTextContainer(textContainer)
		let width = CGRectGetWidth(rect) + 30.0
		let height = CGRectGetHeight(rect) + 20.0
		return CGSize(width: ceil(width), height: ceil(height))
	}
}


class CWLayoutManager: NSLayoutManager {
	var touchRange = kCWInvalidRange
	var isTouched = false
	
	override func drawUnderlineForGlyphRange(glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: CGRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: CGPoint) {
		
		let firstPosition = self.locationForGlyphAtIndex(glyphRange.location).x
		
		var lastPosition: CGFloat
		
		if NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange) {
			lastPosition = self.locationForGlyphAtIndex(NSMaxRange(glyphRange)).x
		} else {
			lastPosition = self.lineFragmentUsedRectForGlyphAtIndex(NSMaxRange(glyphRange) - 1, effectiveRange:nil).size.width
		}
		
		var tempRect = lineRect
		
		tempRect.origin.x = tempRect.origin.x + firstPosition
		tempRect.size.width = lastPosition - firstPosition
		tempRect.size.height = tempRect.size.height - baselineOffset + 2
		
		tempRect.origin.x = floor(tempRect.origin.x + containerOrigin.x)
		tempRect.origin.y = floor(tempRect.origin.y + containerOrigin.y)
		
		let tempRange = NSIntersectionRange(touchRange, glyphRange)
		if (isTouched && tempRange.length != 0) {
			UIColor.purpleColor().set()
		} else {
			UIColor.greenColor().set()
		}
		
		UIBezierPath(rect: tempRect).fill()
	}
}