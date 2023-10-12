//
//  main.swift
//  Software-Calculator
//
//  Created by 田中陽一朗 on 2023/10/12.
//

import Foundation

let 最大値 = Decimal(99_999_999) / 1000
let 最小値 = Decimal(-99_999_999) / 1000
let 最大小数位 = 4

func printDecimal(_ decimal: Decimal) {
  let roundingBehavior = NSDecimalNumberHandler(
    roundingMode: .plain,
    scale: 4,
    raiseOnExactness: false,
    raiseOnOverflow: false,
    raiseOnUnderflow: false,
    raiseOnDivideByZero: false
  )
  let roundedValue = NSDecimalNumber(decimal: decimal).rounding(
    accordingToBehavior: roundingBehavior)
  print(roundedValue)
}

enum CalculateOperator: String, CaseIterable {
  case 足し算 = "+"
  case 引き算 = "-"
  case 掛け算 = "*"
  case 割り算 = "/"

  static func of(_ arg: String) -> Self? {
    allCases.first { $0.rawValue == arg }
  }

  func calculate(_ lhs: Decimal, _ rhs: Decimal) {
    switch self {
    case .足し算:
      printDecimal(lhs + rhs)
    case .引き算:
      printDecimal(lhs - rhs)
    case .掛け算:
      printDecimal(lhs * rhs)
    case .割り算:
      guard rhs != 0 else {
        print("0で割ることはできません")
        exit(1)
      }
      printDecimal(lhs / rhs)
    }
  }
}

extension String {

  static let separator = "."

  var is数値: Bool {
    Double(self) != nil
  }

  var 小数位: Int {
    guard contains(Self.separator) else { return 0 }
    let separated = split(separator: Self.separator)
    guard separated.count == 2 else {
      return 0
    }
    return separated[1].count
  }

  var decimal: Decimal? {
    let pointRemoved = replacingOccurrences(of: Self.separator, with: "")
    guard let int = Int(pointRemoved) else {
      return nil
    }
    return Decimal(int) / pow(10, 小数位)
  }
}

guard CommandLine.arguments.count == 4 else {
  print("引数値の数は3つである必要があります")
  exit(1)
}

let leftArg = CommandLine.arguments[1]
let middleArg = CommandLine.arguments[2]
let rightArg = CommandLine.arguments[3]

guard leftArg.is数値, let lhs = leftArg.decimal else {
  print("左辺: \(leftArg)は数値である必要があります")
  exit(1)
}

guard lhs <= 最大値 else {
  print("左辺: \(leftArg)は最大値\(最大値)を上回っています")
  exit(1)
}

guard lhs >= 最小値 else {
  print("左辺: \(leftArg)は最小値\(最小値)を下回っています")
  exit(1)

}

guard leftArg.小数位 <= 最大小数位 else {
  print("左辺: \(leftArg)は小数点第4位以下で収まっていません")
  exit(1)
}

guard let calculateOperator = CalculateOperator.of(middleArg) else {
  print("演算子: \(middleArg)はサポートされていません")
  exit(1)
}

guard rightArg.is数値, let rhs = rightArg.decimal else {
  print("左辺: \(rightArg)は数値である必要があります")
  exit(1)
}

guard rhs <= 最大値 else {
  print("左辺: \(rightArg)は最大値\(最大値)を上回っています")
  exit(1)
}

guard rhs >= 最小値 else {
  print("左辺: \(rightArg)は最小値\(最小値)を下回っています")
  exit(1)

}

guard rightArg.小数位 <= 最大小数位 else {
  print("左辺: \(rightArg)は小数点第4位以下で収まっていません")
  exit(1)
}

calculateOperator.calculate(lhs, rhs)
