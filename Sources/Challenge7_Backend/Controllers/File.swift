//
//  File.swift
//  Challenge7_Backend
//
//  Created by Dayô Araújo on 02/09/25.
//
import APNSCore
import APNS
import VaporAPNS
import Foundation

// Custom Codable Payload
struct Payload: Codable { }


//let payload = PKPushPayload()
let token = "70075697aa918ebddd64efb165f5b9cb92ce095f1c4c76d995b384c623a258bb"
let alert = APNSAlertNotification(
    alert: .init(
        title: .raw("titulo"),
        body: .raw("mensagem")
    ),
    expiration: .immediately,
    priority: .immediately,
    topic: "",
    payload: Payload(),
    sound: .default
)
