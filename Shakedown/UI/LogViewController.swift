//
//  LogViewController.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 4/11/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var backgroundImageView: UIImageView!

    var report: BugReport?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFromNotification:", name: Shakedown.Notifications.LogUpdated, object: nil)
        updateLog()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateFromNotification(notification: NSNotification) {
        updateLog()
    }
    
    func updateLog() {
        let oldSize = textView.contentSize
        textView.text = report?.deviceLog
        if textView.contentOffset.y + textView.frame.height == oldSize.height {
            // At the bottom already, stay pinned to bottom as new logs come in
            let y =  textView.contentSize.height - textView.frame.height
            let bottomRect = CGRect(x: 0, y: y, width: textView.frame.width, height: textView.frame.height)
            textView.scrollRectToVisible(bottomRect, animated: true)
        }
    }
}
