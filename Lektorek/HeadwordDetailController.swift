//
//  HeadwordDetailController.swift
//  Lektorek
//
//  Created by Pete Zalewski on 4/4/19.
//  Copyright © 2019 Pete Zalewski. All rights reserved.
//

import UIKit

class HeadwordDetailController: UIViewController {
    var entry: Headword?
    @IBOutlet var headword: UILabel!
    @IBOutlet var definitions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let entry = entry else { return }
        
        headword?.text = entry.headword
        
        if let definitionData = entry.definition.data(using: .utf16, allowLossyConversion: false) {
            definitions?.attributedText = try? NSAttributedString(data: definitionData, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            definitions?.sizeToFit()
        }

        entry.loadGrammaticalData() {
            if (entry.isNoun) {
                print("Noun")
            }
            if (entry.isAdjective) {
                print("Adjective")
            }
            if (entry.isPerfectiveVerb) {
                print("Perfective Verb")
            }
            if (entry.isImperfectiveVerb) {
                print("Imperfective Verb")
            }
        }
    }
}
