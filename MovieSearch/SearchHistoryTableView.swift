//
//  SearchHistoryTableView.swift
//  MovieSearch
//
//  Created by Keerthana Reddy Ragi on 22/09/18.
//  Copyright © 2018 Keerthana. All rights reserved.
//

import Foundation
import UIKit

protocol SearchHistoryDelegate: class {
    func tappedSearchHistory(item: String)
}

class SearchHistoryTableView: UITableView {
    
    var history = [String]()
    weak var searchDelegate: SearchHistoryDelegate?
    static let cellIdentifier = "SearchHistoryCell"
    
    init() {
        if let historyData = UserDefaults.standard.value(forKeyPath: "SearchTerms") as? [String] {
            self.history = historyData
        }
        super.init(frame: .zero, style: .plain)
        self.register(UITableViewCell.self, forCellReuseIdentifier: SearchHistoryTableView.cellIdentifier)
        self.dataSource = self
        self.delegate = self
        self.separatorStyle = .none
        self.alwaysBounceVertical = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension SearchHistoryTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryTableView.cellIdentifier) {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: SearchHistoryTableView.cellIdentifier)
        }
        cell.imageView?.image = UIImage(named: "recentSearch")
        cell.textLabel?.text = history[indexPath.row]
        cell.textLabel?.textColor = .blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchDelegate?.tappedSearchHistory(item: history[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


