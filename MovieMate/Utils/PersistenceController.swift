//
//  PersistenceController.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 28/08/25.
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MovieModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func saveMovies(_ movies: [Movie], for category: String) {
        let context = container.viewContext
        
        // Delete existing movies for this category
        let fetchRequest: NSFetchRequest<CachedMovie> = CachedMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        
        do {
            let existingMovies = try context.fetch(fetchRequest)
            existingMovies.forEach { context.delete($0) }
            
            // Save new movies
            movies.forEach { movie in
                let cachedMovie = movie.toEntity(context: context)
                cachedMovie.category = category
            }
            
            try context.save()
        } catch {
            print("Error saving movies: \(error)")
        }
    }
    
    func fetchMovies(for category: String) -> [Movie] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<CachedMovie> = CachedMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        
        do {
            let cachedMovies = try context.fetch(fetchRequest)
            return cachedMovies.map { cached in
                Movie(
                    id: Int(cached.id),
                    title: cached.title,
                    posterPath: cached.posterPath,
                    overview: cached.overview,
                    releaseDate: cached.releaseDate,
                    voteAverage: cached.voteAverage
                )
            }
        } catch {
            print("Error fetching movies: \(error)")
            return []
        }
    }
}
