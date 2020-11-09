//
//  GlobalVariables.swift
//  Hiking
//
//  Created by Will Lam on 4/11/2020.
//

import UIKit

var firstLaunchApp = true      // Boolean value for first launching the app

class Route {
    var name: String
    var distance: Double
    var expectedTime: Double
    var peak: Double
    var difficulty: Int
    var bookmarked: Int
    var district: String
    
    init(name n: String, distance d: Double, expectedTime et: Double, peak p: Double, difficulty diff: Int, bookmarked b: Int, district: String) {
        self.name = n
        self.distance = d
        self.expectedTime = et
        self.peak = p
        self.difficulty = diff
        self.bookmarked = b
        self.district = district
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
    var userHikeRecord: HikeRecord?
    var userFriends: User?
    
    init(name n: String, gender g: Bool, birthday b: Date?, phoneNumber p: String?, email e: String?, profilePicture pic: UIImage?, hikeRecord hr: HikeRecord?, friends f: User?) {
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
let userA: User = User(name: "April", gender: false, birthday: nil, phoneNumber: "11111111", email: "april@gmail.com", profilePicture: nil, hikeRecord: nil, friends: nil)
let userB: User = User(name: "Bob", gender: true, birthday: nil, phoneNumber: "22222222", email: "bobbob@ymail.com", profilePicture: nil, hikeRecord: nil, friends: nil)
let userC: User = User(name: "Cathy", gender: false, birthday: nil, phoneNumber: "33333333", email: "cathy@gmail.com", profilePicture: nil, hikeRecord: nil, friends: nil)
var userList: [User] = [userA, userB, userC]

// Route Information for Testing
let routeA: Route = Route(name: "東涌至大澳", distance: 14.9, expectedTime: 5.0, peak: 345, difficulty: 3, bookmarked: 405, district: "離島區")
let routeB: Route = Route(name: "獅子山、望夫石", distance: 10.5, expectedTime: 4.5, peak: 513, difficulty: 4, bookmarked: 1283, district: "沙田區")
let routeC: Route = Route(name: "山頂至薄扶林", distance: 8.5, expectedTime: 2.5, peak: 210, difficulty: 1, bookmarked: 558, district: "中西區")
var routeList: [Route] = [routeA, routeB, routeC]
