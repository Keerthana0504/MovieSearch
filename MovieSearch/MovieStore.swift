//
//  MovieStore.swift
//  MovieSearch
//
//  Created by Keerthana Reddy Ragi on 22/09/18.
//  Copyright © 2018 Keerthana. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

enum MovieStoreError: Error {
    case parameterError
    case networkError
    case serverError
    case parseError
}

protocol Store {
    func fetchMovies(searchQuery: String, result: @escaping ((Result<MovieDetailsModel>) -> Void))
    func fetchMore(result: @escaping ((Result<MovieDetailsModel>) -> Void))
}

class MovieStore: Store {
    
    var lastPageFetched = 1
    var lastSearchQuery = ""
    let session = URLSession.shared
    
    public func fetchMovies(searchQuery: String = "", result: @escaping ((Result<MovieDetailsModel>) -> Void)) {
        
        let encodedQuery = searchQuery.replacingOccurrences(of: " ", with: "%2C")
        
        if lastSearchQuery != encodedQuery {
            lastSearchQuery = encodedQuery
            lastPageFetched = 1
        }
        
        let urlSearch = "https://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(lastSearchQuery)&page=\(lastPageFetched)"
        
        guard let url = URL(string: urlSearch) else {
            result(.error(MovieStoreError.parameterError))
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.error(error))
            }
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let moviesModel = try? JSONDecoder().decode(MovieDetailsModel.self, from: data) else {
                    result(.error(MovieStoreError.parseError))
                    return
                }
                DispatchQueue.main.async {
                    result(.success(moviesModel))
                }
            } else {
                result(.error(MovieStoreError.serverError))
            }
            }.resume()
    }
    
    public func fetchMore(result: @escaping ((Result<MovieDetailsModel>) -> Void)) {
        lastPageFetched += 1
        self.fetchMovies(searchQuery: lastSearchQuery, result: result)
    }
}

