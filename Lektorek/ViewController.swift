//
//  ViewController.swift
//  Lektorek
//
//  Created by Pete Zalewski on 4/1/19.
//  Copyright © 2019 Pete Zalewski. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    @IBOutlet var searchField: UITextField!
    
    var entries = [Entry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Szukaj"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
    
    func searchLektorek(for query: String) {
        guard query.count > 0 else {
            self.entries = []
            self.tableView.reloadData()
            return
        }
        guard let url = getSearchURL(for: query) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {
            [unowned self] (data, response, error) in
            let decoder = JSONDecoder()
            do {
                let searchResults = try decoder.decode(SearchResults.self, from: data!)
                self.entries = searchResults.results
            } catch let err {
                print(err)
                self.entries = []
            }
            DispatchQueue.main.async {
                [unowned self] in
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if (indexPath.row >= entries.count) {
            return cell
        }
        
        let entry = entries[indexPath.row]
        cell.textLabel?.text = entry.headword
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailController = storyboard?.instantiateViewController(withIdentifier: "headword") as? HeadwordDetailController {
            detailController.entry = entries[indexPath.row]
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchLektorek(for: searchController.searchBar.text!)
    }
}
