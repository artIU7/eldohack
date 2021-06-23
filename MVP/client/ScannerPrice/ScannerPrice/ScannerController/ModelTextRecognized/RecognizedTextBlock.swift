//
//  RecognizedTextBlock.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 23.06.2021.
//

import Foundation
import Vision

struct RecognizedTextBlock {
    
    let doubleValue: Double
    let recognizedRect: CGRect
    var imageRect: CGRect = .zero
    
}

