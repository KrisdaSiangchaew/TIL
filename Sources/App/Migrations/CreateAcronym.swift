//
//  File.swift
//  
//
//  Created by Krisda on 5/2/2565 BE.
//

import Fluent

enum CreateAcronym {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(AcronymModel.schema)
                .id()
                .field(AcronymModel.FieldKeys.v1.short, .string, .required)
                .field(AcronymModel.FieldKeys.v1.long, .string, .required)
                .field(AcronymModel.FieldKeys.v1.userID, .uuid, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(AcronymModel.schema).delete()
        }
    }
}

