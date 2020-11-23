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
    var orderNumber: Int
    
    init(name n: String, type t: MapLocationType, coordinate c: CLLocationCoordinate2D, orderNumber o: Int) {
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
    var recordedDate: Date
    var recordedTime: Double
    var recordedAveragePace: Double
    var recordedAverageBPM: Int
    var recordedPeak: Double
    
    init(routeReference r: Route, recordedRouteName n: String, recordedDistance d: Double, recordDate date: Date, recordedTime t: Double, recordedAveragePace ap: Double, recordedAverageBPM bpm: Int, recordedPeak e: Double) {
        self.routeReference = r
        self.recordedRouteName = n
        self.recordedDistance = d
        self.recordedDate = date
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


// Route Information for Testing
let routeA: Route = Route(name: "東涌至大澳", description: "這條路徑是由東涌至大澳", distance: 14.9, expectedTime: 5.0, peak: 345, difficulty: 3, bookmarked: 405, district: ["離島區"], startPoint: CLLocationCoordinate2D(latitude: 22.2889, longitude: 113.9408), endPoint: CLLocationCoordinate2D(latitude: 22.2528, longitude: 113.8531), midwayPoints: [])
let routeB: Route = Route(name: "獅子山、望夫石", description: "這條路徑經過獅子山、望夫石", distance: 10.5, expectedTime: 4.5, peak: 513, difficulty: 4, bookmarked: 1283, district: ["沙田區", "黃大仙區"], startPoint: CLLocationCoordinate2D(latitude: 22.3434, longitude: 114.1879), endPoint: CLLocationCoordinate2D(latitude: 22.3641, longitude: 114.1811), midwayPoints: [MapPoint(name: "望夫石", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.3595, longitude: 114.1798), orderNumber: 0), MapPoint(name: "獅子山頂", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.3522, longitude: 114.1851), orderNumber: 1)])
let routeC: Route = Route(name: "山頂至薄扶林水塘", description: "這條路徑是由山頂至薄扶林水塘", distance: 8.5, expectedTime: 2.5, peak: 210, difficulty: 1, bookmarked: 558, district: ["中西區"], startPoint: CLLocationCoordinate2D(latitude: 22.2713, longitude: 114.1496), endPoint: CLLocationCoordinate2D(latitude: 22.2629, longitude: 114.1354), midwayPoints: [])
let routeD: Route = Route(name: "新娘潭自然教育徑", description: "圍繞新娘潭瀑布走一圈", distance: 0.7, expectedTime: 1.0, peak: 55.7, difficulty: 1, bookmarked: 4829, district: ["大埔區"], startPoint: CLLocationCoordinate2D(latitude: 22.5023, longitude: 114.2383), endPoint: CLLocationCoordinate2D(latitude: 22.5064, longitude: 114.2416), midwayPoints: [])
let routeE: Route = Route(name: "麥理浩徑第一段", description: "麥理浩徑於1979年啟用，全長100公里，分十段。路段由西貢北潭涌出發，向東南方繞經萬宜水庫及東壩；然後向北，經過西灣山、大浪灣及鹹田灣；接著向西，經大浪坳、赤徑、北潭凹、牛耳石山、嶂上、雷打石、雞公山、馬鞍山、黃牛山、大老山、慈雲山、獅子山、筆架山及金山等；到達城門水塘後，轉而向北，經針山及草山，再轉向西經過全港最高的大帽山；最後走約22公里，經田夫仔、大欖涌水塘及其引水道，最後抵達屯門。", distance: 10.6, expectedTime: 3.0, peak: 133.4, difficulty: 2, bookmarked: 2842, district: ["西貢區"], startPoint: CLLocationCoordinate2D(latitude: 22.4000, longitude: 114.3239), endPoint: CLLocationCoordinate2D(latitude: 22.3719, longitude: 114.3732), midwayPoints: [MapPoint(name: "白臘營地", type: .campsite, coordinate: CLLocationCoordinate2D(latitude: 22.3594, longitude: 114.3646), orderNumber: 1)])
let routeF: Route = Route(name: "麥理浩徑第二段", description: "經過東壩、浪茄灣、戒毒中心", distance: 13.5, expectedTime: 5.0, peak: 316.3, difficulty: 3, bookmarked: 4294, district: ["西貢區"], startPoint: CLLocationCoordinate2D(latitude: 22.3719, longitude: 114.3732), endPoint: CLLocationCoordinate2D(latitude: 22.4216, longitude: 114.3323), midwayPoints: [MapPoint(name: "西灣山山頂", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.3869, longitude: 114.3778), orderNumber: 1), MapPoint(name: "吹筒坳", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.3909, longitude: 114.3655), orderNumber: 2), MapPoint(name: "鹹田灣營地", type: .campsite, coordinate: CLLocationCoordinate2D(latitude: 22.4087, longitude: 114.3741), orderNumber: 3), MapPoint(name: "赤徑口石灘", type: .beach, coordinate: CLLocationCoordinate2D(latitude: 22.4221, longitude: 114.3530), orderNumber: 4)])
let routeG: Route = Route(name: "麥理浩徑第三段", description: "麥理浩徑第三段是十段中最為難行兩段的其中之一，必須體力充足及裝備良好，尤以行山手杖及行山鞋最為重要，以應付某些因日久失修而引致崎嶇的路段。因此，對於初次行山的人，麥徑的第三段不太適合。", distance: 10.2, expectedTime: 4.0, peak: 414.4, difficulty: 4, bookmarked: 3129, district: ["西貢區"], startPoint: CLLocationCoordinate2D(latitude: 22.4207, longitude: 114.3319), endPoint: CLLocationCoordinate2D(latitude: 22.4050, longitude: 114.2791), midwayPoints: [MapPoint(name: "坳門", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.4285, longitude: 114.3074), orderNumber: 1), MapPoint(name: "雷打石", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.4148, longitude: 114.3028), orderNumber: 2)])
let routeH: Route = Route(name: "港島徑第八段", description: "這路段覆蓋了龍脊及其郊遊徑的全部，在郊野公園管理局的發展及維修下，這條郊遊山道大部份路段亦變得十分好走。", distance: 8.5, expectedTime: 3.0, peak: 284.0, difficulty: 3, bookmarked: 8734, district: ["南區"], startPoint: CLLocationCoordinate2D(latitude: 22.2270, longitude: 114.2397), endPoint: CLLocationCoordinate2D(latitude: 22.2470, longitude: 114.2451), midwayPoints: [MapPoint(name: "", type: .busStop, coordinate: CLLocationCoordinate2D(latitude: 22.2573, longitude: 114.2366), orderNumber: 1)])
let routeI: Route = Route(name: "元荃古道", description: "元荃古道是當局依照昔日居民往來元朗及荃灣兩地的路線而修建的行山徑，「元」指元朗，而「荃」則指荃灣。這條古道對當時元朗十八鄉的農民來說，是經這路把他們的農作收成運到荃灣的市場販賣，尤其是吉慶橋，是當時居民的必經之橋。", distance: 15.0, expectedTime: 5.0, peak: 414.0, difficulty: 3, bookmarked: 5893, district: ["荃灣區", "屯門區"], startPoint: CLLocationCoordinate2D(latitude: 22.3778, longitude: 114.0931), endPoint: CLLocationCoordinate2D(latitude: 22.4131, longitude: 114.0357), midwayPoints: [])
let routeJ: Route = Route(name: "衛奕信徑第九段", description: "第九段由九龍坑山山頂出發，經鶴藪水塘、屏風山至八仙嶺，最後以仙姑峰為終點。鶴藪水塘靜美如畫，幽谷翠坡環抱，令人徘徊不去。在分岔口緩上小徑便正式開展八仙嶺山峰縱走之旅，可說是整條衛奕信徑最難走的路段之一。屏風山南面峭壁恍如一道將新界東北及大埔的屏風，走在山脊之上，視野開闊，能360度極目新界東北一帶。八仙嶺以道教八仙為名，由西至東，各山峰依次名為純陽、鍾離、果老、拐李、曹舅、采和、湘子及仙姑峰。各山峰均設有特色指示牌，既可打卡又可打氣。", distance: 10.6, expectedTime: 4.5, peak: 622.4, difficulty: 4, bookmarked: 4392, district: ["大埔區"], startPoint: CLLocationCoordinate2D(latitude: 22.4758, longitude: 114.1705), endPoint: CLLocationCoordinate2D(latitude: 22.4850, longitude: 114.2340), midwayPoints: [MapPoint(name: "石坳山", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.4934, longitude: 114.1779), orderNumber: 1), MapPoint(name: "屏風山", type: .viewingPoint, coordinate: CLLocationCoordinate2D(latitude: 22.4931, longitude: 114.1963), orderNumber: 2)])
var defaultRouteList: [Route] = [routeA, routeB, routeC, routeD, routeE, routeF, routeG, routeH, routeI, routeJ]

