//
//  TMBPopularMoviesPresenter.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import UIKit

protocol TMBPopularMoviesPresenting {
    
    func didLoad(view: TMBPopularMoviesView)
    
    func didScrollToBottom(in view: TMBPopularMoviesView)
    
    func updatePosterImageForPopularMovie(at index: Int, with width: CGFloat, in view: TMBPopularMoviesView)
    
    func updateFavoriteStateForPopularMovie(at index: Int, in view: TMBPopularMoviesView)
    
    func didSelectItem(at index: Int)
    
}

final class TMBPopularMoviesPresenter: TMBPopularMoviesPresenting {
    
    private let viewTitle = "Popular Movies"
    
    private let router: TMBRouting
    private let interactor: TMBPopularMoviesInteracting
    
    init(router: TMBRouting, interactor: TMBPopularMoviesInteracting) {
        self.router = router
        self.interactor = interactor
    }
    
    func didLoad(view: TMBPopularMoviesView) {
        let viewModels = interactor.cachedPopularMovies().map { TMBPopularMovieViewModel(popularMovieModel: $0) }
        view.viewModel = TMBPopularMoviesViewModel(title: viewTitle, viewModels: viewModels)
        
        interactor.fetchPopularMovies { popularMovieModels in
            let viewModels = popularMovieModels.map { TMBPopularMovieViewModel(popularMovieModel: $0) }
            view.viewModel = TMBPopularMoviesViewModel(title: self.viewTitle, viewModels: viewModels)
        }
    }
    
    func didScrollToBottom(in view: TMBPopularMoviesView) {
        interactor.fetchPopularMovies { popularMovieModels in
            let viewModels = popularMovieModels.map { TMBPopularMovieViewModel(popularMovieModel: $0) }
            view.viewModel = TMBPopularMoviesViewModel(title: self.viewTitle, viewModels: viewModels)
        }
    }
    
    func updatePosterImageForPopularMovie(at index: Int, with width: CGFloat, in view: TMBPopularMoviesView) {
        let sourceModel = view.viewModel.viewModels[index]
        
        interactor.loadPosterImageForMovie(at: index, with: width) { image in
            
            let updatedModel = TMBPopularMovieViewModel(
                image: image,
                title: sourceModel.title,
                releaseDate: sourceModel.releaseDate,
                overview: sourceModel.overview,
                ratingPercentage: sourceModel.ratingPercentage,
                ratingPercentageColor: sourceModel.ratingPercentageColor,
                ratingPrefix: sourceModel.ratingPrefix,
                favoriteButtonImage: sourceModel.favoriteButtonImage)
            
            var sourceViewModels = view.viewModel.viewModels
            sourceViewModels[index] = updatedModel
            view.viewModel = TMBPopularMoviesViewModel(title: view.viewModel.title, viewModels: sourceViewModels)
        }
    }
    
    func updateFavoriteStateForPopularMovie(at index: Int, in view: TMBPopularMoviesView) {
        let updatedDataModel = interactor.toggleFavoriteMovieState(for: index)
        
        let sourceViewModel = view.viewModel.viewModels[index]
        let updatedViewModel = TMBPopularMovieViewModel(popularMovieModel: updatedDataModel, image: sourceViewModel.image)
        
        var sourceViewModels = view.viewModel.viewModels
        sourceViewModels[index] = updatedViewModel
        view.viewModel = TMBPopularMoviesViewModel(title: view.viewModel.title, viewModels: sourceViewModels)
    }
    
    func didSelectItem(at index: Int) {
        let resultPosition = interactor.positionOfStoredItem(for: index)
        router.navigateToMovieDetailsViewController(at: resultPosition)
    }
}

extension TMBPopularMovieViewModel {
    
    init(popularMovieModel: TMBPopularMovieModel, image: UIImage = ImageAssets.placeholder) {
        title = popularMovieModel.title
        releaseDate = popularMovieModel.releaseDate
        overview = popularMovieModel.overview
        ratingPercentage = popularMovieModel.rating
        ratingPercentageColor = popularMovieModel.ratingSegment.color
        ratingPrefix = popularMovieModel.ratingSegment.ratingPrefix
        self.image = image
        favoriteButtonImage = popularMovieModel.isFavorite ? ImageAssets.favoriteImage : ImageAssets.unfavoriteImage
    }
}

extension TMBMovieRatingSegment {
    
    var color: UIColor {
        
        switch self {
        case .high: return .green
        case .average: return .orange
        case .low: return .red
        }
    }
    
    var ratingPrefix: String {
        switch self {
        case .high: return "👏"
        case .average: return "👍"
        case .low: return "🤞"
        }
    }
    
}
