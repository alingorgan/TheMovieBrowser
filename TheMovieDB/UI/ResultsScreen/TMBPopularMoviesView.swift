//
//  TMBPopularMoviesView.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import Foundation

struct TMBPopularMoviesViewModel {
    let title: String
    let viewModels: [TMBPopularMovieViewModel]
}

protocol TMBPopularMoviesView: class {
    
    static var Identifier: String { get }
    
    var presenter: TMBPopularMoviesPresenter! { get set }
    
    var viewModel: TMBPopularMoviesViewModel! { get set }
}
