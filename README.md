# CookiesText ![badge-platforms][] ![badge-languages][] [![badge-release]](https://github.com/griffin-stewie/CookiesText/releases) [![badge-license]](https://github.com/griffin-stewie/CookiesText/blob/master/LICENSE)

It loads array of HTTPCookie from cookies.txt

## Example

```swift
import CookiesText

// load from cookies.txt
let cookies = try CookiesText.cookies(of: cookiesTxtURL)
for cookie in cookies {
    HTTPCookiesStorage.shared.setCookie(cookie)
}

// shorthands
try HTTPCookiesStorage.shared.setCookies(from: cookiesTxtURL)
```

## Installation

```swift
package.append(
    .package(url: "https://github.com/griffin-stewie/CookiesText.git", from: "0.1.0")
)

package.targets.append(
    .target(name: "Foo", dependencies: [
        .product(name: "CookiesText", package: "CookiesText")
    ])
)
```

## Inspirations

- [mengzhuo/cookiestxt: cookiestxt implement parser of cookies txt format](https://github.com/mengzhuo/cookiestxt)
- [MercuryEngineering/CookieMonster: A Go library to parse Netscape HTTP cookie format files](https://github.com/MercuryEngineering/CookieMonster)
- [aki237/nscjar: Golang package for parsing Netscape/Mozilla Cookie data](https://github.com/aki237/nscjar)

[badge-platforms]: https://img.shields.io/badge/platforms-macOS-lightgrey.svg
[badge-languages]: https://img.shields.io/badge/swift-5.3-orange.svg
[badge-release]: https://img.shields.io/github/v/release/griffin-stewie/CookiesText.svg?color=red
[badge-license]: https://img.shields.io/badge/license-MIT-blue.svg