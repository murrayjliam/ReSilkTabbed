import Foundation


func sort(s1:String, s2:String) -> (String, String) {
    if s1.count <= s2.count {
        return (s1, s2)
    }
    return (s2, s1)
}

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

func jaroWinklerDistance (in_s1:String, in_s2:String) -> Float {
    let (s1, s2) = sort (s1: in_s1.lowercased(), s2: in_s2.lowercased())
    
    if s1.characters.count == 1 || s2.characters.count  == 1 {
        return 0
    }
    
    var m = 0, t = 0, l = 0
    
    let window = floor(Float(max(s1.count, s2.count)) / 2 - 1)
    
    var s1_array = Array(s1)
    var s2_array = Array(s2)
    //    var s1_array = [String]()
    //    var s2_array = [String]()

    var index = 0
    //    var count = 0
    //    for characters in s1 {
    //        count += 1
    //        s1_array.append(s1)
    //    }
    //    for characters in s2 {
    //        count += 1
    //        s2_array.append(s2)
    //    }
    for characterOne in s1 {
        if characterOne == s2_array[index] {
            m += 1
            if index == l && index < 4 {
                l += 1
            }
        } else {
            if s2_array.contains(characterOne) {
                let gap = find(a:s2_array, b: characterOne) - index
                if gap <= Int(window) {
                    m += 1
                    for k in index..<s1_array.count {
                        if find(a: s2_array, b: s1_array[k]) <= index {
                            t += 1
                        }
                    }
                }
            }
        }
        
        index += 1
    }
    
    let distanceFirst = Float(m)/Float(s1.count) + Float(m)/Float(s2.count)
    let distanceSecond = (Float(m)-floor(Float(t)/Float(2)))/Float(m)
    let distance = (distanceFirst + distanceSecond) / Float(3)
    let jwd = distance + (Float(l) * Float(0.1) * (Float(1) - distance))
    
    return jwd
}
