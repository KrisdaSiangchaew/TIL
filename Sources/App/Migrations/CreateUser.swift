//
//  File.swift
//  
//
//  Created by Krisda on 6/2/2565 BE.
//

import Foundation
import FluentKit

enum CreateUser {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(UserModel.schema)
                .id()
                .field(UserModel.FieldKeys.v1.name, .string, .required)
                .field(UserModel.FieldKeys.v1.username, .string, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(UserModel.schema).delete()
        }
    }
}
