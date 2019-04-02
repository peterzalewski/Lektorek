//
//  ViewController.swift
//  Lektorek
//
//  Created by Pete Zalewski on 4/1/19.
//  Copyright © 2019 Pete Zalewski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getSearchURL(for string: String) -> URL? {
        // http://lektorek.org/lapi/v2/public/index.php/polish/search/czyta%C4%87?page_size=20&pos=all&diacritics=false
        var components = URLComponents()
        components.scheme = "http"
        components.host = "lektorek.org"
        components.path = "/lapi/v2/public/index.php/polish/search/\(string)"
        components.queryItems = [
            URLQueryItem(name: "page_size", value: "20"),
            URLQueryItem(name: "pos", value: "all"),
            URLQueryItem(name: "diacritic", value: "false"),
        ]
        return components.url
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        guard let searchTerm = searchField.text else { return }
        guard let url = getSearchURL(for: searchTerm) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj)
            }
        }).resume()
    }
}
