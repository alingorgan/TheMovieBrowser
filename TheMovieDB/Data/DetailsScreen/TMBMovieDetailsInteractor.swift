//
//  TMBMovieDetailsInteractor.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/26/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import UIKit
import CoreData

protocol TMBMovieDetailsInteracting {
    
    func loadImageForResult(completion: @escaping (_ title: String, _ posterImage: UIImage?) -> ())
    
}

final class TMBMovieDetailsInteractor: TMBMovieDetailsInteracting {
    
    private let resultIndex: Int
    private let persistentStore: TMBPersistentStore
    private let urlFactory: TMBURLCreating
    
    init(resultIndex: Int, persistentStore: TMBPersistentStore, urlFactory: TMBURLCreating) {
        self.resultIndex = resultIndex
        self.persistentStore = persistentStore
        self.urlFactory = urlFactory
    }
    
    func loadImageForResult(completion: @escaping (_ title: String, _ posterImage: UIImage?) -> ()) {
        
        let backgroundContext = persistentStore.persistentContainer.newBackgroundContext()
        
        func dispatchResult(title: String, image: UIImage?) { DispatchQueue.main.async { completion(title, image) } }
        
        backgroundContext.perform {
            let fetchRequest = NSFetchRequest<TMBPopularMoviePersistentModel>(entityName: TMBPopularMoviePersistentModel.entityName)
            fetchRequest.predicate = NSPredicate(format: "position == \(self.resultIndex)")
            
            guard let result = (try? backgroundContext.fetch(fetchRequest))?.first else { dispatchResult(title: "", image: nil); return }
            
            let resultTitle = result.title
            let imageURL = self.urlFactory.makeMoviePosterURL(for: result.imagePath)
            
            URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, error) in
                
                guard let data = data, error == nil else { dispatchResult(title: resultTitle, image: nil); return }
                guard let image = UIImage(data: data) else { dispatchResult(title: resultTitle, image: nil); return }
                
                dispatchResult(title: resultTitle, image: image);
            }).resume()
        }
    }
    
}
