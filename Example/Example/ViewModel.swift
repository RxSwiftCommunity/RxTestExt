//
//  ViewModel.swift
//  Example
//
//  Created by Mostafa Amer on 08.11.17.
//  Copyright © 2017 Mostafa Amer. All rights reserved.
//

import RxSwift

class ViewModel {
    private let _subject = PublishSubject<String>()

    var elements: Observable<String> {
        return _subject.asObservable()
    }

    var input: AnyObserver<String> {
        return _subject.asObserver()
    }
}
