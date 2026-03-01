//
//  InfoRouter.swift
//  Racoon-client
//
//  Created by dark type on 26.02.2026.
//
import Foundation


public enum InfoRouter: APIRouter {
    
    case login(email: String, password: String)
    case refresh(refreshToken: String)
    case logout(accessToken: String)

    case profile
    case editProfile(email: String, username: String)

    case getAllUsers
    case createUser(username: String, email: String?, password: String)
    case register(username: String, email: String?, password: String)
    case createEmployee(username: String, email: String?, password: String)
    case banUser(id: UUID)

    public var endpoint: Endpoint {
        switch self {

        // MARK: - Auth
        case .login(let email, let password):
            return Endpoint(
                service: .info,
                method: .POST,
                path: "/api/auth/login",
                body: .json(LoginDto(email: email, password: password))
            )

        case .refresh(let refreshToken):
            return Endpoint(
                service: .info,
                method: .POST,
                path: "/api/auth/refresh",
                body: .json(RefreshRequestDto(refreshToken: refreshToken))
            )

        case .logout(let accessToken):
            return Endpoint(
              service: .info,
              method: .POST,
              path: "/api/auth/logout",
              headers: ["Authorization": "Bearer \(accessToken)"]
            )

        // MARK: - Profile
        case .profile:
            return Endpoint(service: .info, method: .GET, path: "/api/user/profile")

        case .editProfile(let email, let username):
            return Endpoint(
                service: .info,
                method: .PUT,
                path: "/api/user/profile",
                body: .json(EditProfileDto(email: email, username: username))
            )

        // MARK: - Employee: Users
        case .getAllUsers:
            return Endpoint(service: .info, method: .GET, path: "/api/user")

        case .createUser(let username, let email, let password):
            return Endpoint(
                service: .info,
                method: .POST,
                path: "/api/user",
                body: .json(RegisterUserDto(username: username, email: email, password: password))
            )

        case .register(let username, let email, let password):
            return Endpoint(
                service: .info,
                method: .POST,
                path: "/api/user/registration",
                body: .json(RegisterUserDto(username: username, email: email, password: password))
            )

        case .createEmployee(let username, let email, let password):
            return Endpoint(
                service: .info,
                method: .POST,
                path: "/api/employee",
                body: .json(RegisterUserDto(username: username, email: email, password: password))
            )

        case .banUser(let id):
            return Endpoint(
                service: .info,
                method: .PUT,
                path: "/api/user/\(id.uuidString)/ban"
            )
        }
    }
}
