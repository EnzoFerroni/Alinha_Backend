//
//  Apointment.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 19/08/25.
//

import Fluent
import Vapor
import Foundation

final class Appointment: Model, Content, @unchecked Sendable {
    static let schema = "appointments"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "mentor")
    var mentor: String
    
    @Field(key: "student")
    var student: String
    
    @Field(key: "appointmentPlace")
    var appointmentPlace: String
    
    @Enum(key: "appointmentCategory")
    var appointmentCategory: UserPath
    
    @Enum(key: "appointmentType")
    var appointmentCategory: AppointmentType
    
    @Boolean(key: "isScheduled")
    var isScheduled: Bool
    
    @Boolean(key: "callStudent")
    var callStudent: Bool
    
    @Boolean(key: "isDone")
    var isDone: Bool
    
    
    init() { }
    
    init(id: UUID? = nil, mentor: String, student: String, appointmentPlace: String, appointmentCategory: UserPath, appointmentType: AppointmentType, isScheduled: Bool, callStudent: Bool, isDone: Bool) {
        self.id = id
        self.mentor = mentor
        self.student = student
        self.appointmentPlace = appointmentPlace
        self.appointmentCategory = appointmentCategory
        self.isScheduled = false
        self.callStudent = false
        self.isDone = false
    }
    
    
    func toDTO() -> AppointmentDTO {
        .init (
            id: self.id,
            mentor: self.$mentor.value,
            student: self.$student.value,
            appointmentPlace: self.$appointmentPlace.value,
            appointmentCategory: self.$appointmentCategory.value,
            appointmentType: self.$appointmentCategory.value,
            isScheduled: self.$isScheduled.value,
            callStudent: self.$callStudent.value,
            isDone: self.$isDone.value
        )
    }
}
