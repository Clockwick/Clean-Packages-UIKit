//
//  Observable+Ext.swift
//  Pods
//
//  Created by Paratthakorn Sribunyong on 7/12/2567 BE.
//

import Foundation
import RxSwift
import RxCocoa

public extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        map { _ in }
    }
}

public extension ObservableType {
    func catchErrorJustcomplete() -> Observable<Element> {
        `catch` { _ in
            .empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in
            .empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }
}
