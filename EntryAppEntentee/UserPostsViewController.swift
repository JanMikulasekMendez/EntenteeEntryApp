//
//  UserPostsViewController.swift
//  EntryAppEntentee
//
//  Created by Jan Mikulášek on 29.12.2021.
//

import UIKit

class UserPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    
    let closeButton = UIButton()
    let userImageView = UIImageView()
    let gradient = CAGradientLayer()
    let userNameLabel = UILabel()
    let userEmailLabel = UILabel()
    let postsCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    
    
    var portrait = [NSLayoutConstraint]()
    var landscape = [NSLayoutConstraint]()
    
    var userID = String()
    var user = Person()
    var userPosts = [Post]()
    var postsPerRow = CGFloat()

    //MARK: View Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.setImage(UIImage.init(systemName: "xmark.circle"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.tintColor = .black
        closeButton.contentMode = .scaleToFill
        closeButton.contentHorizontalAlignment = .fill
        closeButton.contentVerticalAlignment = .fill
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.systemBrown.cgColor]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint.zero
        view.layer.insertSublayer(gradient, at: 0)
        
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.backgroundColor = .clear
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        postsCollectionView.setCollectionViewLayout(layout, animated: true)
        postsCollectionView.register(UserPostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCell")
        
        userImageView.image = UIImage.init(systemName: "hourglass.circle")
        userImageView.tintColor = .black
        
        view.addSubview(closeButton)
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(userEmailLabel)
        view.addSubview(postsCollectionView)
        
        
        createAutoLayout()
        fetchUser()
    }
    
    //MARK: - UI Functions
    @objc func closeView() {
        self.dismissDetail()
    }
    
    
    //MARK: - AutoLayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
        userImageView.makeRounded()
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
                createAutoLayout()
        self.postsCollectionView.reloadData()
        }
    
    func createAutoLayout() {
        NSLayoutConstraint.deactivate(portrait)
        NSLayoutConstraint.deactivate(landscape)
        
        portrait
        = closeButton.anchorList(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        + userImageView.anchorList(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0),size: .init(width: 150, height: 150))
        
        + userNameLabel.anchorList(top: userImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,centerX: view.safeAreaLayoutGuide.centerXAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        + userEmailLabel.anchorList(top: userNameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor)
        
        + postsCollectionView.anchorList(top: userEmailLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
        
        landscape
        = closeButton.anchorList(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        
        + userImageView.anchorList(top: closeButton.topAnchor, leading: closeButton.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 50, bottom: 0, right: 0),size: .init(width: 50, height: 50))
        
        + userNameLabel.anchorList(top: closeButton.topAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: nil,centerY: userImageView.centerYAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        
        + userEmailLabel.anchorList(top: closeButton.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, centerY: userImageView.centerYAnchor)
        
        + postsCollectionView.anchorList(top: userEmailLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0))

        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(landscape)
            postsPerRow = 3
        } else {
            NSLayoutConstraint.activate(portrait)
            postsPerRow = 2
        }
        userImageView.makeRounded()
    }
    
    //MARK: - API Calls
    private func fetchUser() {
        let url = URL(string: "https://dummyapi.io/data/v1/user/" + userID)!
        var request = URLRequest(url: url)
        request.setValue("61c9c2b40a88067427c1b932", forHTTPHeaderField: "app-id")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
          guard error == nil else { return }
            if let data = data {
                
                if let jsonString = String(data: data, encoding: .utf8)
                {
                    self.decodeUser(inputData: jsonString)
                }
            }
        }.resume()
    }
    
    private func decodeUser(inputData: String) {
        let jsonData = Data(inputData.utf8)
        let decoder = JSONDecoder()

        do {
            let user = try decoder.decode(Person.self, from: jsonData)
            DispatchQueue.main.async {
                self.user = user
                self.loadUserData()
            }
        } catch {
            print(error.localizedDescription)
            print(String(describing: error))
        }
    }
    
    private func fetchUserPosts() {
        let url = URL(string: "https://dummyapi.io/data/v1/user/" + userID + "/post?limit=7")!
        var request = URLRequest(url: url)
        request.setValue("61c9c2b40a88067427c1b932", forHTTPHeaderField: "app-id")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
          guard error == nil else { return }
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8)
                {
                    self.decodeUserPosts(inputData: jsonString)
                }
            }
        }.resume()
    }
    
    private func decodeUserPosts(inputData: String) {
        let jsonData = Data(inputData.utf8)
        let decoder = JSONDecoder()

        do {
            let posts = try decoder.decode(PostData.self, from: jsonData)
            DispatchQueue.main.async {
                
                self.userPosts = posts.data
                self.postsCollectionView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
            print(String(describing: error))
        }
    }
    
    func loadUserData() {
        
        userImageView.downloaded(from: user.picture!)
        userNameLabel.text = user.firstName! + " " + user.lastName!
        userEmailLabel.text = user.email
        fetchUserPosts()
        
    }
    
    
    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! UserPostCollectionViewCell
        
        let postDateString = userPosts[indexPath.row].publishDate!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let postDate = dateFormatter.date(from:postDateString)
        
        dateFormatter.dateFormat = "d.M, YYYY, HH:mm:ss"
        cell.postImage.downloaded(from: userPosts[indexPath.row].image!)
        cell.dateLabel.text = dateFormatter.string(from: postDate!)
        cell.thumbsUpLabel.text = "\(userPosts[indexPath.row].likes ?? 0)"
        cell.layoutIfNeeded()
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/postsPerRow
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - Data Structures
    struct Person : Codable {
        var id: String?
        var title: String?
        var firstName: String?
        var lastName: String?
        var gender: String?
        var email: String?
        var dateOfBirth: String?
        var registerDate: String?
        var phone: String?
        var picture: URL?
        var location: Location?
    }
    
    struct Location : Codable {
        var street: String?
        var city: String?
        var state: String?
        var country: String?
        var timezone: String?
    }
    
    
    
    
    struct PostData: Codable {
        var data: [Post]
        var total: Int
        var page: Int
        var limit: Int
    }
    
    struct Post : Codable {
    var id: String?
    var text: String?
    var image: URL?
    var likes: Int?
    var tags: [String]?
    var publishDate: String?
    var owner: Person?
    }
    


}
