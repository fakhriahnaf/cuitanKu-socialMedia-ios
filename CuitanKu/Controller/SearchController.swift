//
//  ExploreController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 27/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//


import UIKit

private let reusableIdentifier = "UserCell"

enum SearchControllerConfiguration {
    case message
    case userSearch
}

class SearchController: UITableViewController {
    
    // MARK = - Propertis
    
    private let config : SearchControllerConfiguration
    
    private var  users = [User]() {
        didSet { tableView.reloadData()}
    }
    
    private var filteredUsers = [User]() {
        didSet { tableView.reloadData()}
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    
    //Mark = - Lifecycle
    
    init(config: SearchControllerConfiguration) {
        self.config = config
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        configureSearchController()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    
    //MARK : - API
    func fetchUser() {
        UserService.shared.fetchUser { users in
            self.users = users
            
        }
    }
    //MARK : - SELECTOR
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    //MARK : - HELPERS
    //buat navigasi atas Bar
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = config == .message ? "New Message" : "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        if config == .message {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "search for user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for : indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let user = users[indexPath.row]
        let user =  inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
extension SearchController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({ $0.username.contains(searchText)})
    }
}