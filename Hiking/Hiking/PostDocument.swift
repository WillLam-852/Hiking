//
//  PostDocument.swift
//  Hiking
//
//  Created by Edwin on 22/11/2020.
//

import UIKit

class Post: Codable{
    var writer: String = ""
    var title:String = ""
    var content: String = ""
    var date: Date

    init(writer w:String, title t:String, content c:String, date d:Date){
        writer = w
        title = t
        content = c
        date = d
    }
}

class PostDocument: UIDocument {
    var posts:[Post] = Array()
    
    override func contents(forType typeName: String) throws -> Any {
        let encoder = JSONEncoder()
        let data = try encoder.encode(posts)
        if let s = String(data:data, encoding:.utf8){
            let len=s.lengthOfBytes(using: .utf8)
            return NSData(bytes:s, length:len)
        }
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typename: String?) throws {
        if let dataContent=contents as? NSData{
            if let s=NSString(bytes: dataContent.bytes, length: dataContent.count, encoding: String.Encoding.utf8.rawValue) as String?{
                let decoder=JSONDecoder()
                posts=try decoder.decode([Post].self,from:dataContent as Data)
            }
        }
    }
}
