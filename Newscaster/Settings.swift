//
//  Settings.swift
//  Newscaster
//
//  Created by Owen LaRosa on 4/16/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Foundation

class Settings {
    
    private var userDefaults = NSUserDefaults.standardUserDefaults()
    
    private struct Defaults {
        static let voice = "en-GB"
        static let rate: Float = 0.5
        static let pitch: Float = 1.0
    }
    
    private struct Keys {
        static let voice = "voice"
        static let rate = "rate"
        static let pitch = "pitch"
    }
    
    var voice: String {
        get {
            return userDefaults.stringForKey(Keys.voice) ?? Defaults.voice
        }
        set (newVoice) {
            userDefaults.setObject(newVoice, forKey: Keys.voice)
        }
    }
    
    var rate: Float {
        get {
            let rateValue = userDefaults.floatForKey(Keys.rate)
            if rateValue > 0 {
                return rateValue
            }
            return Defaults.rate
        }
        set (newRate) {
            userDefaults.setFloat(newRate, forKey: Keys.rate)
        }
    }
    
    var pitch: Float {
        get {
            let pitchValue = userDefaults.floatForKey(Keys.pitch)
            if pitchValue > 0 {
                return pitchValue
            }
            return Defaults.pitch
        }
        set (newPitch) {
            userDefaults.setFloat(newPitch, forKey: Keys.pitch)
        }
    }
    
    class func sharedInstance() -> Settings {
        
        struct Singleton {
            static var sharedInstance = Settings()
        }
        
        return Singleton.sharedInstance
    }
    
}
