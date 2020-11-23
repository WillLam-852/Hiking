//
//  GlobalVariables.swift
//  Hiking
//
//  Created by Will Lam on 4/11/2020.
//

import UIKit
import MapKit

var firstLaunchApp = true      // Boolean value for first launching the app

enum MapLocationType {
    case toilet, campsite, viewingPoint, busStop, pier, beach, sittingOutArea, pavilion, selfDefined
}

class MapPoint {
    var name: String
    var type: MapLocationType
    var coordinate: CLLocationCoordinate2D
    var orderNumber: Int?
    
    init(name n: String, type t: MapLocationType, coordinate c: CLLocationCoordinate2D, orderNumber o: Int?) {
        self.name = n
        self.type = t
        self.coordinate = c
        self.orderNumber = o
    }
}

class Route {
    var name: String
    var description: String
    var distance: Double
    var expectedTime: Double
    var peak: Double
    var difficulty: Int
    var bookmarked: Int
    var district: [String]
    var startPoint: CLLocationCoordinate2D
    var endPoint: CLLocationCoordinate2D
    var midwayPoints: [MapPoint]
    
    init(name n: String, description des: String, distance d: Double, expectedTime et: Double, peak p: Double, difficulty diff: Int, bookmarked b: Int, district: [String], startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, midwayPoints: [MapPoint]) {
        self.name = n
        self.description = des
        self.distance = d
        self.expectedTime = et
        self.peak = p
        self.difficulty = diff
        self.bookmarked = b
        self.district = district
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.midwayPoints = midwayPoints
    }
}

class HikeRecord {
    var routeReference: Route
    var recordedRouteName: String
    var recordedDistance: Double
    var recordedTime: Double
    var recordedAveragePace: Double
    var recordedAverageBPM: Double
    var recordedPeak: Double
    
    init(routeReference r: Route, recordedRouteName n: String, recordedDistance d: Double, recordedTime t: Double, recordedAveragePace ap: Double, recordedAverageBPM bpm: Double, recordedPeak e: Double) {
        self.routeReference = r
        self.recordedRouteName = n
        self.recordedDistance = d
        self.recordedTime = t
        self.recordedAveragePace = ap
        self.recordedAverageBPM = bpm
        self.recordedPeak = e
    }
}

class User {
    var userName: String
    var userGender: Bool    // True for Male, False for Female
    var userBirthday: Date?
    var userPhoneNumber: String?
    var userEmail: String?
    var userProfilePicture: UIImage?
    var userHikeRecord: [HikeRecord]
    var userFriends: User?
    
    init(name n: String, gender g: Bool, birthday b: Date?, phoneNumber p: String?, email e: String?, profilePicture pic: UIImage?, hikeRecord hr: [HikeRecord], friends f: User?) {
        self.userName = n
        self.userGender = g
        self.userBirthday = b
        self.userPhoneNumber = p
        self.userEmail = e
        self.userProfilePicture = pic
        self.userHikeRecord = hr
        self.userFriends = f
    }
}


// User Information for Testing
let userA: User = User(name: "April", gender: false, birthday: nil, phoneNumber: "11111111", email: "april@gmail.com", profilePicture: nil, hikeRecord: [], friends: nil)
let userB: User = User(name: "Bob", gender: true, birthday: nil, phoneNumber: "22222222", email: "bobbob@ymail.com", profilePicture: nil, hikeRecord: [], friends: nil)
let userC: User = User(name: "Cathy", gender: false, birthday: nil, phoneNumber: "33333333", email: "cathy@gmail.com", profilePicture: nil, hikeRecord: [], friends: nil)
var userList: [User] = [userA, userB, userC]

// Route Information for Testing
let routeA: Route = Route(name: "東涌至大澳", description: "這條路徑是由東涌至大澳", distance: 14.9, expectedTime: 5.0, peak: 345, difficulty: 3, bookmarked: 405, district: ["離島區"], startPoint: CLLocationCoordinate2D(latitude: 22.2889, longitude: 113.9408), endPoint: CLLocationCoordinate2D(latitude: 22.2528, longitude: 113.8531), midwayPoints: [])
let routeB: Route = Route(name: "獅子山、望夫石", description: "這條路徑經過獅子山、望夫石", distance: 10.5, expectedTime: 4.5, peak: 513, difficulty: 4, bookmarked: 1283, district: ["沙田區", "黃大仙區"], startPoint: CLLocationCoordinate2D(latitude: 22.3434, longitude: 114.1879), endPoint: CLLocationCoordinate2D(latitude: 22.3641, longitude: 114.1811), midwayPoints: [MapPoint(name: "望夫石", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.3595, longitude: 114.1798), orderNumber: 0), MapPoint(name: "獅子山頂", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.3522, longitude: 114.1851), orderNumber: 1)])
let routeC: Route = Route(name: "山頂至薄扶林水塘", description: "這條路徑是由山頂至薄扶林水塘", distance: 8.5, expectedTime: 2.5, peak: 210, difficulty: 1, bookmarked: 558, district: ["中西區"], startPoint: CLLocationCoordinate2D(latitude: 22.2713, longitude: 114.1496), endPoint: CLLocationCoordinate2D(latitude: 22.2629, longitude: 114.1354), midwayPoints: [])
let routeD: Route = Route(name: "新娘潭自然教育徑", description: "圍繞新娘潭瀑布走一圈", distance: 0.7, expectedTime: 1.0, peak: 55.7, difficulty: 1, bookmarked: 4829, district: ["大埔區"], startPoint: CLLocationCoordinate2D(latitude: 22.5023, longitude: 114.2383), endPoint: CLLocationCoordinate2D(latitude: 22.5064, longitude: 114.2416), midwayPoints: [])
var defaultRouteList: [Route] = [routeA, routeB, routeC, routeD]
