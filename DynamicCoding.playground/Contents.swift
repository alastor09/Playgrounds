//: Playground - noun: a place where people can play


// Dynamic coding

import UIKit

struct Person {
    let firstName: String
    let lastName: String
    let yearOfBirth: Int
    init(firstName: String, lastName: String, yearOfBirth: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.yearOfBirth = yearOfBirth
    }
}

let people = [
    Person(firstName: "Frances", lastName: "Lovelace", yearOfBirth: 1815),
    Person(firstName: "Ada", lastName: "Hopper", yearOfBirth: 1906),
    Person(firstName: "Grace", lastName: "Allen", yearOfBirth: 1932),
    Person(firstName: "Barbara", lastName: "Liskov", yearOfBirth: 1976)
]

struct SortDescriptor<A> {
    let compare: (A, A) -> ComparisonResult
}

extension SortDescriptor{
    init<Property> (property: @escaping (A) -> Property, compare: @escaping (Property) -> (Property) -> ComparisonResult){
        self = SortDescriptor { p1, p2 in
            compare(property(p1))(property(p2))
        }
    }
    func isAscending(L: A, r: A) -> Bool{
        return compare(L, r) == .orderedAscending
    }
}


let lcic = String.localizedCaseInsensitiveCompare

let lastNameSD: SortDescriptor<Person> = SortDescriptor(property: { $0.lastName}, compare: lcic)

let firstNameSD: SortDescriptor<Person> = SortDescriptor(property: {$0.firstName}, compare: lcic)

func combine<A> (_ sortDescriptors: [SortDescriptor<A>]) -> SortDescriptor<A>{
    return SortDescriptor{ l,r in
        for sortDescriptor in sortDescriptors{
            let result = sortDescriptor.compare(l,r)
            if result == .orderedSame { continue }
            return result
        }
        return .orderedSame
    }
}

people.sorted(by: lastNameSD.isAscending)

people.sorted(by: combine([lastNameSD, firstNameSD]).isAscending)






