//
//  CookiesText.swift
//  CookiesText
//
//  Created by griffin-stewie on 2021/08/25.
//
//

import Foundation

/// Load HTTPCookie from cookies.txt
public enum CookiesText {

    /// Load array of HTTPCookie from URL
    /// - Parameter url: Where the cookies.txt locates
    /// - Returns: Array of HTTPCookie.
    public static func cookies(of url: URL) throws -> [HTTPCookie] {
        let string = try String(contentsOf: url, encoding: .utf8)
        return try cookies(from: string)
    }


    /// Load array of HTTPCookie from String
    /// - Parameter string: Contents of cookies.txt
    /// - Returns: Array of HTTPCookie.
    public static func cookies(from string: String) throws -> [HTTPCookie] {
        return try string.split(separator: lineSeparator).compactMap { line -> HTTPCookie? in
            guard !(line.isComment || line.isEmpty) else {
                return nil
            }

            return try parseLine(String(line))
        }
    }
}

/// Format Error
public enum CookiesTextError: Error {
    /// Occurs when line of cookies.txt does not contain 7 fields
    case invalidFieldsCount
}

private extension CookiesText {
    static func parseLine(_ line: String) throws -> HTTPCookie? {
        let components = line.split(separator: fieldSeparator)

        if components.count < fieldsCount {
            throw CookiesTextError.invalidFieldsCount
        }

        // https://developer.apple.com/documentation/foundation/httpcookie/1392969-ishttponly
        // Cookies can be marked as HTTP-only by a server (or by JavaScript code). Cookies marked as such must only be sent via HTTP Headers in HTTP requests for URLs that match both the path and domain of the respective cookies.
        let domain = components[.domain].trimHTTPOnlyPrefix() // just drop prefix. reasons above.
        let isSecure: Bool = components[.secure].toBool
        let expires: Date = Date(timeIntervalSince1970: TimeInterval(Double(components[.expires])!))

        let props: Dictionary<HTTPCookiePropertyKey, Any> = [
            .domain: domain,
            .path: components[.path],
            .secure: isSecure,
            .expires: expires,
            .name: components[.name],
            .value: components[.value],
        ]

        return HTTPCookie(properties: props)
    }
}

private extension CookiesText {
    static let lineSeparator: Character = "\n"
    static let fieldSeparator: Character = "\t"
    static let commentPrefix = "#"
    static let httpOnlyPrefix = "#HttpOnly_"
    static let fieldsCount: Int = 7
}

/// http://www.cookiecentral.com/faq/#3.5
fileprivate extension Int {
    /// The domain that created AND that can read the variable.
    static let domain = 0

    /// A TRUE/FALSE value indicating if all machines within a given domain can access the variable. This value is set automatically by the browser, depending on the value you set for domain.
    static let includesSubDomains = 1

    /// The path within the domain that the variable is valid for.
    static let path = 2

    /// A TRUE/FALSE value indicating if a secure connection with the domain is needed to access the variable.
    static let secure = 3

    /// The UNIX time that the variable will expire on. UNIX time is defined as the number of seconds since Jan 1, 1970 00:00:00 GMT.
    static let expires = 4

    /// The name of the variable.
    static let name = 5

    /// The value of the variable.
    static let value = 6
}

private extension StringProtocol {
    var toBool: Bool {
        self.lowercased() == "true"
    }

    func dropPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return String(self)
        }

        return String(dropFirst(prefix.count))
    }
}

private extension StringProtocol {
    func trimHTTPOnlyPrefix() -> String {
        dropPrefix(CookiesText.httpOnlyPrefix)
    }

    var isComment: Bool {
        hasPrefix(CookiesText.commentPrefix) && !hasPrefix(CookiesText.httpOnlyPrefix)
    }
}
