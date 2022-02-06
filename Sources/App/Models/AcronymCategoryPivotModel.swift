//
//  File.swift
//  
//
//  Created by Krisda on 6/2/2565 BE.
//

import Fluent
import Vapor

final class AcronymCategoryPivotModel: Model {
    static let schema: String = "acronym-category-pivot"
    
    struct FieldKeys {
        struct v1 {
            static var acronymID: FieldKey { "acronym_ID" }
            static var categoryID: FieldKey { "category_ID" }
        }
    }
    
    @ID var id: UUID?
    @Parent(key: FieldKeys.v1.acronymID) var acronym: AcronymModel
    @Parent(key: FieldKeys.v1.categoryID) var category: CategoryModel
    
    init() { }
    
    init(id: UUID? = nil, acronym: AcronymModel, category: CategoryModel) throws {
        self.id = id
        self.$acronym.id = try acronym.requireID()
        self.$category.id = try category.requireID()
    }
}
