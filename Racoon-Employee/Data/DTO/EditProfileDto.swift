//
//  EditProfileDto.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public struct EditProfileDto: Encodable, Sendable {
    public let email: String
    public let username: String
}