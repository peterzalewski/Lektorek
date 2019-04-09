//
//  SearchResults.swift
//  Lektorek
//
//  Created by Pete Zalewski on 4/2/19.
//  Copyright © 2019 Pete Zalewski. All rights reserved.
//

import Foundation

struct SearchResults: Codable {
    var entriesFound: Int
    var currentPage: Int
    var currentPageSize: Int
    var foundAs: String
    var hasNextPage: Bool
    var nextPage: Int
    var results: [Headword]
    
    enum CodingKeys: String, CodingKey {
        case entriesFound = "current_entries_found"
        case currentPage = "current_page"
        case currentPageSize = "current_page_size"
        case foundAs = "found_as"
        case hasNextPage = "has_next_page"
        case nextPage = "next_page"
        
        case results
    }
}
