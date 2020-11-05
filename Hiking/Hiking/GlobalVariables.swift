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
    
    init(name n: String, distance d: Double, expectedTime et: Double, peak p: Double, difficulty diff: Int, bookmarked b: Int, dist: String) {
        self.name = n
        self.distance = d
        self.expectedTime = et
        self.peak = p
        self.difficulty = diff
        self.bookmarked = b
        self.district = dist
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

var userList: [User] = []


// User Information for Testing
let userA: User = User(name: "April", gender: false, birthday: nil, phoneNumber: "11111111", email: "april@gmail.com", profilePicture: nil, hikeRecord: nil, friends: nil)
let userB: User = User(name: "Bob", gender: true, birthday: nil, phoneNumber: "22222222", email: "bobbob@ymail.com", profilePicture: nil, hikeRecord: nil, friends: nil)
let userC: User = User(name: "Cathy", gender: false, birthday: nil, phoneNumber: "33333333", email: "cathy@gmail.com", profilePicture: nil, hikeRecord: nil, friends: nil)
