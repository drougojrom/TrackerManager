//
//  TrackerManager.swift
//  visitgo_ios
//
//  Created by Roman Ustiantcev on 12/7/18.
//  Copyright © 2018 Roman Ustiantcev. All rights reserved.
//

import CoreMotion

public protocol TrackerProtocol {
    func checkIfActivityEnabled() -> Bool
    func checkIfStepsCountEnabled() -> Bool
    func countSteps(completionHandler: @escaping(NSNumber?)-> Void)
    func startTrackingActivityType(completionHandler: @escaping(CMMotionActivity?)->Void)
    func distance(completionHandler: @escaping(NSNumber?)-> Void)
    func currentPace(completionHandler: @escaping(NSNumber?)-> Void)
    func ascendingFloors(completionHandler: @escaping(NSNumber?)-> Void)
    func descendingFloors(completionHandler: @escaping(NSNumber?)-> Void)
}

final class TrackerManager: NSObject, TrackerProtocol {
    
    public static var core = TrackerManager()
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    func checkIfActivityEnabled() -> Bool {
        return CMMotionActivityManager.isActivityAvailable()
    }
    
    func checkIfStepsCountEnabled() -> Bool {
        return CMPedometer.isStepCountingAvailable()
    }
    
    func stopPedometr() {
        pedometer.stopUpdates()
    }
    
    func stopActivityManager() {
        activityManager.stopActivityUpdates()
    }
    
    func countSteps(completionHandler: @escaping(NSNumber?)-> Void) {
        pedometer.startUpdates(from: Date()) { (data, error) in
            DispatchQueue.main.async {
                completionHandler(data?.numberOfSteps)
            }
        }
    }
    
    func startTrackingActivityType(completionHandler: @escaping(CMMotionActivity?)->Void) {
        activityManager.startActivityUpdates(to: OperationQueue.main) { (activity) in
            DispatchQueue.main.async {
                completionHandler(activity)
            }
        }
    }
    
    func distance(completionHandler: @escaping(NSNumber?)-> Void) {
        pedometer.startUpdates(from: Date()) { (data, error) in
            DispatchQueue.main.async {
                completionHandler(data?.distance)
            }
        }
    }
    
    func currentPace(completionHandler: @escaping(NSNumber?)-> Void) {
        pedometer.startUpdates(from: Date()) { (data, error) in
            DispatchQueue.main.async {
                completionHandler(data?.currentPace)
            }
        }
    }
    
    func ascendingFloors(completionHandler: @escaping(NSNumber?)-> Void) {
        pedometer.startUpdates(from: Date()) { (data, error) in
            DispatchQueue.main.async {
                completionHandler(data?.floorsAscended)
            }
        }
    }
    
    func descendingFloors(completionHandler: @escaping(NSNumber?)-> Void) {
        pedometer.startUpdates(from: Date()) { (data, error) in
            DispatchQueue.main.async {
                completionHandler(data?.floorsDescended)
            }
        }
    }
}
