import UIKit
import SwiftRegexLiteral
/*:
## Matching value
*/
// no option flags
"abcd".match(/"[a-z]"/)
"abcd".match(/"[0-9]"/)

"abcd" ~ /"[a-z]"/
"abcd" ~ /"[0-9]"/

// option flags (multiline)
"abcd\nefgh" ~ /"^.+"/.m

// option flags (ignore case)
"ABCD" ~ /"[a-z]"/.i

// option flags (all pattern match)
"abcd" ~ /"[a-z]"/.g

// option flags (combination)
"ABCD" ~ /"[a-z]"/.i.g
/*:
## Matching check
*/
"abcd".isMatch(/"[a-z]"/)
"abcd".isMatch(/"[0-9]"/)

"1234" =~ /"[a-z]"/
"1234" =~ /"[0-9]"/
/*:
## using options
*/
// multiline
"abcd\nefgh" ~ /"^.+"/.m

// ignore case
"ABCD" ~ /"[a-z]"/.i

// all pattern match
"abcd" ~ /"[a-z]"/.g

// combination
"ABCD" ~ /"[a-z]"/.i.g

/*:
## Switch-case pattern matching
*/
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
    
case "abcd": // match!!
    break
    
case "ABCD":
    break
    
default:
    break
}

