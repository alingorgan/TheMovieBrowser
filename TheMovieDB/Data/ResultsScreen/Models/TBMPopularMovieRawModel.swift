//
//  TMBPopularMovieRawModel.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

struct TMBPopularMovieRawModel: Decodable {
    
    let title: String
    let releaseDate: String
    let overview: String
    let rating: Double
    let imagePath: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case releaseDate = "release_date"
        case overview
        case rating = "vote_average"
        case imagePath = "poster_path"
    }
}
