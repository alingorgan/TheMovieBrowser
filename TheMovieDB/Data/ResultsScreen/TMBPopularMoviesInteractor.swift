//
//  TMBPopularMoviesInteractor.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import CoreData
import UIKit

protocol TMBPopularMoviesInteracting {
    
    func cachedPopularMovies() -> [TMBPopularMovieModel]
    
    func fetchPopularMovies(completion: @escaping ([TMBPopularMovieModel]) -> ())
    
    func loadPosterImageForMovie(at index: Int, with width: CGFloat, completion: @escaping (UIImage) -> ())
    
    func toggleFavoriteMovieState(for favoriteMovieIndex: Int) -> TMBPopularMovieModel
    
    func positionOfStoredItem(for index: Int) -> Int
}


final class TMBPopularMoviesInteractor: NSObject {
    
    typealias TMBPopularMovieCompletion = ([TMBPopularMovieModel]) -> ()
    
    fileprivate var popularMoviesFetchCompletion: TMBPopularMovieCompletion?
    
    private let persistentStore: TMBPersistentStore
    private let urlFactory: TMBURLCreating
    private var searchResultSummary = TMBPopularMovieSearchResultSummary(loadedPages: 0, totalResults: 0, totalPages: 0)
    private var loadingURLs = Set<String>()
    
    private lazy var fetchResultsController: NSFetchedResultsController<TMBPopularMoviePersistentModel> = {
        
        let fetchRequest = NSFetchRequest<TMBPopularMoviePersistentModel>(entityName: TMBPopularMoviePersistentModel.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: persistentStore.persistentContainer.viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: TMBPopularMoviePersistentModel.entityName)
    }()
    
    init(persistentStore: TMBPersistentStore, urlFactory: TMBURLCreating) {
        self.persistentStore = persistentStore
        self.urlFactory = urlFactory
        
        super.init()
        
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
    }
    
    private func shouldClearCache() -> Bool {
        return self.searchResultSummary.loadedPages == 0
    }
    
    private func clearCachedPopularMovies(with context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<TMBPopularMoviePersistentModel>(entityName: TMBPopularMoviePersistentModel.entityName)
        fetchRequest.includesPropertyValues = false
        
        try? context.fetch(fetchRequest).forEach { context.delete($0) }
    }
    
    private func favoriteMovieTitles(with context: NSManagedObjectContext) -> [String] {
        let favoriteTitlesRequest = NSFetchRequest<TMBPopularMoviePersistentModel>(entityName: TMBPopularMoviePersistentModel.entityName)
        favoriteTitlesRequest.predicate = NSPredicate(format: "isFavorite == YES")
        
        return (try? context.fetch(favoriteTitlesRequest).map { $0.title }) ?? []
    }
    
    private func storedResultCount(with context: NSManagedObjectContext) -> Int {
        let countRequest = NSFetchRequest<TMBPopularMoviePersistentModel>(entityName: TMBPopularMoviePersistentModel.entityName)
        countRequest.includesPropertyValues = false
        
        return (try? context.fetch(countRequest).count) ?? 0
    }
    
    private func persist(searchResult: TMBPopularMovieRawModel, ifNotExistentIn context: NSManagedObjectContext) -> TMBPopularMoviePersistentModel {
        let fetchRequest = NSFetchRequest<TMBPopularMoviePersistentModel>(entityName: TMBPopularMoviePersistentModel.entityName)
        fetchRequest.predicate = NSPredicate(format: "title == %@", searchResult.title)
        
        let results = (try? context.fetch(fetchRequest)) ?? []
        
        let shouldInsert = (results.first?.isDeleted ?? false) || results.isEmpty
        
        guard shouldInsert == true else { return results.first! }
        
        let persistentModel = NSEntityDescription.insertNewObject(forEntityName: TMBPopularMoviePersistentModel.entityName, into: context) as! TMBPopularMoviePersistentModel
        persistentModel.populate(with: searchResult)
        
        return persistentModel
    }
}

extension TMBPopularMoviesInteractor: TMBPopularMoviesInteracting {
    
