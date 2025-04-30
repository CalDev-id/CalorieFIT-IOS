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
    var selectedActivity: Int
    var selectedGoal: Int

    init(inputName: String, inputAge: Int, selectedGender: String, inputHeight: Double, inputWeight: Double, selectedActivity: Int, selectedGoal: Int) {
        self.inputName = inputName
        self.inputAge = inputAge
        self.selectedGender = selectedGender
        self.inputHeight = inputHeight
        self.inputWeight = inputWeight
        self.selectedActivity = selectedActivity
        self.selectedGoal = selectedGoal
    }
}
