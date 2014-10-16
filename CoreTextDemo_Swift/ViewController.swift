//
//  ViewController.swift
//  CoreTextDemo_Swift
//
//  Created by cxjwin on 10/15/14.
//  Copyright (c) 2014 cxjwin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var textView: CWCoreTextView!
	
	var observer: AnyObject?
	
	deinit {
		if observer != nil {
			NSNotificationCenter.defaultCenter().removeObserver(observer!)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
		var text = "http://t.cn/123QHz http://t.cn/1er6Hz [兔子][熊猫][给力][浮云][熊猫]   http://t.cn/1er6Hz [熊猫][熊猫][熊猫][熊猫] Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa[熊猫] Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa[熊猫] Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa[熊猫] Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa[熊猫] http://t.cn/6gb0Hz Hello World 你好世界[熊猫][熊猫]熊猫aaaaaaa"
		
        var storage = text.transformText()
		
		let paragraphStyle: NSParagraphStyle = {
			var paragraphStyle = NSMutableParagraphStyle()
			
			paragraphStyle.lineSpacing = 5
			paragraphStyle.paragraphSpacing = 15
			paragraphStyle.alignment = .Left
			paragraphStyle.firstLineHeadIndent = 5
			paragraphStyle.headIndent = 5
			paragraphStyle.tailIndent = 180
			paragraphStyle.lineBreakMode = .ByWordWrapping
			paragraphStyle.minimumLineHeight = 10
			paragraphStyle.maximumLineHeight = 20
			paragraphStyle.baseWritingDirection = .Natural
			paragraphStyle.lineHeightMultiple = 0.8
			paragraphStyle.hyphenationFactor = 2
			paragraphStyle.paragraphSpacingBefore = 0
			
			return paragraphStyle.copy() as NSParagraphStyle
		}()
		
		let range = NSMakeRange(0, storage.length)
		storage.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: range)
		
		storage.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
		
        textView.textStorage = storage
		
		observer = NSNotificationCenter.defaultCenter().addObserverForName(kTouchedLinkNotification, object: nil,
			queue: NSOperationQueue.mainQueue()) {
				(note: NSNotification!) -> Void in
				
				println("\(note.object!)")
				
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
}

