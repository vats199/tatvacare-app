//
//  Bindable.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 28/02/21.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    private lazy var observer: ((T?) -> ())? = nil
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
