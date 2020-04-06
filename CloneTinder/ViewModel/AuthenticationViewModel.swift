//
//  AuthenticationViewModel.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 3.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import Foundation

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var fullname: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false
    }
    
    
}
