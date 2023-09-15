//
//  Debouncer.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation

class Debouncer {
    
    /**
     Create a new Debouncer instance with the provided time interval.
     
     - parameter timeInterval: The time interval of the debounce window.
     */
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    typealias Handler = () -> Void
    
    /// Closure to be debounced.
    /// Perform the work you would like to be debounced in this handler.
    var handler: Handler?
    
    /// Time interval of the debounce window.
    private let timeInterval: TimeInterval
    
    private var timer: Timer?
    
    /// Indicate that the handler should be invoked.
    /// Begins the debounce window with the duration of the time interval parameter.
    func renewInterval() {
        // Invalidate existing timer if there is one
        timer?.invalidate()
        // Begin a new timer from now
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] timer in
                self?.handleTimer(timer)
            })
        } else {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func handleTimer(_ timer: Timer) {
        guard timer.isValid else {
            return
        }
        handler?()
//        handler = nil
    }
    
}
