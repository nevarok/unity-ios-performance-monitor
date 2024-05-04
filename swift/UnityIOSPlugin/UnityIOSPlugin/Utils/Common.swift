//
//  Common.swift
//  UnityIOSPlugin
//
//  Created by Kyrylo Mishakin on 2024/5/3.
//

import Foundation

struct Statistics<T: Comparable & AdditiveArithmetic>
{
    var sum: T = .zero
    var min: T = .zero
    var max: T = .zero
    
    mutating func update(value: T)
    {
        sum += value
        min = Swift.min(min, value)
        max = Swift.max(max, value)
    }
    
    mutating func reset(min: T, max: T)
    {
        sum = .zero
        self.min = min
        self.max = max
    }
    
    var description: String
    {
        return "Sum: \(sum), Min: \(min), Max: \(max)"
    }
}
