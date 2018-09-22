//
//  ViewController.swift
//  MovieSearch
//
//  Created by Keerthana Reddy Ragi on 22/09/18.
//  Copyright © 2018 Keerthana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var moviesTableView: UITableView!
    let store: Store = MovieStore()
    var movies = [Movies]()
    var searchText = ""
    var searchTerms = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "One Stop Movie"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for Movies"
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        moviesTableView = UITableView.init(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: self.view.bounds.height - 20))
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.showsVerticalScrollIndicator = false;
        moviesTableView.showsHorizontalScrollIndicator = false;
        moviesTableView.separatorStyle = .none
        moviesTableView.bounces = false;
        moviesTableView.scrollsToTop = true
        self.view.addSubview(moviesTableView)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Pagination
        if (indexPath.row < movies.count && indexPath.row == movies.count - 2) {
            store.fetchMore { (result) in
                switch(result) {
                case .success(let movies):
                    if(movies.movies.count > 0) {
                        self.movies.append(contentsOf: movies.movies)
                        self.moviesTableView.reloadData()
                    } else {
                        self.showErrorToast(error: "No more results to display")
                    }
                case .error(let error):
                    self.showErrorAlert(errorTitle: "Something Not Right", errorMessage: error.localizedDescription)
                }
            }
        }
        
        let cell = MovieDetailCell.init(width: Int(self.view.bounds.width), data: movies[indexPath.row])
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let overViewText = self.movies[indexPath.row].overview {
            let height = overViewText.heightWithConstrainedWidth(width: 3*self.view.bounds.width/4 - 32, font: UIFont.systemFont(ofSize: 12.0))
            return max(height + 65, 140)
        }
        return 140
    }
}

extension ViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Don't want to make an API call for every letter typed. So skipped using this method.
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        handlingVCDisplay()
        if let text = searchController.searchBar.text?.lowercased(), !text.isEmpty {
            searchMovies(search: text)
        }
    }
    
    func tappedSearchHistory(item: String) {
        searchMovies(search: item)
        handlingVCDisplay()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        handlingVCDisplay()
    }
    
    func searchMovies(search: String) {
        store.fetchMovies(searchQuery: search) { (result) in
            switch(result) {
            case .success(let movies):
                if(movies.movies.count > 0) {
                    self.movies = movies.movies
                    self.moviesTableView.reloadData()
                    
                    if (self.searchTerms.count < 0) {
                        self.searchTerms[0] = search
                    } else {
                        self.updatingRecentSearch(text: search)
                    }
                } else {
                    self.showErrorAlert(errorTitle: "No Results Found", errorMessage: "Search word either doesn't have any results available or it's not a invalid search")
                }
            case .error(let error):
                self.showErrorAlert(errorTitle: "Something Not Right", errorMessage: error.localizedDescription)
            }
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        handlingVCDisplay()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func handlingVCDisplay() {
        self.view.addSubview(moviesTableView)
        moviesTableView.scrollRectToVisible(.zero, animated: false)
    }
    
    func updatingRecentSearch(text: String) {
        if(searchTerms.count > 9) {
            searchTerms.removeLast()
        }
        if let index = searchTerms.index(of: text), index >= 0 {
            searchTerms.remove(at: index.hashValue)
        }
        searchTerms.insert(text, at: 0)
    }
}

extension ViewController {
    func showErrorAlert(errorTitle: String, errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.dismiss(animated: false) { () -> Void in
            self.present(alert, animated: true, completion: nil)
            if(self.searchTerms.count > 0) {
                self.searchTerms.removeLast()
            }
        }
    }
    
    func showErrorToast(error: String) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 32, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.systemFont(ofSize: 16)
        toastLabel.text = error
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .transitionCurlDown, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
}

