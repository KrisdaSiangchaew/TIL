//
//  File.swift
//  
//
//  Created by Krisda on 6/2/2565 BE.
//

import Fluent
import Vapor

final class UserModel: Model {
    static let schema: String = "users"
    
    struct FieldKeys {
        struct v1 {
            static var name: FieldKey { "name" }
            static var username: FieldKey { "username" }
        }
    }
    
    @ID var id: UUID?
    @Field(key: FieldKeys.v1.name) var name: String
    @Field(key: FieldKeys.v1.username) var username: String
    @Children(for: \.$user) var acronyms: [AcronymModel]
    
    init() { }
    
    init(id: UUID? = nil, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
}

extension UserModel: Content { }
