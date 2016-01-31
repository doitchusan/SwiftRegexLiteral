//
//  SwiftRegexLiteral.swift
//  SwiftRegexLiteral
//
//  Created by Yoshitaka Kato on 2015/08/28.
//  Copyright (c) 2015年 Yoshitaka Kato. All rights reserved.
//

import Foundation

public struct RegexOptions : OptionSetType {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /**
    ignore case
    */
    public static let i = RegexOptions(rawValue: 1)
    
    /**
    global match
    */
    public static let g = RegexOptions(rawValue: 2)
    
    /**
    multiline
    */
    public static let m = RegexOptions(rawValue: 4)
}

extension RegexOptions : CustomStringConvertible {
    public var description: String {
        var names = [String]()
        
        if self.contains(.i) {
            names.append("i")
        }
        
        if self.contains(.g) {
            names.append("g")
        }
        
        if self.contains(.m) {
            names.append("m")
        }
        
        return "{" + names.joinWithSeparator(",") + "}"
    }
}

//MARK: - regular expression protocol

public protocol RegexMatching : Hashable {
    var pattern: String { get }
    var options: RegexOptions { get }
    
    func match(string: String) -> [String]
    func isMatch(string: String) -> Bool
}

extension RegexMatching {
    public var hashValue: Int {
        return "\(self.pattern)\(self.options.rawValue)".hashValue
    }
}

public func == <T:RegexMatching>(lhs: T, rhs: T) -> Bool {
    return lhs.pattern == rhs.pattern && lhs.options == rhs.options
}

public final class Regex : RegexMatching {
    /**
     regular expression pattern
     */
    public let pattern: String
    
    /**
     option flags
     */
    public private(set) var options: RegexOptions
    
    private lazy var regex: NSRegularExpression? = { [unowned self] in
        var nsOptions: NSRegularExpressionOptions = []
        
        if self.options.contains(.i) {
            nsOptions = nsOptions.union(.CaseInsensitive)
        }
        
        if self.options.contains(.m) {
            nsOptions = nsOptions.union([.AnchorsMatchLines, .DotMatchesLineSeparators])
        }
        
        return try? NSRegularExpression(pattern: self.pattern, options: nsOptions)
    }()
    
    public convenience init(pattern: String) {
        self.init(pattern: pattern, options: [])
    }
    
    public init(pattern: String, options: RegexOptions) {
        self.pattern = pattern
        self.options = options
    }
    
    public func match(string: String) -> [String] {
        guard let regex = self.regex else {
            return []
        }
        
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matchesInString(string, options: [], range: range)
        
        var matchedTokens = [String]()
        for result in matches {
            for var i = 0; i < result.numberOfRanges; i++ {
                let r = result.rangeAtIndex(i)
                if r.location <= string.characters.count && r.length > 0 {
                    matchedTokens.append((string as NSString).substringWithRange(r))
                }
                
                if self.options.contains(.g) {
                    break
                }
            }
            
            if !self.options.contains(.g) {
                break
            }
        }
        
        return matchedTokens
    }
    
    public func isMatch(string: String) -> Bool {
        guard let regex = self.regex else {
            return false
        }
        
        let range = NSRange(location: 0, length: string.characters.count)
        let numberOfMatches = regex.numberOfMatchesInString(string, options: [], range: range)
        
        return numberOfMatches > 0
    }
}

extension Regex : CustomStringConvertible {
    public var description: String {
        return "{pattern: \(self.pattern), options: \(self.options)}"
    }
}

public struct IntermediateRegexliteral {
    private let regex: Regex
    
    private init(pattern: String) {
        self.regex = Regex(pattern: pattern)
    }
    
    public var i: IntermediateRegexliteral {
        self.regex.options = self.regex.options.union(.i)
        return self
    }
    
    public var g: IntermediateRegexliteral {
        self.regex.options = self.regex.options.union(.g)
        return self
    }
    
    public var m: IntermediateRegexliteral {
        self.regex.options = self.regex.options.union(.m)
        return self
    }
}

extension IntermediateRegexliteral : CustomStringConvertible {
    public var description: String {
        return self.regex.description
    }
}

public struct RegexLiteral : RegexMatching {
    private var regex: Regex
    
    public var pattern: String {
        return self.regex.pattern
    }
    
    public var options: RegexOptions {
        return self.regex.options
    }
    
    private init(pattern: String) {
        self.regex = Regex(pattern: pattern)
    }
    
    private init(regex: Regex) {
        self.regex = regex
    }
    
    public var i: RegexLiteral {
        let regex = Regex(pattern: self.pattern, options: self.options.union(.i))
        let literal = RegexLiteral(regex: regex)
        
        return literal
    }
    
    public var g: RegexLiteral {
        let regex = Regex(pattern: self.pattern, options: self.options.union(.g))
        let literal = RegexLiteral(regex: regex)
        
        return literal
    }
    
    public var m: RegexLiteral {
        let regex = Regex(pattern: self.pattern, options: self.options.union(.m))
        let literal = RegexLiteral(regex: regex)
        
        return literal
    }
    
    public func match(string: String) -> [String] {
        return self.regex.match(string)
    }
    
    public func isMatch(string: String) -> Bool {
        return self.regex.isMatch(string)
    }
}

extension RegexLiteral : StringLiteralConvertible {
    public init(stringLiteral value: StringLiteralType) {
        self.init(pattern: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(pattern: value)
    }
    
    public init(unicodeScalarLiteral value:String) {
        self.init(pattern: value)
    }
}

extension RegexLiteral : CustomStringConvertible {
    public var description: String {
        return self.regex.description
    }
}

//MARK: - literal operator

prefix operator / {}
postfix operator / {}

public prefix func / (intermediate: IntermediateRegexliteral) -> RegexLiteral {
    return RegexLiteral(regex: intermediate.regex)
}

public postfix func / (pattern: String) -> IntermediateRegexliteral {
    return IntermediateRegexliteral(pattern: pattern)
}

//MARK: - matching operator

infix operator ~ {}
infix operator =~ {}

public func ~ <T:RegexMatching>(lhs: T, rhs: String) -> [String] {
    return lhs.match(rhs)
}

public func ~ <T:RegexMatching>(lhs: String, rhs: T) -> [String] {
    return rhs.match(lhs)
}

public func =~ <T:RegexMatching>(lhs: T, rhs: String) -> Bool {
    return lhs.isMatch(rhs)
}

public func =~ <T:RegexMatching>(lhs: String, rhs: T) -> Bool {
    return rhs.isMatch(lhs)
}

//MARK: - switch-case pattern matching

public func ~= <T:RegexMatching>(lhs: T, rhs: String) -> Bool {
    return lhs.isMatch(rhs)
}

public func ~= <T:RegexMatching>(lhs: String, rhs: T) -> Bool {
    return rhs.isMatch(lhs)
}

//MARK: - extension for String

public extension String {
    public func match<T:RegexMatching>(regex: T) -> [String] {
        return regex.match(self)
    }
    
    public func isMatch<T:RegexMatching>(regex: T) -> Bool {
        return regex.isMatch(self)
    }
}
