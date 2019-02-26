//
//  TMBStubPopularMoviePresenter.swift
//  TheMovieDBTests
//
//  Created by Alin Gorgan on 2/26/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

@testable import TheMovieDB

final class TMBStubPopularMoviePresenter: TMBMovieDetailsPresenting {

    var didLoadCalledStub: ((_ view: TMBMovieDetailsView) -> Void)!
    
    func didLoad(view: TMBMovieDetailsView) {
        didLoadCalledStub(view)
    }
}
