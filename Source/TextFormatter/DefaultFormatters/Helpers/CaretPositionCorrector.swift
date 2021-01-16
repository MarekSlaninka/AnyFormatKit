//
//  CaretPositionCorrector.swift
//  AnyFormatKit
//
//  Created by Oleksandr Orlov on 02.04.2018.
//  Copyright © 2018 Oleksandr Orlov. All rights reserved.
//

import Foundation

class CaretPositionCorrector {
  let textPattern: String
  let patternSymbol: Character
  
  // MARK: - Life Cycle
  init(textPattern: String, patternSymbol: Character) {
    self.textPattern = textPattern
    self.patternSymbol = patternSymbol
  }
  
  /**
   Find and correct of new caret position
   
   - Parameters:
   - textInput: Text input, that caret position need to correct
   - originalRange: Range of characters in textInput, that will replaced
   - replacementFiltered: Filtered string, that will replace characters in range
   */
  func calculateCaretPositionOffset(originalRange range: NSRange, replacementFiltered: String) -> Int {
    var offset = 0
    if replacementFiltered.isEmpty {
      offset = offsetForRemove(current: range.location)
    } else {
      offset = offsetForInsert(from: range.location, replacementLength: replacementFiltered.count)
    }
    return offset
  }
  
  func calculateCaretPositionOffset(newText: String, originalRange range: Range<String.Index>, replacementText: String) -> Int {
    var offset = 0
    
    if replacementText.isEmpty {
      offset = offsetForRemove(newText: newText, lowerBound: range.lowerBound)
    } else {
      offset = offsetForInsert(newText: newText, lowerBound: range.lowerBound, replacementLength: replacementText.count)
    }
    return offset
  }
  
  /**
   Find indexes of patterns symbols in range
   
   - Parameters:
   - searchRange: Range in string for searching indexes
   
   - Returns: Array of indexes of characters, that equal to patternSymbol in textPattern
   */
  func indexesOfPatternSymbols(in searchRange: Range<String.Index>) -> [String.Index] {
    var indexes: [String.Index] = []
    var tempRange = searchRange
    while let range = textPattern.range(
            of: String(patternSymbol),
            options: .caseInsensitive,
            range: tempRange
    ) {
        tempRange = range.upperBound..<tempRange.upperBound
        indexes.append(range.lowerBound)
    }
    return indexes
  }
  
  /**
   Calculate offset for caret, when characters will remove
   
   - Parameters:
   - current: Current location of caret
   
   - Returns: Offset for caret from beginning of textPattern while remove characters in textInput
   */
  func offsetForRemove(current location: Int) -> Int {
    let startIndex = textPattern.startIndex
    let searchRange = startIndex..<textPattern.index(startIndex, offsetBy: location)
    let indexes = indexesOfPatternSymbols(in: searchRange)
    
    if let lastIndex = indexes.last {
        return lastIndex.utf16Offset(in: textPattern) + 1
    }
    return 0
  }
  
  func offsetForRemove(newText: String, lowerBound: String.Index) -> Int {
    let textPatternLowerBound = textPattern.getSameIndex(asIn: newText, sourceIndex: lowerBound)
    let textPatternIndex = textPattern.findIndexBefore(of: patternSymbol, startFrom: textPatternLowerBound)
    let index = newText.getSameIndex(asIn: textPattern, sourceIndex: textPatternIndex)
    let leftSlice = newText.leftSlice(end: index)
    return leftSlice.utf16.count
    
//    let startIndex = textPattern.startIndex
//    let searchRange = startIndex..<lowerBound
//    let indexes = indexesOfPatternSymbols(in: searchRange)
//    guard let lastIndex = indexes.last else { return 0 }
//    return lastIndex.utf16Offset(in: textPattern) + 1
  }
  
  /**
   Calculate offset for caret, when characters will insert
   
   - Parameters:
   - from: Current location of caret
   - replacementLength: Length of replacement string
   
   - Returns: Offset for caret from beginning of textPattern while insert characters in textInput
   */
  func offsetForInsert(from location: Int, replacementLength: Int) -> Int {
    let startIndex = textPattern.index(textPattern.startIndex, offsetBy: location)
    let searchRange = startIndex..<textPattern.endIndex
    let indexes = indexesOfPatternSymbols(in: searchRange)
    
    if replacementLength <= indexes.count {
      return textPattern.distance(from: textPattern.startIndex, to: indexes[replacementLength - 1]) + 1
    } else {
      return textPattern.distance(from: textPattern.startIndex, to: textPattern.endIndex)
    }
  }
  
  func offsetForInsert(newText: String, lowerBound: String.Index, replacementLength: Int) -> Int {
    let textPatternLowerBound = textPattern.getSameIndex(asIn: newText, sourceIndex: lowerBound)
    let textPatternIndex = textPattern.findIndex(of: patternSymbol, skipFirst: replacementLength, startFrom: textPatternLowerBound)
    let index = newText.getSameIndex(asIn: textPattern, sourceIndex: textPatternIndex)
    let leftSlice = newText.leftSlice(end: index)
    return leftSlice.utf16.count
  }
}
