//
//  UserListViewController.swift
//  EntryAppEntentee
//
//  Created by Jan Mikulášek on 27.12.2021.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    let titleLabel = UILabel()
    let userTableView = UITableView()
    let gradient = CAGradientLayer()
    
    var showUsers = Int()
    var endReached = Bool()
    
    var personList = [Person]()
    var portrait = [NSLayoutConstraint]()
    var landscape = [NSLayoutConstraint]()

    
    //MARK: - View init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Users"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(80)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        		
        userTableView.backgroundColor = .clear
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.register(UserListTableViewCell.self, forCellReuseIdentifier: "PersonCell")
        userTableView.estimatedRowHeight = 80
        userTableView.rowHeight = UITableView.automaticDimension
        view.addSubview(userTableView)
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.systemBrown.cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
        
        showUsers = 10
        
        createAutoLayout()
        fetch()
        
    }
    
    //MARK: AutoLayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
                createAutoLayout()
        }
    
    private func createAutoLayout() {
        NSLayoutConstraint.deactivate(portrait)
        NSLayoutConstraint.deactivate(landscape)
        
        portrait
        = titleLabel.anchorList(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        + userTableView.anchorList(top: titleLabel.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 50, left: 50, bottom: 0, right: 50))
        
        landscape
        = titleLabel.anchorList(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        + userTableView.anchorList(top: titleLabel.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(landscape)
        } else {
            NSLayoutConstraint.activate(portrait)
        }
    }
    
    
    //MARK: - API functions
    private func fetch() {
        let url = URL(string: "https://dummyapi.io/data/v1/user?limit=" + String(showUsers))!
        var request = URLRequest(url: url)
        request.setValue("61c9c2b40a88067427c1b932", forHTTPHeaderField: "app-id")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
          guard error == nil else { return }
          //guard let data = data, let response = response else { return }
            if let data = data {
                
                if let jsonString = String(data: data, encoding: .utf8)
                {
                    self.decode(inputData: jsonString)
                    self.endReached = false
                }
            }
        }.resume()
    }
    
    private func decode(inputData: String) {
        let jsonData = Data(inputData.utf8)
        let decoder = JSONDecoder()
        do {
            let people = try decoder.decode(PersonData.self, from: jsonData)
            DispatchQueue.main.async {
                self.personList = people.data
                self.userTableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
            print(String(describing: error))
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        personList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! UserListTableViewCell
        cell.selectionStyle = .none
        cell.firstNameLabel.text = personList[indexPath.row].firstName
        cell.lastNameLabel.text = personList[indexPath.row].lastName
        cell.titleLabel.text = personList[indexPath.row].title
        cell.userImage.downloaded(from: personList[indexPath.row].picture)
        
        cell.layoutIfNeeded()

           return cell
    }
    
    
    // Navigate to User Screen and pass data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = UserPostsViewController()
        VC.userID = personList[indexPath.row].id
        self.presentDetail(VC)
    }
    
    // Reached end of the table to load more users
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            
            if endReached == false {
                endReached = true
                showUsers += 10
                fetch()
            }
            
        }
    }
    
    //MARK: - Data Structures
    struct PersonData: Codable {
        var data: [Person]
        var total: Int
        var page: Int
        var limit: Int
    }


    struct Person: Codable {
        var id: String
        var title: String
        var firstName: String
        var lastName: String
        var picture: URL
    }
}
