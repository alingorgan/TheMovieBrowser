//
//  TMBPopularMoviePersistentModel.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import CoreData

protocol TMBPersistentModel {
    static var entityName: String { get }
}

final class TMBPopularMoviePersistentModel: NSManagedObject, TMBPopularMovieModel {
    
    @NSManaged var position: Int
    @NSManaged var title: String
    @NSManaged var releaseDate: String
    @NSManaged var overview: String
    @NSManaged var rating: Double
    @NSManaged var imagePath: String
    @NSManaged var isFavorite: Bool
}

extension TMBPopularMoviePersistentModel: TMBPersistentModel {
    static let entityName = "PopularMovie"
}
