//
//  Array+Only.swift
//  Memorize
//
//  Created by Hidaner Ferrer on 1/12/21.
//

import Foundation


extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
