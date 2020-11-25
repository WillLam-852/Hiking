//
//  RecordDocument.swift
//  Hiking
//
//  Created by Will Lam on 24/11/2020.
//


import UIKit

class RoutesDocument: UIDocument {
    var routes: [Route] = Array()
    
    override func contents(forType typeName: String) throws -> Any {
        let encoder = JSONEncoder()
        let data = try encoder.encode(routes)
        if let s = String(data:data, encoding:.utf8){
            let len=s.lengthOfBytes(using: .utf8)
            return NSData(bytes:s, length:len)
        }
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typename: String?) throws {
        if let dataContent=contents as? NSData{
            if (NSString(bytes: dataContent.bytes, length: dataContent.count, encoding: String.Encoding.utf8.rawValue) as String?) != nil {
                let decoder=JSONDecoder()
                routes=try decoder.decode([Route].self,from:dataContent as Data)
            }
        }
    }
}



class HikeRecordsDocument: UIDocument {
    var hikeRecords: [HikeRecord] = Array()
    
    override func contents(forType typeName: String) throws -> Any {
        let encoder = JSONEncoder()
        let data = try encoder.encode(hikeRecords)
        if let s = String(data:data, encoding:.utf8){
            let len=s.lengthOfBytes(using: .utf8)
            return NSData(bytes:s, length:len)
        }
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typename: String?) throws {
        if let dataContent=contents as? NSData{
            if (NSString(bytes: dataContent.bytes, length: dataContent.count, encoding: String.Encoding.utf8.rawValue) as String?) != nil {
                let decoder=JSONDecoder()
                hikeRecords=try decoder.decode([HikeRecord].self,from:dataContent as Data)
            }
        }
    }
}



class UsersDocument: UIDocument {
    var users: [User] = Array()
    
    override func contents(forType typeName: String) throws -> Any {
        let encoder = JSONEncoder()
        let data = try encoder.encode(users)
        if let s = String(data:data, encoding:.utf8){
            let len=s.lengthOfBytes(using: .utf8)
            return NSData(bytes:s, length:len)
        }
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typename: String?) throws {
        if let dataContent=contents as? NSData{
            if (NSString(bytes: dataContent.bytes, length: dataContent.count, encoding: String.Encoding.utf8.rawValue) as String?) != nil {
                let decoder=JSONDecoder()
                users=try decoder.decode([User].self,from:dataContent as Data)
            }
        }
    }
}
