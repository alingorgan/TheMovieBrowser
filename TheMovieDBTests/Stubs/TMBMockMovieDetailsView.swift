//
//  TMBMockMovieDetailsView.swift
//  TheMovieDBTests
//
//  Created by Alin Gorgan on 2/26/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

@testable import TheMovieDB

final class TMBMockMovieDetailsView: TMBMovieDetailsView {
    
    var viewModel: TMBMovieDetailsViewModel?
    
    var presenter: TMBMovieDetailsPresenting!
}
