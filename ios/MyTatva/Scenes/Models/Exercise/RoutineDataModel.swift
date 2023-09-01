//
//  RoutineDataModel.swift
//  MyTatva
//
//  Created by Hlink on 11/04/23.
//

import Foundation
struct RoutineDetailsDataModel {
    var title,exerciseType,reps,sets,restPostSets,restPostExercise,desc: String
    var isDone: Bool = false
    var difficulty:String?
}
