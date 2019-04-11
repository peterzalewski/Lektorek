//
//  HeadwordDetailController.swift
//  Lektorek
//
//  Created by Pete Zalewski on 4/4/19.
//  Copyright © 2019 Pete Zalewski. All rights reserved.
//

import Foundation
import UIKit

let IMPF_TO_CELLS = [
    ("ja", "present_1_lp"),
    ("ty", "present_2_lp"),
    ("on/ona/ono", "present_3_lp"),
    ("my", "present_1_lm"),
    ("wy", "present_2_lm"),
    ("one/oni", "present_3_lm"),
]

// TODO: Clean up constraints, or build programmatically with StackView?
class HeadwordDetailController: UIViewController {
    var entry: Headword?
    @IBOutlet var headword: UILabel!
    @IBOutlet var definitionsLabel: UILabel!
    @IBOutlet var grammarDetailsLabel: UILabel!
    @IBOutlet var grammarDetailsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let entry = entry else { return }
        
        // TODO: scale down when headword is too long
        headword?.text = entry.headword.lowercased()
        headword?.sizeToFit()
        
        if let definitionData = entry.attributedDefinition {
            definitionsLabel?.attributedText = definitionData
            definitionsLabel?.sizeToFit()
        }

        entry.loadGrammaticalData() {
            [unowned self] in
            if (entry.isNoun) {
                self.grammarDetailsLabel?.text = "DECLINATION"
            }
            else if (entry.isAdjective) {
                self.grammarDetailsLabel?.text = "DECLINATION"
            }
            else if (entry.isPerfectiveVerb) {
                self.grammarDetailsLabel?.text = "CONJUGATION"
            }
            else if (entry.isImperfectiveVerb) {
                self.grammarDetailsLabel?.text = "CONJUGATION"
                
                for (prefix, form) in IMPF_TO_CELLS {
                    // TODO: What to do if this fails?
                    if let form = entry.grammarDetails[.ImperfectiveVerb]?[form] {
                        let detailCell = self.grammarDetailCell(for: form, precededBy: prefix)
                        detailCell.sizeToFit()
                        self.grammarDetailsStackView.addArrangedSubview(detailCell)
                    }
                }
                
                self.grammarDetailsStackView.sizeToFit()
            }
        }
    }
    
    func grammarDetailCell(for form: String, precededBy prefix: String?) -> UILabel {
        let label = UILabel()
        
        if let prefix = prefix {
            label.text = "\(prefix) \(form)"
        } else {
            label.text = form
        }
        
        label.font = UIFont(name: "AvenirNext", size: 14.0)
        label.textColor = UIColor(red: CGFloat(50 / 255.0), green: CGFloat(50 / 255.0), blue: CGFloat(50 / 255.0), alpha: CGFloat(1.0))
        
        return label
    }
}
