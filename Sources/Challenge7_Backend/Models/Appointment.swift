//
//  Apointment.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 19/08/25.
//

import Fluent
import Vapor
import Foundation

final class Appointment: Model, @unchecked Sendable {
    static let schema = "TB_appointments"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "mentor_id")
    var mentor: User
    
    @Field(key: "student_id")
    var student: User
    
    @Field(key: "appointmentPlace")
    var appointmentPlace: String
    
    @Enum(key: "appointmentCategory")
    var appointmentCategory: UserPath
    
    @Enum(key: "appointmentType")
    var appointmentType: AppointmentType
    
    @Boolean(key: "isScheduled")
    var isScheduled: Bool
    
    @Boolean(key: "callStudent")
    var callStudent: Bool
    
    @Boolean(key: "isDone")
    var isDone: Bool
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    
    init() { }
    
    init(id: UUID? = nil, mentor: User, student: User, appointmentPlace: String, appointmentCategory: UserPath, appointmentType: AppointmentType, isScheduled: Bool, callStudent: Bool, isDone: Bool, createdAt: Date) {
        self.id = id
        self.mentor = mentor
        self.student = student
        self.appointmentPlace = appointmentPlace
        self.appointmentCategory = appointmentCategory
        self.isScheduled = false
        self.callStudent = false
        self.isDone = false
        self.createdAt = Date.now
    }
    
    
    func toDTO() -> AppointmentDTO {
        .init (
            id: self.id,
            mentor: self.$mentor.value,
            student: self.$student.value,
            appointmentPlace: self.$appointmentPlace.value,
            appointmentCategory: self.$appointmentCategory.value,
            appointmentType: self.$appointmentType.value,
            isScheduled: self.$isScheduled.value,
            callStudent: self.$callStudent.value,
            isDone: self.$isDone.value,
            createdAt: self.$createdAt.value ?? Date.now
        )
    }
    
    
}
