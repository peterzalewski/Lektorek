//
//  Headword.swift
//  Lektorek
//
//  Created by Pete Zalewski on 4/8/19.
//  Copyright © 2019 Pete Zalewski. All rights reserved.
//

import Foundation

enum GrammarCategory: String, CaseIterable {
    case Noun = "noun"
    case Adjective = "adj"
    case ImperfectiveVerb = "impf"
    case PerfectiveVerb = "pf"
}

class Headword: Codable {
    var crossReferences: String
    var definition: String
    var headword: String
    var highlights: String
    var id: String
    var rank: String
    
    lazy var attributedDefinition: NSAttributedString? = {
        if let definitionData = definition.data(using: .utf16, allowLossyConversion: false) {
            if let attributedText = try? NSAttributedString(data: definitionData, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                return attributedText
            }
        }
        return nil
    }()
    
    var grammarDetails = [GrammarCategory: [String: String]]()
    
    private func isGrammarCategory(_ category: GrammarCategory) -> Bool {
        if let details = grammarDetails[category] {
            return details.count > 0
        }
        return false
    }
    
    lazy var isNoun: Bool = {
        return isGrammarCategory(.Noun)
    }()
    
    lazy var isAdjective: Bool = {
        return isGrammarCategory(.Adjective)
    }()
    
    lazy var isPerfectiveVerb: Bool = {
        return isGrammarCategory(.PerfectiveVerb)
    }()
    
    lazy var isImperfectiveVerb: Bool = {
        return isGrammarCategory(.ImperfectiveVerb)
    }()
    
    enum CodingKeys: String, CodingKey {
        case crossReferences = "crossreferences"
        case definition = "embedded_definition"
        case headword
        case highlights
        case id
        case rank
    }
    
    func loadGrammaticalData(completionHandler: @escaping () -> Void) {
        guard let safeHeadword = headword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let workerGroup = DispatchGroup()
        
        for category in GrammarCategory.allCases {
            let url = URL(string: "http://lektorek.org/lapi/v2/public/index.php/polish/grammar/search/\(category.rawValue)/\(safeHeadword)")

            workerGroup.enter()
            URLSession.shared.dataTask(with: url!, completionHandler: {
                [unowned self] (data, response, error) in
                defer {
                    workerGroup.leave()
                }
                
                // The Lektorek API returns 204 when no grammar details are present, so filter on 200
                guard let response = response as? HTTPURLResponse else { return }
                guard response.statusCode == 200 else { return }
                guard let data = data else { return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [[String: String]] {
                        self.grammarDetails[category] = object[0]
                    } else {
                        print("Could not cast")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }).resume()
        }
        
        workerGroup.notify(queue: .main) {
            completionHandler()
        }
    }
}
