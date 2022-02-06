//
//  File.swift
//  
//
//  Created by Krisda on 6/2/2565 BE.
//

import Fluent
import Vapor

enum CreateCategory {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(CategoryModel.schema)
                .id()
                .field(CategoryModel.FieldKeys.v1.name, .string, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(CategoryModel.schema).delete()
        }
    }
}
