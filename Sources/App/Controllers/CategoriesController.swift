//
//  File.swift
//  
//
//  Created by Krisda on 6/2/2565 BE.
//

import Vapor

struct CategoriesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categoriesRoutes = routes.grouped("api", "categories")
        
        categoriesRoutes.post(use: createHandler)
        categoriesRoutes.get(use: getAllHandler)
        categoriesRoutes.get(":id", use: getHandler)
    }
    
    func createHandler(_ req: Request) async throws -> CategoryModel {
        let newCategory = try req.content.decode(CategoryModel.self)
        try await newCategory.save(on: req.db)
        return newCategory
    }
    
    func getAllHandler(_ req: Request) async throws -> [CategoryModel] {
        try await CategoryModel.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) async throws -> CategoryModel {
        guard let category = try await CategoryModel.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return category
    }
}
