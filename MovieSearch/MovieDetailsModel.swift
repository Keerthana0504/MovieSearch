//
//  MovieDetailsModel.swift
//  MovieSearch
//
//  Created by Keerthana Reddy Ragi on 22/09/18.
//  Copyright © 2018 Keerthana. All rights reserved.
//

import Foundation

struct MovieDetailsModel: Decodable {
    let movies: [Movies]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        movies = try container.decode([Movies].self, forKey: .results)
    }
    
    init(movies: [Movies]) {
        self.movies = movies
    }
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Movies: Decodable {
    let title: String?
    let poster_path: String?
    let overview: String?
    let release_date: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decode(String.self, forKey: .title)
        poster_path = try? container.decode(String.self, forKey: .poster_path)
        overview = try? container.decode(String.self, forKey: .overview)
        release_date = try? container.decode(String.self, forKey: .release_date)
    }
    
    init(title: String?, poster_path: String?, overview: String?, release_date: String?) {
        self.title = title
        self.poster_path = poster_path
        self.overview = overview
        self.release_date = release_date
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case poster_path
        case overview
        case release_date
    }
}

