//
//  AsyncOperation.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 11.05.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

import UIKit
import Alamofire

class GetDataOperation: AsyncOperation {
    
    private var request: DataRequest
    var data: Data?
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
            
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
}

