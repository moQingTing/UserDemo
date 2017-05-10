import Vapor

import VaporPostgreSQL

let drop = Droplet()

//添加使用vaporPostgreSQL
drop.preparations.append(User.self)
do{
    try drop.addProvider(VaporPostgreSQL.Provider.self)
}catch{
    assertionFailure("添加VaporPostgreSQL provider错误: \(error)")
}

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

//查询数据库中所有用户
drop.get("users"){ req in
    let users = try User.all().makeNode()
    let usersDic = ["users":users]
    return try JSON(node: usersDic)
}

//根据id查询单个用户
drop.get("users",Int.self){ req,userID in
    guard let user = try User.find(userID) else{
        throw Abort.notFound
    }
    
    return try user.makeJSON()
}

//向数据库添加用户
drop.post("user") { req in
    var user = try User(node: req.json)
    try user.save()
    return try user.makeJSON()
}


//添加直接返回json的路由
//drop.get ("users"){ req in
//    
//    let users = [User(name:"Jay", email: "jay@vapor.com", password: "jay123"),
//                 User(name:"Marry", email: "marry@vapor.com", password: "marry123"),
//                 User(name:"Messi", email: "messi@vapor.com", password: "messi123")
//    ]
//    
//    
//    let usersNode = try users.makeNode()
//    let nodeDic = ["users": usersNode]
//    return try JSON(node: nodeDic)
//}

drop.resource("posts", PostController())

drop.run()
