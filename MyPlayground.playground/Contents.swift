import UIKit
import SwiftData

//イオン

//お店
struct Shop {
    let name: String
    let goods: [Good]
}

//お店にある商品
struct Good {
    let name: String
    let price: Int
}

// 多分イオンってお店があって、お店には商品があるはず、、、


// イオンを作る

var AEON: [Shop] = []

let mcdonalds: Shop =  Shop(name: "マクド",
                            goods: [Good(name: "月見", price: 250),
                                    Good(name: "ハンバーガー", price: 100),
                                    Good(name: "ポテト", price: 150)
                                   ]
                        )

AEON.append(mcdonalds)

AEON[0]

let threeCoins: Shop =  Shop(name: "3COINS",
                         goods: [Good(name: "コップ", price: 300),
                                 Good(name: "皿", price: 200),
                                 Good(name: "傘", price: 500)
                                ]
                        )

AEON.append(threeCoins)

AEON[1]
//aeon.count

let nano: Shop = Shop(name: "nano",
                      goods: [Good(name: "服", price: 6000),
                              Good(name: "パンツ", price: 5000),
                              Good(name: "スーツ", price: 15000),
                             ]
                     )

AEON.append(nano)

AEON[2]
AEON.count


let フライドポテト = AEON[0].goods[2]

let コップ = AEON[1].goods[0]




// お店が完成。






// お客さん目線


//どれがほしいのか選ぶ




//選んだものを３つ選びだす


