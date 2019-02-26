//
//  TMBStubMovieDetailsInteractor.swift
//  TheMovieDBTests
//
//  Created by Alin Gorgan on 2/26/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import UIKit

@testable import TheMovieDB

final class TMBStubMovieDetailsInteractor: TMBMovieDetailsInteracting {
    
    var loadImageForResultCalled: (() -> Void)!
    
    func loadImageForResult(completion: @escaping (String, UIImage?) -> ()) {
        loadImageForResultCalled()
    }
    
}
