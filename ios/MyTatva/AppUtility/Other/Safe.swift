//
//  Safe.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 21/01/21.
//


extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
