//
//  File.swift
//  
//
//  Created by Krisda on 6/2/2565 BE.
//

import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        
        usersRoutes.post(use: createHandler)
        usersRoutes.get(use: getAllHandler)
        usersRoutes.get(":id", use: getHandler)
        usersRoutes.get(":id", "acronyms", use: getAcronymsHandler)
    }
    
    func createHandler(_ req: Request) async throws -> UserModel {
        let newUser = try req.content.decode(UserModel.self)
        try await newUser.save(on: req.db)
        return newUser
    }
    
    func getAllHandler(_ req: Request) async throws -> [UserModel] {
        return try await UserModel.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) async throws -> UserModel {
        guard let user = try await UserModel.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }
    
    func getAcronymsHandler(_ req: Request) async throws -> [AcronymModel] {
        guard let user = try await UserModel.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        return try await user.$acronyms.get(on: req.db)
    }
}
