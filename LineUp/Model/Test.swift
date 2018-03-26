//
//  Test.swift
//  LineUp
//
//  Created by Bjarne Møller Lundgren on 26/03/2018.
//  Copyright © 2018 Bjarne Møller Lundgren. All rights reserved.
//

import UIKit

class Test {
    // https://en.wikipedia.org/wiki/UEFA_Euro_1992_Final
    static var denmark:Team = Team(
        name: "Danmark",
        shirtColor: UIColor.red,
        pantsColors: UIColor.white,
        players: [
            Player(name: "Peter Schmeichel",
                   position: .keeper,
                   number: 1
            ),
            Player(name: "Lars Olsen",
                   position: .defense,
                   number: 4
            ),
            Player(name: "Torben Piechnik",
                   position: .defense,
                   number: 12
            ),
            Player(name: "Kent Nielsen",
                   position: .defense,
                   number: 3
            ),
            Player(name: "John Sivebæk",
                   position: .defense,
                   number: 2
            ),
            Player(name: "Kim Christofte",
                   position: .defense,
                   number: 6
            ),
            Player(name: "John Jensen",
                   position: .midfield,
                   number: 7
            ),
            Player(name: "Kim Vilfort",
                   position: .midfield,
                   number: 18
            ),
            Player(name: "Henrik Larsen",
                   position: .midfield,
                   number: 13
            ),
            Player(name: "Brian Laudrup",
                   position: .forward,
                   number: 11
            ),
            Player(name: "Flemming Povlsen",
                   position: .forward,
                   number: 9
            )
        ]
    )
    static var germany:Team = Team(
        name: "Tyskland",
        shirtColor: UIColor.white,
        pantsColors: UIColor.black,
        players: [
            Player(name: "Bodo Illgner",
                   position: .keeper,
                   number: 1
            ),
            Player(name: "Guido Buchwald",
                   position: .defense,
                   number: 6
            ),
            Player(name: "Jürgen Kohler",
                   position: .defense,
                   number: 4
            ),
            Player(name: "Thomas Helmer",
                   position: .defense,
                   number: 14
            ),
            Player(name: "Stefan Reuter",
                   position: .defense,
                   number: 2
            ),
            Player(name: "Andreas Brehme",
                   position: .defense,
                   number: 3
            ),
            Player(name: "Matthias Sammer",
                   position: .midfield,
                   number: 16
            ),
            Player(name: "Stefan Effenberg",
                   position: .midfield,
                   number: 17
            ),
            Player(name: "Thomas Häßler",
                   position: .midfield,
                   number: 8
            ),
            Player(name: "Karl-Heinz Riedle",
                   position: .forward,
                   number: 11
            ),
            Player(name: "Jürgen Klinsmann",
                   position: .forward,
                   number: 18
            )
        ]
    )
}
