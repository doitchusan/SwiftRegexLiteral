SwiftRegexLiteral
====

Pretending regular expression literal library for swift

## Requirement

Swift 2.0 / iOS 8.0+

## Usage

### Matching value

```swift
// no option flags
"abcd".match(/"[a-z]"/)     // ["a"]
"abcd".match(/"[0-9]"/)     // []

"abcd" ~ /"[a-z]"/          // ["a"]
"abcd" ~ /"[0-9]"/          // []

// option flags (multiline)
"abcd\nefgh" ~ /"^.+"/.m    // ["abcd\nefgh"]

// option flags (ignore case)
"ABCD" ~ /"[a-z]"/.i        // ["A"]

// option flags (all pattern match)
"abcd" ~ /"[a-z]"/.g        // ["a", "b", "c", "d"]

// option flags (combination)
"ABCD" ~ /"[a-z]"/.i.g      // ["A", "B", "C", "D"]
```


### Matching check

```swift
"abcd".isMatch(/"[a-z]"/)    // true
"abcd".isMatch(/"[0-9]"/)    // false

"abcd" =~ /"[a-z]"/          // true
"abcd" =~ /"[0-9]"/          // false
```

### Switch-case pattern matching

```swift
switch "abcd" {
case /"^[0-9]+$"/:
    break

case /"^[a-z]+$"/:  // match!!
    break

case /"^[A-Z]+$"/:
    break

default:
    break
}

switch /"^[a-z]+$"/ {
case "1234":
    break

case "abcd":        // match!!
    break

case "ABCD":
    break

default:
    break
}
```

## License

The MIT License. See LICENSE for details.

====

[@doitchusan](https://twitter.com/doitchusan)
