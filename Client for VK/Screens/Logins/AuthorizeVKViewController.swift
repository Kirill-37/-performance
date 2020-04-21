//
//  AuthorizeVKViewController.swift
//  Client for VK
//
//  Created by Кирилл Харузин on 15.03.2020.
//  Copyright © 2020 Кирилл Харузин. All rights reserved.
//

//MARK: HW2 Authorize vk.com
import WebKit
import UIKit
import Alamofire


class AuthorizeVKViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserSession.shared.token != "" {
                   performSegue(withIdentifier: "ShowTabBar", sender: AnyObject.self)
               }
    
       var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "oauth.vk.com"
                urlComponents.path = "/authorize"
                urlComponents.queryItems = [URLQueryItem(name: "client_id", value: "7384704"),
                                            URLQueryItem(name: "display", value: "mobile"),
                                            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                                            URLQueryItem(name: "scope", value: "users,friends,groups,photos"),
                                            URLQueryItem(name: "response_type", value: "token"),
                                            URLQueryItem(name: "v", value: "5.103")]
        
        let request = URLRequest(url: urlComponents.url!)
        webView.navigationDelegate = self
        webView.load(request)
            
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
           
           if UserSession.shared.token != "" {
               return true
           } else {
               print("Don't have token!")
               return false
           }
           
       }
    
    
}


extension AuthorizeVKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        UserSession.shared.token = params["access_token"]!
        print("TOKEN: \(UserSession.shared.token)")
        decisionHandler(.cancel)
        performSegue(withIdentifier: "ToTabBar", sender: AnyObject.self)
    }
}
