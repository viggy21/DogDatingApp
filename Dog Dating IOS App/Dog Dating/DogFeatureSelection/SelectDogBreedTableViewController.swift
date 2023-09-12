//
//  SelectDogBreedTableViewController.swift
//  FIT3178-Assignment
//
//  Created by Vicky Huang on 11/5/2022.
//

import UIKit

// Adding a delegate protocol so that we can communicate the dog size selected to the sign up view controller
protocol DogBreedChangeDelegate: AnyObject {
    func dogBreedChange(dogBreedChosen: String)
}

class SelectDogBreedTableViewController: UITableViewController, UISearchBarDelegate {
    // Add the delegate property to the class
    weak var delegate: DogBreedChangeDelegate?
    
    let NUMBER_SECTIONS = 1
    let CELL_DOG_BREED = "dogBreedCell"
    
    // Adding the request string
    let REQUEST_STRING = "https://api.thedogapi.com/v1/breeds?limit=1000&page=0"
    var newBreeds = [DogData]()
    var indicator = UIActivityIndicatorView()
    // Check if I need to line below
    weak var databaseController: DatabaseProtocol?
    
    let MAX_ITEMS_PER_REQUEST = 40
    let MAX_REQUESTS = 10
    var currentRequestIndex: Int = 0
    
    let LIMIT = "1000"
    let PAGE = "0"
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([ indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor), indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])
        
        // getting a reference to the database from the appDelegate
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        databaseController = appDelegate?.databaseController
        

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return NUMBER_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newBreeds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dogBreedCell = tableView.dequeueReusableCell(withIdentifier: CELL_DOG_BREED, for: indexPath)
        
        // Configure the cell...
        var content = dogBreedCell.defaultContentConfiguration()
        let breed = newBreeds[indexPath.row].dogBreed
        content.text = breed
        dogBreedCell.contentConfiguration = content
        return dogBreedCell
        

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dogBreedSelected = newBreeds[indexPath.row].dogBreed
        
        // Inform the delegate of the change to the dog size
        if let dogBreedSelected = dogBreedSelected {
            delegate?.dogBreedChange(dogBreedChosen: dogBreedSelected)
        }
         
        // Go back to the sign up view controller
        navigationController?.popViewController(animated: true)
 
       
    }

 

   

    
    // MARK: - Web API

 
    
    /**
     This method will call the API to request dog breed information
     */
    /// - Parameter
    /// - breedName: The breed name that the user wants to search for
    func requestBreedsNamed(_ breedName: String) async {
        
        //"https://api.thedogapi.com/v1/breeds?limit=1000&page=0"

        // https://api-dog-breeds.herokuapp.com/api/search?q=retriever 
        
        // Building the URL from its various components to neatly set up the query items
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.path = "api-dog-breeds.herokuapp.com/api/search"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "maxResults", value: "\(MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "startIndex", value: "\(currentRequestIndex * MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "q", value: breedName)
        ]
    
        guard let requestURL = searchURLComponents.url else { print("Invalid URL.")
            return
        }
        
        
        
        let urlRequest = URLRequest(url: requestURL)
        print(urlRequest)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Once we receive a response and the function begins executing again, we need to get our loading indicator to ssop animating
            DispatchQueue.main.async { [self] in
                self.indicator.stopAnimating()
            }
            
            // Once we have a response, we should parse the data
            
            let decoder = JSONDecoder()
            
            // The line of code below when we decode the data returns an array where the dogBreed properties for all items in the array are nil -> may be a problem with the way DogData has been structured
            let dogData = try decoder.decode([DogData].self, from: data) // dogData is an array of DogData
            
            
            // for loop to go through all the DogData items in the array
            print(dogData)
            for breeds in dogData {
                newBreeds.append(breeds)
                print(breeds) // test
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
        catch let error {
            print(error)
        }

    }
    
    /**
     This method will be called when the user hits enter or taps the search button after typing in the search field. It is also called when they tap cancel.
     */
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // When this
        newBreeds.removeAll()
        tableView.reloadData()
        
        guard let searchText = searchBar.text?.lowercased() else {
                    return
                }
        
                navigationItem.searchController?.dismiss(animated: true)
                indicator.startAnimating()

                Task {
                    URLSession.shared.invalidateAndCancel()
                    currentRequestIndex = 0
                    await requestBreedsNamed(searchText)
                }
        
        

    }


}
