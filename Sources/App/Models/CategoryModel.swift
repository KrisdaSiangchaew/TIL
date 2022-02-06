//
//  File.swift
//  
//
//  Created by Krisda on 6/2/2565 BE.
//

import Fluent
import Vapor

final class CategoryModel: Model {
    static let schema: String = "categories"
    
    struct FieldKeys {
        struct v1 {
            static var name: FieldKey { "name" }
        }
    }
    
    @ID var id: UUID?
    @Field(key: FieldKeys.v1.name) var name: String
    
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension CategoryModel: Content { }
