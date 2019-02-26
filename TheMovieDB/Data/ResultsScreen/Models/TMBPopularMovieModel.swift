//
//  TMBPopularMovieModel.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import Foundation

enum TMBMovieRatingSegment {
    case low, average, high
}

protocol TMBPopularMovieModel {
    
    var title: String { get }
    var releaseDate: String { get }
    var overview: String { get }
    var rating: Double { get }
    var imagePath: String { get }
    var isFavorite: Bool { get }
    var ratingSegment: TMBMovieRatingSegment { get }
}
