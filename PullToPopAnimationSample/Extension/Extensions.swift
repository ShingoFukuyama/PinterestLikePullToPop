//
//  Extensions.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import Foundation

struct Extension<T> {
    let base: T
    init (_ base: T) {
        self.base = base
    }
}

protocol ExtensionCompatible {
    associatedtype Compatible
    static var ext: Extension<Compatible>.Type { get }
    var ext: Extension<Compatible> { get }
}

extension ExtensionCompatible {
    public static var ext: Extension<Self>.Type {
        return Extension<Self>.self
    }
    public var ext: Extension<Self> {
        return Extension(self)
    }
}

extension NSObject: ExtensionCompatible { }
extension Extension where T: NSObject {
    var `class`: T.Type {
        return type(of: base)
    }
    var className: String {
        return "\(self.class)"
    }
}
