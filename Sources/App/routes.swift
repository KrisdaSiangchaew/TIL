import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.routes.get("hello") { req in
        "Hello, world!"
    }
    
    try app.register(collection: AcronymsController())
    try app.register(collection: UsersController())
    try app.register(collection: CategoriesController())
}