    func fetchPopularMovies(completion: @escaping ([TMBPopularMovieModel]) -> ()) {
        
        self.popularMoviesFetchCompletion = completion
        
        let url = self.urlFactory.makePopularMoviesURL(for: self.searchResultSummary.loadedPages + 1)
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard
                let self = self, let data = data, error == nil,
                let rawSearchResult = try? JSONDecoder().decode(TMBPopularMovieSearchResultRawModel.self, from: data)
            else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            
            let backgroundContext = self.persistentStore.persistentContainer.newBackgroundContext()
            let favoriteTitles = self.favoriteMovieTitles(with: backgroundContext)
            
            var storedResultCount = self.storedResultCount(with: backgroundContext)
            
            if self.shouldClearCache() {
                self.clearCachedPopularMovies(with: backgroundContext)
                storedResultCount = 0
            }
            
            rawSearchResult.results.forEach { popularMovieRawModel in
                let persistentModel = self.persist(searchResult: popularMovieRawModel, ifNotExistentIn: backgroundContext)
                persistentModel.isFavorite = favoriteTitles.contains(persistentModel.title)
                persistentModel.position = storedResultCount
                storedResultCount += 1
            }
            
            self.searchResultSummary = .init(searchResultRawModel: rawSearchResult)
            
            try? backgroundContext.save()
            
        }.resume()
    }
    
    func loadPosterImageForMovie(at index: Int, with width: CGFloat, completion: @escaping (UIImage) -> ()) {
        
        guard let result = fetchResultsController.fetchedObjects?[index] else { return }
        
        let increment = 100
        let minimumWidth = 200
        let roundedWidth = max(increment * Int((width / CGFloat(increment)).rounded()), minimumWidth) // IMDB image proxy server accepts widths greater than 200px and in increments of 100 only
        
        let posterURL = urlFactory.makeMoviePosterURL(with: roundedWidth, for: result.imagePath)
        
        guard !loadingURLs.contains(posterURL.absoluteString) else { return }
        
        loadingURLs.insert(posterURL.absoluteString)
        
        var urlRequest = URLRequest(url: posterURL)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            self.loadingURLs.remove(posterURL.absoluteString)
            
            guard let data = data, error == nil else { return }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    func toggleFavoriteMovieState(for favoriteMovieIndex: Int) -> TMBPopularMovieModel {
        
        guard let result = fetchResultsController.fetchedObjects?[favoriteMovieIndex] else { fatalError("The result was not found") }
        
        result.isFavorite = !result.isFavorite
        try? fetchResultsController.managedObjectContext.save()
        return result
    }
    
    func cachedPopularMovies() -> [TMBPopularMovieModel] {
        return fetchResultsController.fetchedObjects ?? []
    }
    
    func positionOfStoredItem(for index: Int) -> Int {
        guard let result = fetchResultsController.fetchedObjects?[index] else { fatalError("The result was not found") }
        return result.position
    }
}

extension TMBPopularMoviesInteractor: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let popularMovies = controller.fetchedObjects as? [TMBPopularMovieModel]
        popularMoviesFetchCompletion?(popularMovies ?? [])
        popularMoviesFetchCompletion = nil
    }
}

extension TMBPopularMovieSearchResultSummary {
    
    init(searchResultRawModel: TMBPopularMovieSearchResultRawModel) {
        loadedPages = searchResultRawModel.page
        totalPages = searchResultRawModel.totalPages
        totalResults = searchResultRawModel.totalResults
    }
}

extension TMBPopularMoviePersistentModel {
    
    var ratingSegment: TMBMovieRatingSegment {
        
        switch rating {
            case _ where rating >= 7: return .high
            case 4..<7: return .average
            case _ where rating < 4: return .low
            default: return .low
        }
    }
    
    func populate(with rawModel: TMBPopularMovieRawModel) {
        title = rawModel.title
        releaseDate = rawModel.releaseDate
        overview = rawModel.overview
        rating = rawModel.rating
        imagePath = rawModel.imagePath
    }
}
