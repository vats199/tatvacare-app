//
//  AppointmentBcaTimeModel.swift
//  MyTatva
//
//  Created by Uttam patel on 02/06/23.
//


import Foundation

class BcaTimeSlotResultModel {
    var sectionTitle: String!
    var timeSlot: [BcaTimeSlot]!
    var isSelected: Bool!
    
    
   init() {
        
    }
    
    init(sectionTitle: String, timeSlot: [BcaTimeSlot], isSelected: Bool){
        self.sectionTitle = sectionTitle
        self.timeSlot = timeSlot
        self.isSelected = isSelected
    }
}


class BcaTimeSlot {
    var timimg: String!
   
    init() {
        
    }
    
    init(timing: String) {
        self.timimg = timing
        
    }
    
}

