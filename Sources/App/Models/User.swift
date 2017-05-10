//
//  User.swift
//  UserDemo
//
//  Created by mqt on 2017/5/9.
//
//
import Vapor
import Fluent
import Foundation

final class User: Model {
    var id: Node?
    
    var name: String
    var email:String
    var password:String
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        email = try node.extract("email")
        password = try node.extract("password")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: ["id": id,
                               "name": name,
                               "email": email,
                               "password": password])
    }
}

extension User {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
//    public convenience init?(from string: String) throws {
//        self.init(content: string)
//    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("users") { user in
            user.id()
            user.string("name")
            user.string("email")
            user.string("password")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")

    }
}
