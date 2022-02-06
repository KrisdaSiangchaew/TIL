//
//  File.swift
//  
//
//  Created by Krisda on 6/2/2565 BE.
//

import Fluent

enum CreateAcronymCategoryPivot {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(AcronymCategoryPivotModel.schema)
                .id()
                .field(AcronymCategoryPivotModel.FieldKeys.v1.acronymID, .uuid, .required, .references(AcronymModel.schema, "id", onDelete: .cascade))
                .field(AcronymCategoryPivotModel.FieldKeys.v1.categoryID, .uuid, .required, .references(CategoryModel.schema, "id", onDelete: .cascade))
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(AcronymCategoryPivotModel.schema).delete()
        }
    }
}
