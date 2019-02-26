//
//  TMBViewConfigurator.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import Foundation

protocol TMBViewConfigurating: class {
    
    func configure(popularMoviesView: TMBPopularMoviesView)
    
    func configure(movieDetailsView: TMBMovieDetailsView, with resultIndex: Int)
}


final class TMBViewConfigurator: TMBViewConfigurating {
    
    weak var router: TMBRouting!
    
    private let persistentStore: TMBPersistentStore
    private let urlFactory: TMBURLCreating
    
    init(persistentStore: TMBPersistentStore, urlFactory: TMBURLCreating) {
        self.persistentStore = persistentStore
        self.urlFactory = urlFactory
    }
    
    func configure(popularMoviesView: TMBPopularMoviesView) {
        let interactor = TMBPopularMoviesInteractor(
            persistentStore: persistentStore,
            urlFactory: urlFactory)
        
        popularMoviesView.presenter = TMBPopularMoviesPresenter(router: router, interactor: interactor)
    }
    
    func configure(movieDetailsView: TMBMovieDetailsView, with resultIndex: Int) {
        let interactor = TMBMovieDetailsInteractor(
            resultIndex: resultIndex,
            persistentStore: persistentStore,
            urlFactory: urlFactory)
        
        movieDetailsView.presenter = TMBMovieDetailsPresenter(interactor: interactor)
    }
}
