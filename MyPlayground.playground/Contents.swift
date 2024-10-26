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

let mcdonalds: Shop =  Shop(name: "ムラサキスポーツ",
                            goods: [Good(name: "ラケット", price: 3000),
                                    Good(name: "グローブ", price: 4000),
                                    Good(name: "スパイク", price: 5000)
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

let nano: Shop = Shop(name: "nano universe",
                      goods: [Good(name: "服", price: 6000),
                              Good(name: "パンツ", price: 5000),
                              Good(name: "スーツ", price: 15000),
                             ]
                     )

AEON.append(nano)

AEON[2]
AEON.count



//買ったもの
var bougthItem:[Good] = []


//買いたいものを選んで、買ってく
let NIKEのスパイク = AEON[0].goods[2]
let ３Coindsのコップ = AEON[1].goods[0]
let nanoのパンツ = AEON[2].goods[1]
bougthItem.append(NIKEのスパイク)
bougthItem.append(３Coindsのコップ)
bougthItem.append(nanoのパンツ)

//買ったものを確認する。
print(bougthItem)








