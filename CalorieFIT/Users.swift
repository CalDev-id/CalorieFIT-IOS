//
//  Users.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 12/03/25.
//

import SwiftData

@Model
final class Users {
    var inputName: String
    var inputAge: Int
    var selectedGender: String
    var inputHeight: Double
    var inputWeight: Double

    init(inputName: String, inputAge: Int, selectedGender: String, inputHeight: Double, inputWeight: Double) {
        self.inputName = inputName
        self.inputAge = inputAge
        self.selectedGender = selectedGender
        self.inputHeight = inputHeight
        self.inputWeight = inputWeight
    }
}
