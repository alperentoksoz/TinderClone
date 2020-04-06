//
//  SettingsViewModel.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 4.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit

enum SettingsSections: Int, CaseIterable {
    case name
    case proffession
    case age
    case bio
    case ageRange
    
    var description: String {
        switch self {
        case .name: return "Name"
        case .proffession: return "Profession"
        case .age: return "Age"
        case .bio: return "Bio"
        case .ageRange: return "Seeking Age Range"
        }
    }
}



struct SettingsViewModel {
    
    private var user: User
    let section: SettingsSections
    
    let placeHolderText: String
    var value: String?
    
    var shouldHideInputField: Bool {
        return section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        return section != .ageRange
    }
    
    var minAgeSliderValue: Float {
        return Float(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekingAge)
    }
    
    func minAgeLabelText(forValue value: Float) -> String {
        return "Min: \(Int(value))"
    }
    
    func maxAgeLabelText(forValue value: Float) -> String {
        return "Max: \(Int(value))"
    }
    
    init(user: User, section: SettingsSections) {
        self.user = user
        self.section = section
        placeHolderText = "Enter \(section.description.lowercased())"
        
        switch section {
        case .name:
            value = user.name
        case .proffession:
            value = user.profession
        case .age:
            value = "\(user.age)"
        case .bio:
            value = user.bio
        case .ageRange:
            break
        }
    }
    
}
