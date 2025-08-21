//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 21/08/25.
//

import Foundation

///Enumerates different types (permissions) of users
enum UserRole: String, Codable {
    case adm
    case mentor
    case student
}
