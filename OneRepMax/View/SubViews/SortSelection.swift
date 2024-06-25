//
//  SortSelection.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//


import Foundation

enum SortSelection: String, Identifiable, CaseIterable {
    case NoOrder = "NoOrder"
    case Name = "Name"
    case Load = "1RM"
    case LoadRevert = "! 1RM"
    case Favorities = "Favorities"
    
    var id: Self { self }
    
}
