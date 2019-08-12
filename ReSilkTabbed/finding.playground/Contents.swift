import UIKit

var str = "Hello, playground"


func find(a:[Character], b: Character) -> Int {
    var position = 0
    for strIndex in 0 ..< a.count {
        if b != a[strIndex] {
            position += 1
        } else {
            break
        }
    }
    if position == a.count {
        return -1
    } else {
        return position
    }
}

let a1 = Array("just a test")

print(find(a: a1, b: "e"))


