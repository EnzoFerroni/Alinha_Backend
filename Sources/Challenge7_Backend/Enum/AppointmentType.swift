//
//  File.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 19/08/25.
//

import Foundation

/// Enum representing the type of an appointment.
/// - Dúvida: Appointment for questions.
/// - Problema: Appointment for problems.
enum AppointmentType: String, Codable {
    case Dúvida, Problema
}
