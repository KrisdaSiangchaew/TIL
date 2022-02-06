//
//  File.swift
//  
//
//  Created by Krisda on 6/2/2565 BE.
//

import Fluent
import Vapor

struct AcronymsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let acronymsRoutes = routes.grouped("api", "acronyms")
        
        acronymsRoutes.post(use: createHandler)
        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.get(":id", use: getHandler)
        acronymsRoutes.put(":id", use: updateHandler)
        acronymsRoutes.delete(":id", use: deleteHandler)
        acronymsRoutes.get("search", use: searchHandler)
        acronymsRoutes.get("first", use: getFirstHandler)
        acronymsRoutes.get("sorted", use: sortedHandler)
        acronymsRoutes.get(":id", "user", use: getUserHandler)
    }
    
    func createHandler(_ req: Request) async throws -> AcronymModel {
        let data = try req.content.decode(CreateAcronymData.self)
        let acronym = AcronymModel(short: data.short, long: data.long, userID: data.userID)
        try await acronym.save(on: req.db)
        return acronym
    }
    
    func getAllHandler(_ req: Request) async throws -> [AcronymModel] {
        let acronyms = try await AcronymModel.query(on: req.db).all()
        return acronyms
    }
    
    func getHandler(_ req: Request) async throws -> AcronymModel {
        guard let result = try await AcronymModel.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        return result
    }
    
    func updateHandler(_ req: Request) async throws -> AcronymModel {
        guard let originalAcronym = try await AcronymModel.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        let updatedAcronym = try req.content.decode(CreateAcronymData.self)
        originalAcronym.short = updatedAcronym.short
        originalAcronym.long = updatedAcronym.long
        originalAcronym.$user.id = updatedAcronym.userID
        try await originalAcronym.save(on: req.db)
        return originalAcronym
    }
    
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        guard let acronym = try await AcronymModel.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        try await acronym.delete(on: req.db)
        return .noContent
    }
    
    func searchHandler(_ req: Request) async throws -> [AcronymModel] {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return try await AcronymModel.query(on: req.db).group(.or) { or in
            or.filter(\.$short == searchTerm)
            or.filter(\.$long == searchTerm)
        }.all()
    }
    
    func getFirstHandler(_ req: Request) async throws -> AcronymModel {
        guard let result = try await AcronymModel.query(on: req.db).first() else {
            throw Abort(.notFound)
        }
        return result
    }
    
    func sortedHandler(_ req: Request) async throws -> [AcronymModel] {
        try await AcronymModel.query(on: req.db).sort(\.$short, .ascending).all()
    }
    
    func getUserHandler(_ req: Request) async throws -> UserModel {
        guard let acronym = try await AcronymModel.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        return try await acronym.$user.get(on: req.db)
    }
}

struct CreateAcronymData: Content {
    let short: String
    let long: String
    let userID: UUID
}
