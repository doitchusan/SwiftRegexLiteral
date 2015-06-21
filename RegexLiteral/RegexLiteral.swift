//
//  RegexLiteral.swift
//  RegexLiteral
//
//  Created by yoshitaka on 2014/11/08.
//  Copyright (c) 2014年 yoshitaka. All rights reserved.
//

import Foundation

public class RegexLiteral {
    // 正規表現のパターン文字列
    private var value : String
    
    // 各種フラグ
    private var flag_i : Bool = false
    private var flag_g : Bool = false
    private var flag_m : Bool = false
    
    public init (_ value : String) {
        self.value = value
    }
    
    /**
    * 大文字・小文字無視
    */
    public var i : RegexLiteral {
        get {
            self.flag_i = true
            return self
        }
    }
    
    /**
    * 複数マッチ
    */
    public var g : RegexLiteral {
        get {
            self.flag_g = true
            return self
        }
    }
    
    /**
    * 複数行検索
    */
    public var m : RegexLiteral {
        get {
            self.flag_m = true
            return self
        }
    }
}

public class Regex {
    private var literal : RegexLiteral
    
    private init (_ literal : RegexLiteral) {
        self.literal = literal
    }
    
    public func match(s: String) -> Array<String>? {
        // オプションフラグ
        var options = NSRegularExpressionOptions.allZeros
        
        if self.literal.flag_i {
            options |= .CaseInsensitive
        }
        
        if self.literal.flag_m {
            options |= .DotMatchesLineSeparators
        }
        
        var error: NSError?
        if let rexp = NSRegularExpression(pattern: self.literal.value, options: options, error: &error) {
            if error != nil {
                return nil
            }
            
            var results = Array<String>()
            var matches = rexp.matchesInString(s, options: nil, range: NSMakeRange(0, count(s.utf16)))
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
        // オプションフラグ
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
            numberOfMatches = rexp.numberOfMatchesInString(s, options: nil, range: NSMakeRange(0, count(s.utf16)))
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
    return Regex(literal)
}

public func ~ (left: String, right: Regex) -> Array<String>? {
    return right.match(left)
}

public func ~ (left: Regex , right: String) -> Array<String>? {
    return left.match(right)
}

public func =~ (left: String, right: Regex) -> Bool {
    return right.isMatch(left)
}

public func =~ (left: Regex , right: String) -> Bool {
    return left.isMatch(right)
}

public extension String {
    public func match(regex: Regex) -> Array<String>? {
        return regex.match(self)
    }
    
    public func isMatch(regex: Regex) -> Bool {
        return regex.isMatch(self)
    }
}
