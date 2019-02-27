//
//  TMBPopularMoviesViewController.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import UIKit

class TMBPopularMoviesViewController: UIViewController, TMBPopularMoviesView {
    
    static var Identifier = "PopularMoviesViewController"
    
    var presenter: TMBPopularMoviesPresenter!
    
    var viewModel: TMBPopularMoviesViewModel! {
        didSet {
            title = viewModel.title
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var shouldPerformSetup = true
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if shouldPerformSetup {
            setup(collectionView)
            presenter.didLoad(view: self)
            shouldPerformSetup = false
        }
    }
    
    private func setup(_ collectionView: UICollectionView) {
        let nib = UINib.init(nibName: TMBMovieCollectionViewCell.Identifier, bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: TMBMovieCollectionViewCell.Identifier)
        collectionView.backgroundColor = UIColor.lightGray
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = collectionView.bounds.width / 2 - CollectionViewMetrics.EdgeInsets.left - layout.minimumInteritemSpacing
            layout.sectionInset = CollectionViewMetrics.EdgeInsets
            layout.itemSize = CGSize(width: width, height: width * CollectionViewMetrics.CellHeightRatio)
        }
    }
}

extension TMBPopularMoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.viewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMBMovieCollectionViewCell.Identifier, for: indexPath) as! TMBMovieCollectionViewCell
        cell.configure(with: viewModel.viewModels[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

extension TMBPopularMoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.viewModels[indexPath.row].image == ImageAssets.placeholder {
            let imageWidth = (cell as! TMBMovieCollectionViewCell).imageView.bounds.width
            presenter.updatePosterImageForPopularMovie(at: indexPath.row, with: imageWidth, in: self)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.bounds.maxY > scrollView.contentSize.height && scrollView.contentSize.height > 0) {
            presenter.didScrollToBottom(in: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.row)
    }
}

extension TMBPopularMoviesViewController: TMBMovieCollectionViewCellDelegate {
    
    func didTapFavoriteButton(in cell: TMBMovieCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter.updateFavoriteStateForPopularMovie(at: indexPath.row, in: self)
    }
}

struct CollectionViewMetrics {
    static let EdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    static let CellHeightRatio: CGFloat = 2.6
}

