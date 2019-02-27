//
//  TMBURLFactory.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import Foundation

protocol TMBURLCreating {
    
    func makePopularMoviesURL(for page: Int) -> URL
    
    func makeMoviePosterURL(with width: Int, for path: String) -> URL
}

final class TMBURLFactory: TMBURLCreating {
    
    private let APIKey = "b105c8881b639900674056a95e6487b3"
    
    func makePopularMoviesURL(for page: Int) -> URL {
        
        let formattedURLString = String(
            format: UnformattedURLs.PopularMovies,
            APIKey, page)
        
        return URL(string: formattedURLString)!
    }
    
    func makeMoviePosterURL(with width: Int, for path: String) -> URL {
        
        let formattedURLString = String(
            format: UnformattedURLs.PosterImagePath,
            width, path)
        
        return URL(string: formattedURLString)!
    }
}

struct UnformattedURLs {
    static let PopularMovies = "https://api.themoviedb.org/3/movie/popular?api_key=%@&page=%ld"
    static let PosterImagePath = "http://image.tmdb.org/t/p/w%ld%@"
}

