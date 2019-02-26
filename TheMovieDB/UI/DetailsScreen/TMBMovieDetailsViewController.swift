//
//  TMBMovieDetailsViewController.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/26/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import UIKit

protocol TMBMovieDetailsView: class {
    
    var viewModel: TMBMovieDetailsViewModel? { get set }
    
    var presenter: TMBMovieDetailsPresenting! { get set }
}

final class TMBMovieDetailsViewController: UIViewController, TMBMovieDetailsView {
    
    static var Identifier = "MovieDetailsViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    
    var presenter: TMBMovieDetailsPresenting!
    
    var viewModel: TMBMovieDetailsViewModel? {
        didSet {
            if let viewModel = viewModel {
                updateUI(with: viewModel)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.didLoad(view: self)
    }
    
    private func updateUI(with viewModel: TMBMovieDetailsViewModel) {
        imageView.image = viewModel.moviePoster
        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
    }
    
}
