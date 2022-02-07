//
//  File.swift
//  
//
//  Created by Krisda on 7/2/2565 BE.
//

@testable import App
import XCTVapor

final class UserTests: XCTestCase {
    func testUsersCanBeRetrievedFromAPI() async throws {
        let expectedName = "Alice"
        let expectedUsername = "alice"
        
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        try await app.autoRevert()
        try await app.autoMigrate()
        
        let user = UserModel(name: expectedName, username: expectedUsername)
        try await user.save(on: app.db)
        
        let user2 = UserModel(name: "Kris", username: "kris")
        try await user2.save(on: app.db)
        
        try app.test(.GET, "/api/users/", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            
            let users = try response.content.decode([UserModel].self)
            
            XCTAssertEqual(users.count, 2)
            XCTAssertEqual(users[0].name, expectedName)
            XCTAssertEqual(users[0].username, expectedUsername)
            XCTAssertEqual(users[0].id, user.id)
        })
    }
}
