//
//  TMBPopularMovieSearchResultRawModel.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import Foundation

struct TMBPopularMovieSearchResultRawModel: Decodable {
    
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [TMBPopularMovieRawModel]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
