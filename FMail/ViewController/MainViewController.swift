//
//  MainViewController.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit
import SideMenu

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private var posts = [Post]()
    private var user: User?
    private var page = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        updateMenus()
        handleUserPosts()
        
        //TableView
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(getPosts), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: PostTableViewCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //didPressNewMailButton(nil)
    }
    
    @IBAction func didPressNewMailButton(_ sender: UIBarButtonItem?) {
        
        let vc = NewMessageViewController()
        vc.delegate = self
        let navCon = UINavigationController(rootViewController: vc)
        self.present(navCon, animated: true) {
            
        }
    }    
}

extension MainViewController: NewMessageViewControllerDelegate {
    func newMessageViewControllerDidSuccessfullyPost(_ post: Post) {
        self.posts.insert(post, at: 0)
        self.tableView.reloadData()
    }
    func newMessageViewControllerDidSuccessfullyComment(_ comment: Comment, onPost post: Post) {
        
    }
    func newMessageViewControllerDidSuccessfullyComment(_ comment: Comment, on previousComment: Comment) {
        
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = PostViewController()
        vc.post = posts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Side Menu
extension MainViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? UISideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    
    private func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        //SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    
    
    @IBAction private func changeControl(_ control: UIControl) {
        
        updateMenus()
    }
    
    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }
    
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        return .menuSlideIn
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.backgroundColor = UIColor.white
        presentationStyle.onTopShadowOpacity = 1.0
        presentationStyle.presentingEndAlpha = 0.4
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height) * CGFloat(0.8)
        
        settings.blurEffectStyle = nil
        settings.statusBarEndAlpha = 0
        
        return settings
    }
}

//MARK: - UISideMenuNavigationControllerDelegate
extension MainViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}


//MARK: - Network Calls
extension MainViewController {
    
    func handleUserPosts() {
        getUser(completion: { (error, user) in
            if let error = error {
                print(error)
                return
            }
            
            self.user = user
            self.getPosts()
        })
    }
    
    @objc
    func getPosts() {
        page = 0
        self.getPostsforUser(user: user!, forPage: page, completion: { (error, posts) in
            self.refreshControl.endRefreshing()
            if let error = error {
                print(error)
                return
            }
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            }
        })
    }
    
    func getUser(completion: @escaping (_ error: BMError?, _ user: User?)->()) {
        
        if let user = User.getUser(context: DatabaseController.shared.persistentContainer.viewContext) {
             completion(nil, user)
        }
        else {
            AsyncAuth.registerUser { (error) in
                if let error = error {
                    completion(error, nil)
                    return
                }
                AsyncAuth.loginUser { (error, mappedUser) in
                    if let error = error {
                        completion(error, nil)
                        return
                    }
                    
                    if let mappedUser = mappedUser {
                        User.createUser(fromMapper: mappedUser)
                        
                        completion(nil, User.getUser(context: DatabaseController.shared.persistentContainer.viewContext))
                    }
                }
            }
        }
    }
    
    func getPostsforUser(user: User, forPage page: Int, completion: @escaping (_ error: BMError?, _ posts: [Post]?)->()) {
        
        AsynPosts.getPosts(forUser: user, forPage: page, andType: PostType.latest) { (error, postsMapperArray) in
            
            if let error = error {
                completion(error, nil)
                return
            }
            
            var posts = [Post]()
            if let postsMapperArray = postsMapperArray {
                
                for postMapper in postsMapperArray {
                    posts.append(Post(postMapper))
                }
            }
            completion(nil, posts)
            
        }
        
    }
    
}