// User Information for Testing
let userA_hikeRecords = [HikeRecord(routeReference: routeA, recordedRouteName: "東涌至大澳", recordedDistance: 14.9, recordDate: Date(), recordedTime: 4.5, recordedAveragePace: 2.8, recordedAverageBPM: 118, recordedPeak: 345.0),
                         HikeRecord(routeReference: routeB, recordedRouteName: "獅子山、望夫石", recordedDistance: 10.5, recordDate: Date(), recordedTime: 4.5, recordedAveragePace: 2.9, recordedAverageBPM: 122, recordedPeak: 513.0),
                         HikeRecord(routeReference: routeC, recordedRouteName: "山頂至薄扶林水塘", recordedDistance: 8.5, recordDate: Date(), recordedTime: 2.5, recordedAveragePace: 2.8, recordedAverageBPM: 118, recordedPeak: 210),
                         HikeRecord(routeReference: routeD, recordedRouteName: "新娘潭自然教育徑", recordedDistance: 0.8, recordDate: Date(), recordedTime: 1.5, recordedAveragePace: 2.8, recordedAverageBPM: 118, recordedPeak: 59.0),
                         HikeRecord(routeReference: routeE, recordedRouteName: "麥理浩徑第一段", recordedDistance: 10.6, recordDate: Date(), recordedTime: 3.5, recordedAveragePace: 2.8, recordedAverageBPM: 118, recordedPeak: 133.5),
                         HikeRecord(routeReference: routeF, recordedRouteName: "麥理浩徑第二段", recordedDistance: 14.9, recordDate: Date(), recordedTime: 4.5, recordedAveragePace: 2.8, recordedAverageBPM: 118, recordedPeak: 345),
                         HikeRecord(routeReference: routeG, recordedRouteName: "麥理浩徑第三段", recordedDistance: 14.9, recordDate: Date(), recordedTime: 4.5, recordedAveragePace: 2.8, recordedAverageBPM: 118, recordedPeak: 345),
                         HikeRecord(routeReference: routeH, recordedRouteName: "港島徑第八段", recordedDistance: 14.9, recordDate: Date(), recordedTime: 4.5, recordedAveragePace: 2.8, recordedAverageBPM: 118, recordedPeak: 345),
                         HikeRecord(routeReference: routeI, recordedRouteName: "元荃古道", recordedDistance: 14.9, recordDate: Date(), recordedTime: 4.5, recordedAveragePace: 2.8, recordedAverageBPM: 118, recordedPeak: 345),
                         HikeRecord(routeReference: routeJ, recordedRouteName: "衛奕信徑第九段", recordedDistance: 14.9, recordDate: Date(), recordedTime: 4.5, recordedAveragePace: 2.8, recordedAverageBPM: 118, recordedPeak: 345)]
let userA: User = User(name: "April", gender: false, birthday: nil, phoneNumber: "11111111", email: "april@gmail.com", profilePicture: nil, hikeRecord: userA_hikeRecords, friends: nil)
let userB: User = User(name: "Bob", gender: true, birthday: nil, phoneNumber: "22222222", email: "bobbob@ymail.com", profilePicture: nil, hikeRecord: [], friends: nil)
let userC: User = User(name: "Cathy", gender: false, birthday: nil, phoneNumber: "33333333", email: "cathy@gmail.com", profilePicture: nil, hikeRecord: [], friends: nil)
var userList: [User] = [userA, userB, userC]

let currentUser = userA
