//
//  SwiftRegexLiteral.swift
//  SwiftRegexLiteral
//
//  Created by Yoshitaka Kato on 2015/08/28.
//  Copyright (c) 2015年 doitchusan. All rights reserved.
//

import Foundation

public class RegexLiteral {
    private var value: String
    
    private var flag_i: Bool = false
    private var flag_g: Bool = false
    private var flag_m: Bool = false
    
    private init (_ value : String) {
        self.value = value
    }
    
    public var i: RegexLiteral {
        get {
            self.flag_i = true
            return self
        }
    }
    
    public var g: RegexLiteral {
        get {
            self.flag_g = true
            return self
        }
    }
    
    public var m: RegexLiteral {
        get {
            self.flag_m = true
            return self
        }
    }
}

public class Regex {
    private var literal: RegexLiteral
    
    private init (literal: RegexLiteral) {
        self.literal = literal
    }
    
    public func match(s: String) -> [String]? {
        var options = NSRegularExpressionOptions.allZeros
        
        if self.literal.flag_i {
            options |= .CaseInsensitive
        }
        
        if self.literal.flag_m {
            options |= (.AnchorsMatchLines | .DotMatchesLineSeparators)
        }
        
        var error: NSError?
        if let rexp = NSRegularExpression(pattern: self.literal.value, options: options, error: &error) {
            if error != nil {
                return nil
            }
            
            var results = [String]()
            var matches = rexp.matchesInString(s, options: nil, range: NSMakeRange(0, count(s)))
            for var i = 0; i < matches.count; i++ {
                var chResult = matches[i] as! NSTextCheckingResult
                for var r = 0; r < chResult.numberOfRanges ; r++ {
                    var range = chResult.rangeAtIndex(r)
                    if range.location <= count(s.utf16) && range.length > 0 {
                        var matchString = (s as NSString).substringWithRange(range)
                        results.append(matchString)
                    }
                    
                    if self.literal.flag_g {
                        break
                    }
                }
                
                if !self.literal.flag_g {
                    break
                }
            }
            
            if results.count > 0 {
                return results
            }
        }
        
        return nil
    }
    
    public func isMatch(s: String) -> Bool {
        var options = NSRegularExpressionOptions.allZeros
        
        if self.literal.flag_i {
            options |= .CaseInsensitive
        }
        
        if self.literal.flag_m {
            options |= .DotMatchesLineSeparators
        }
        
        var numberOfMatches : Int = 0
        
        var error: NSError?
        if let rexp = NSRegularExpression(pattern: self.literal.value, options: options, error: &error) {
            numberOfMatches = rexp.numberOfMatchesInString(s, options: nil, range: NSMakeRange(0, count(s)))
        }
        
        return numberOfMatches > 0
    }
}

prefix operator / {}
postfix operator / {}
infix operator ~ {}
infix operator =~ {}

public postfix func / (s: String) -> RegexLiteral {
    return RegexLiteral(s)
}

public prefix func / (literal: RegexLiteral) -> Regex {
    return Regex(literal: literal)
}

public func ~ (left: String, right: Regex) -> [String]? {
    return right.match(left)
}

public func ~ (left: Regex , right: String) -> [String]? {
    return left.match(right)
}

public func =~ (left: String, right: Regex) -> Bool {
    return right.isMatch(left)
}

public func =~ (left: Regex , right: String) -> Bool {
    return left.isMatch(right)
}

public extension String {
    public func match(regex: Regex) -> [String]? {
        return regex.match(self)
    }
    
    public func isMatch(regex: Regex) -> Bool {
        return regex.isMatch(self)
    }
}
