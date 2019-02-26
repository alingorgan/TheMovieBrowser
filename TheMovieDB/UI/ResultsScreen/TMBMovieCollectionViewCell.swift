//
//  TMBMovieCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import UIKit

protocol TMBMovieCollectionViewCellDelegate: class {
    
    func didTapFavoriteButton(in cell: TMBMovieCollectionViewCell)
    
}

final class TMBMovieCollectionViewCell: UICollectionViewCell {
    
    static let Identifier = "TMBMovieCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    weak var delegate: TMBMovieCollectionViewCellDelegate?
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        delegate?.didTapFavoriteButton(in: self)
    }
    
    func configure(with viewModel: TMBPopularMovieViewModel) {
        titleLabel.text = viewModel.title
        dateAddedLabel.text = viewModel.releaseDate
        overviewLabel.text = viewModel.overview
        ratingLabel.text = viewModel.ratingPrefix + " \(viewModel.ratingPercentage)"
        ratingLabel.textColor = viewModel.ratingPercentageColor
        imageView.image = viewModel.image
        favoriteButton.setImage(viewModel.favoriteButtonImage, for: .normal)
        
        configureLayout()
        
    }
    
    private func configureLayout() {
        contentView.layer.cornerRadius = 3.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    
}
