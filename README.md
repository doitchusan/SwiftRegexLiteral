SwiftRegexLiteral
====

Pseudoly regular expression Literal for swift.

## Requirement

Swift 1.2 / iOS 8.0+

## Usage


### First pattern match value

```
let value = "abcd"

value.match(/"[a-z]"/)  // ["a"]
value.match(/"[0-9]"/)  // nil

value ~ /"[a-z]"/       // ["a"]
value ~ /"[0-9]"/       // nil
```


### Decision pattern match

```
let value = "abcd"

value.isMatch(/"[a-z]"/)    // true
value.isMatch(/"[0-9]"/)    // false

value =~ /"[a-z]"/          // true
value =~ /"[0-9]"/          // false
```


### Option Flags

```
let value = "abcd"

// all pattern match
value ~ /"[a-z]"/.g     // ["a", "b", "c", "d"]

// case insensitive
value ~ /"[A-Z]"/.i     // ["a"]

// combination
value ~ /"[A-Z]"/.i.g   // ["a", "b", "c", "d"]
```

## License

The MIT License. See LICENSE for details.

====

[@doitchusan](https://twitter.com/doitchusan)
