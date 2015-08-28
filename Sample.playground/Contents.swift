import UIKit
import SwiftRegexLiteral

let value = "abcd"

/*:
## get first pattern match value
*/
value.match(/"[a-z]"/)
value.match(/"[0-9]"/)

value ~ /"[a-z]"/
value ~ /"[0-9]"/
/*:
## decision pattern match
*/
value.isMatch(/"[a-z]"/)
value.isMatch(/"[0-9]"/)

value =~ /"[a-z]"/
value =~ /"[0-9]"/
/*:
## using options
*/
// all pattern match
value ~ /"[a-z]"/.g

// case insensitive
value ~ /"[A-Z]"/.i

// combination
value ~ /"[A-Z]"/.i.g
