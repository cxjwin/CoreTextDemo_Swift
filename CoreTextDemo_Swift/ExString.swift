//
//  ExString.swift
//  CoreTextDemo_Swift
//
//  Created by cxjwin on 10/15/14.
//  Copyright (c) 2014 cxjwin. All rights reserved.
//

import Foundation
import UIKit

extension String {
    private struct _OnceEmojiDict {
        static let emojiDict: NSDictionary? = {
            let path = NSBundle.mainBundle().pathForResource("emotionImage", ofType: "plist")
            return NSDictionary(contentsOfFile: path!)
        }()
    }
    
    var emojiDict: NSDictionary {
        return _OnceEmojiDict.emojiDict!
    }
    
    func transformText() -> NSTextStorage {
        var textStorage = NSTextStorage()
        
        var objcString: NSString = self;
        
        // emoji
        let regex_emoji = "\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
        
        let exp_emoji = NSRegularExpression(pattern: regex_emoji, options: .CaseInsensitive | .DotMatchesLineSeparators, error: nil)
        
        let emojis = exp_emoji?.matchesInString(objcString, options: .ReportCompletion, range: NSMakeRange(0, objcString.length))
        
        var location: Int = 0
				
		for result in emojis as [NSTextCheckingResult] {
            let range = result.range
			
            let subStr = objcString.substringWithRange(NSMakeRange(location, range.location - location))
            let attSubStr = NSAttributedString(string: subStr)
            textStorage.appendAttributedString(attSubStr)
            
            location = NSMaxRange(range)
            
            let emojiKey = objcString.substringWithRange(range)
            
            var imageName: String? = emojiDict[emojiKey] as? String
            
            if (imageName != nil) {
                let image = UIImage(named: imageName!)
                var attachment = NSTextAttachment()
                attachment.image = image
                attachment.bounds = CGRectMake(0, -3, 14, 14)
                var attachmentStr = NSAttributedString(attachment: attachment)
                textStorage.appendAttributedString(attachmentStr)
            } else {
                var emojiStr = NSAttributedString(string: emojiKey)
                textStorage.appendAttributedString(emojiStr)
            }
        }
        
        if (location < objcString.length) {
            let subStr = objcString.substringWithRange(NSMakeRange(location, objcString.length - location))
            let attSubStr = NSAttributedString(string: subStr)
            textStorage.appendAttributedString(attSubStr)
        }
        
        // reset string
        objcString = textStorage.string;
        
        // short link
        let regex_http = "http://t.cn/[a-zA-Z0-9]+"
        let exp_http = NSRegularExpression(pattern: regex_http, options: .CaseInsensitive | .DotMatchesLineSeparators, error: nil)
        
        let https = exp_http?.matchesInString(objcString, options: .ReportProgress, range: NSMakeRange(0, objcString.length))
        
        for result in https as [NSTextCheckingResult] {
            let range = result.range
            textStorage.addAttribute(NSLinkAttributeName, value: objcString.substringWithRange(range), range: range)
        }
        
        return textStorage
    }
    
}
