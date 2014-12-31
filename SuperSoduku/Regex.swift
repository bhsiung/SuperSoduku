//
//  Regex.swift
//  SuperSoduku
//
//  Created by BIINGYANN HSIUNG on 12/30/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

import Foundation

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init( pattern: String) {
        self.pattern = pattern
        var error: NSError?
        self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
    }
    
    func test(input: String) -> Bool {
        let count = self.internalExpression.numberOfMatchesInString(input, options: nil, range: NSMakeRange(0, countElements(input)));
        return count > 0
    }
    func match(input: String) -> Array<AnyObject> {
        let matches: Array = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, countElements(input)))
        return matches
    }
}