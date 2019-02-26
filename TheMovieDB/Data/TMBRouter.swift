//
//  TMBRouter.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import UIKit

protocol TMBRouting: class {
    
    func navigateToPopularMoviesViewControler()
    
    func navigateToMovieDetailsViewController(at position: Int)
    
}

final class TMBRouter: TMBRouting {
    
    private let navigationController: UINavigationController
    private let storyboard: UIStoryboard
    private let configurator: TMBViewConfigurating
    
    init(configurator: TMBViewConfigurating, navigationController: UINavigationController, storyboard: UIStoryboard) {
        self.configurator = configurator
        self.navigationController = navigationController
        self.storyboard = storyboard
    }
    
    func navigateToPopularMoviesViewControler() {
        let view = storyboard.instantiateViewController(withIdentifier: TMBPopularMoviesViewController.Identifier) as! TMBPopularMoviesViewController
        configurator.configure(popularMoviesView: view)
        navigationController.setViewControllers([view], animated: false)
        
    }
    
    func navigateToMovieDetailsViewController(at position: Int) {
        let view = storyboard.instantiateViewController(withIdentifier: TMBMovieDetailsViewController.Identifier) as! TMBMovieDetailsViewController
        configurator.configure(movieDetailsView: view, with: position)
        navigationController.pushViewController(view, animated: true)
    }
}
