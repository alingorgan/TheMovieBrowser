//
//  TMBMovieDetailsPresenter.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/26/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import UIKit

protocol TMBMovieDetailsPresenting {
    
    func didLoad(view: TMBMovieDetailsView)
    
}

final class TMBMovieDetailsPresenter: TMBMovieDetailsPresenting {
    
    private let interactor: TMBMovieDetailsInteracting
    
    init(interactor: TMBMovieDetailsInteracting) {
        self.interactor = interactor
    }
    
    func didLoad(view: TMBMovieDetailsView) {
        let backgroundColor = UIColor.lightGray
        
        view.viewModel = TMBMovieDetailsViewModel(
            title: "",
            moviePoster: ImageAssets.placeholder,
            backgroundColor: backgroundColor)
        
        interactor.loadImageForResult {
            view.viewModel = TMBMovieDetailsViewModel(
                title: $0,
                moviePoster: $1 ?? ImageAssets.placeholder,
                backgroundColor: backgroundColor)
        }
    }
}
