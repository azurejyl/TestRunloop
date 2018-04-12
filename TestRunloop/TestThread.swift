//
//  TestThread.swift
//  TestRunloop
//
//  Created by Jiang Yongli on 12/12/17.
//  Copyright © 2017 MicroStrategy. All rights reserved.
//

import Foundation

public class TestThread: Thread {
    var port: NSMachPort?
    
   /* public func stop() {
        if let port = port {
            RunLoop.current.remove(port, forMode: .defaultRunLoopMode)
        }
        
        CFRunLoopStop(CFRunLoopGetCurrent())
        self.cancel()
    }*/
}
