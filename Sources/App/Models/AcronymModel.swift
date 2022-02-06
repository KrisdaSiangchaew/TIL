//
//  File.swift
//  
//
//  Created by Krisda on 5/2/2565 BE.
//

import Vapor
import Fluent

final class AcronymModel: Model {
    static let schema: String = "acronyms"
    
    struct FieldKeys {
        struct v1 {
            static var short: FieldKey { "short" }
            static var long: FieldKey { "long" }
            static var userID: FieldKey { "user_ID" }
        }
    }
    
    @ID var id: UUID?
    @Field(key: FieldKeys.v1.short) var short: String
    @Field(key: FieldKeys.v1.long) var long: String
    @Parent(key: FieldKeys.v1.userID) var user: UserModel
    @Siblings(through: AcronymCategoryPivotModel.self, from: \.$acronym, to: \.$category) var categories: [CategoryModel]
    
    init() { }
    
    init(id: UUID? = nil, short: String, long: String, userID: UserModel.IDValue) {
        self.id = id
        self.short = short
        self.long = long
        self.$user.id = userID
    }
}

extension AcronymModel: Content { }
