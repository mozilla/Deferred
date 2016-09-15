//
//  LockProtected.swift
//  ReadWriteLock
//
//  Created by John Gallagher on 7/17/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Foundation

public final class LockProtected<T> {
    fileprivate var lock: ReadWriteLock
    fileprivate var item: T

    public convenience init(item: T) {
        self.init(item: item, lock: CASSpinLock())
    }

    public init(item: T, lock: ReadWriteLock) {
        self.item = item
        self.lock = lock
    }

    public func withReadLock<U>(_ block: @escaping (T) -> U) -> U {
        return lock.withReadLock { [unowned self] in
            return block(self.item)
        }
    }

    public func withWriteLock<U>(_ block: @escaping (inout T) -> U) -> U {
        return lock.withWriteLock { [unowned self] in
            return block(&self.item)
        }
    }
}
