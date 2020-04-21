//
//  UserSession.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 24.01.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import Foundation
import UIKit

//Homework for lesson 1 "Клиент-серверные iOS-приложения"
class UserSession {
    static let shared = UserSession()
    private init() { }
    
    var token = ""
    var userId = ""
}
