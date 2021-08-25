//
//  HTTPCookieStorage+Extensions.swift
//  CookiesText
//
//  Created by griffin-stewie on 2021/08/25.
//  
//

import Foundation

public extension HTTPCookieStorage {

    /// Set cookis loaded from URL
    /// - Parameter url: where the cookies.txt locates
    func setCookies(from url: URL) throws {
        let cookies = try CookiesText.cookies(of: url)
        for cookie in cookies {
            setCookie(cookie)
        }
    }
}
