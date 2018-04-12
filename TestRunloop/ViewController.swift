//
//  ViewController.swift
//  TestRunloop
//
//  Created by Jiang Yongli on 12/12/17.
//  Copyright © 2017 MicroStrategy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var button: UIButton?
    var printButton: UIButton?
    var myThread: TestThread?
    var isStopped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        button?.backgroundColor = UIColor.brown
        button?.setTitleColor(UIColor.red, for: .normal)
        button?.setTitle("Start", for: .normal)
        button?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(button!)
        button?.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        
        printButton = UIButton(frame: CGRect(x: 100, y: 250, width: 200, height: 50))
        printButton?.backgroundColor = UIColor.brown
        printButton?.setTitleColor(UIColor.red, for: .normal)
        printButton?.setTitle("Print Something", for: .normal)
        printButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(printButton!)
        printButton?.addTarget(self, action: #selector(printSomething), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc open func clickButton(sender:UIButton) {
        if button?.titleLabel?.text == "Start" {
            button?.setTitle("Stop", for: .normal)
            myThread = TestThread(target: self, selector: #selector(threadRun), object: nil)
            myThread?.start()
        } else if button?.titleLabel?.text == "Stop" {
            button?.setTitle("Start", for: .normal)
            if let testThread = myThread {
                if !testThread.isFinished {
                    self.perform(#selector(threadStop), on: testThread, with: nil, waitUntilDone: false)
                }
            }
        }
    }
    
    @objc open func threadRun() {
        autoreleasepool {
            isStopped = false
            let runloop = RunLoop.current
            let port = NSMachPort()
            myThread?.port = port
            runloop.add(NSMachPort(), forMode: .defaultRunLoopMode)
            //  runloop.run()
            //CFRunLoopRun()
            while (!isStopped) {
                runloop.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 120))
            }
        }
    }
    
    @objc open func threadStop() {
        if let port = myThread?.port {
            RunLoop.current.remove(port, forMode: .defaultRunLoopMode)
        }
        isStopped = true
        CFRunLoopStop(CFRunLoopGetCurrent())
    }
    
    @objc open func printSomething() {
        if let myThread = self.myThread {
            if myThread.isExecuting {
                self.perform(#selector(printSomethingOnSecondaryThread), on: myThread, with: nil, waitUntilDone: false)
            }
        }
    }
    
    @objc open func printSomethingOnSecondaryThread() {
        NSLog("Thread responds to action")
    }
}

