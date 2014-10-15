//
//  ViewController.swift
//  CoreTextDemo_Swift
//
//  Created by cxjwin on 10/15/14.
//  Copyright (c) 2014 cxjwin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var text = "123 hello [熊猫] http://t.cn/13eb24 你好..."
        
        var storage = text.transformText()
        
        println("\(storage.string)")
        
        textView.attributedText = storage;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

