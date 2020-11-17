//
//  PostViewController.swift
//  FMail
//
//  Created by Blain Ellis on 25/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func newMessageViewControllerDidSuccessfullyPost(_ post: Post);
}

class PostViewController: UIViewController {
    
    var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    var post: Post!
    weak var delegate: NewMessageViewControllerDelegate?
    
    private var comments = [Comment]()
    private var subject = ""
    private var content = ""
    private let dateFormatter = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        //Tableview
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableView.Style.grouped)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView.dataSource = self
        tableView.delegate = self;

        tableView.register(UINib(nibName: "MainPostTableViewCell", bundle: nil), forCellReuseIdentifier: MainPostTableViewCell.identifier)
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: CommentTableViewCell.identifier)
        self.view.addSubview(tableView)
        
        refreshControl.addTarget(self, action: #selector(getComments), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        //Buttons
        self.title = ""
        self.navigationItem.hidesBackButton = true
        let closeButton = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), style: UIBarButtonItem.Style.plain, target: self, action: #selector(PostViewController.close(sender:)))
        closeButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = closeButton
        
        getComments()
    }
       
    @objc
    func close(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }

}

extension PostViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return self.comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 0;
        switch indexPath.section {
        case 0:
            let titleHeight: CGFloat = post.subject.getStringSize(for: UIFont.robotoBold(size: 17), andWidth: tableView.frame.size.width - 24).height
            let usernameHeight: CGFloat = 17
            let contentHeight: CGFloat = post.content.getStringSize(for: UIFont.robotoLight(size: 17), andWidth: tableView.frame.size.width - 24).height
            let buttonHeight: CGFloat = 30
            let spacing: CGFloat  = 12 + 4 + 4 + 4 + 12
            height = titleHeight + usernameHeight + contentHeight + buttonHeight + spacing
        default:
            
            height = 0
            
            let darkFont = UIFont.robotoBold(size: 17)
            let comment = comments[indexPath.section-1]
            
            let fromHeight: CGFloat = "From: \(comment.ownerUsername)".getStringSize(for: darkFont, andWidth: tableView.frame.size.width - 24).height
       
            var sentHeight: CGFloat = 0
            if let createdDate = comment.createdDate {
                dateFormatter.dateStyle = .full
                dateFormatter.timeStyle = .medium
                let dateString = dateFormatter.string(from: createdDate as Date)
                sentHeight = "Sent: \(dateString)".getStringSize(for: darkFont, andWidth: tableView.frame.size.width - 24).height            
            }
            var toHeight: CGFloat = 0
            if let to = comment.to {
                toHeight = "To: \(to)".getStringSize(for: darkFont, andWidth: tableView.frame.size.width - 24).height
            }
            
            let subjectHeight: CGFloat = "Subject: \(comment.subject)".getStringSize(for: darkFont, andWidth: tableView.frame.size.width - 24).height
            let contentHeight: CGFloat = comment.content.getStringSize(for: UIFont.robotoLight(size: 17), andWidth: tableView.frame.size.width - 36).height
    
            
            let spacing: CGFloat  = 12 + 3 + 3 + 3 + 12 + 16 + 12 + 28
            
            height = fromHeight + sentHeight + toHeight + subjectHeight + contentHeight + spacing
            
        }
        return height;
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainPostTableViewCell.identifier, for: indexPath) as! MainPostTableViewCell
            cell.delegate = self
            cell.post = post
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
            cell.comment = comments[indexPath.section-1]
            cell.delegate = self
            return cell
        }

    }
    
}

extension PostViewController: UITableViewDelegate {
    
}

extension PostViewController: CommentTableViewCellDelegate {
    func commentTableViewCelllDidPressReply(forComment comment: Comment) {
        let vc = NewMessageViewController()
        vc.delegate = self
        vc.comment = comment
        let navCon = UINavigationController(rootViewController: vc)
        self.present(navCon, animated: true) {
            
        }
    }
}

extension PostViewController: MainPostTableViewCellDelegate {
    
    func mainPostTableViewCellDidPressReply(forPost post: Post) {
        
        let vc = NewMessageViewController()
        vc.delegate = self
        vc.post = post
        let navCon = UINavigationController(rootViewController: vc)
        self.present(navCon, animated: true) {
            
        }
    }
}

extension PostViewController: NewMessageViewControllerDelegate {
    
    func newMessageViewControllerDidSuccessfullyPost(_ post: Post) {
        
    }
    func newMessageViewControllerDidSuccessfullyComment(_ comment: Comment, onPost post: Post) {
        getComments()
    }
    func newMessageViewControllerDidSuccessfullyComment(_ newComment: Comment, on previousComment: Comment) {
        
        //Reddit stays at the comment and adds your comment immediately to it.
    }
}


//Mark: - Network
extension PostViewController {
    
    @objc
    func getComments() {
        
        getCommentsForPost(self.post) { (error, comments) in
            self.refreshControl.endRefreshing()
            if let error = error {
               print(error)
                return
            }
            
            if let comments = comments {
                self.comments = comments
                
                self.tableView.reloadData()
            }
        }
        
    }

    func getCommentsForPost(_ post: Post, completion: @escaping (_ error: BMError?, _ comments: [Comment]?)->()) {
        
        if let user = User.getUser(context: DatabaseController.shared.persistentContainer.viewContext) {
            AsynComments.getComments(forUser: user, forPost: post) { (error, comments) in
                if let error = error {
                    completion(error, nil)
                    return
                }
                completion(nil, comments)
            }
        }
        else {
            //Attempt to log the user in
            AsyncAuth.loginUser { (error, mappedUser) in
                completion(BMError(0, "Unable to get comments, please try again later"), nil);
            }
        }
    }
    

    func sendComment(post: Post, subject: String, content: String, completion: @escaping (_ error: BMError?, _ comment: Comment?)->()) {
        
        if subject.isEmpty {
            
            completion(BMError(0, "Please enter a subject"), nil);
        }
        
        if let user = User.getUser(context: DatabaseController.shared.persistentContainer.viewContext) {
            
            AsynComments.sendComment(forUser: user, post: post, subject: subject, content: content) { (error, comment) in
                if let error = error {
                    completion(error, nil)
                    return
                }
                completion(nil, comment)
            }
            
        }
        else {
            //Attempt to log the user in
            AsyncAuth.loginUser { (error, mappedUser) in
                completion(BMError(0, "Unable to send comment, please try again later"), nil);
            }
            
        }
    }
    
    func sendComment(comment: Comment, subject: String, content: String, completion: @escaping (_ error: BMError?, _ comment: Comment?)->()) {
        
        if subject.isEmpty {
            
            completion(BMError(0, "Please enter a subject"), nil);
        }
        
        if let user = User.getUser(context: DatabaseController.shared.persistentContainer.viewContext) {
            
            AsynComments.sendComment(forUser: user, comment: comment, subject: subject, content: content) { (error, comment) in
                if let error = error {
                    completion(error, nil)
                    return
                }
                completion(nil, comment)
            }
            
        }
        else {
            //Attempt to log the user in
            AsyncAuth.loginUser { (error, mappedUser) in
                completion(BMError(0, "Unable to send comment, please try again later"), nil);
            }
            
        }
    }
}

extension PostViewController {
    
    // MARK: - KeyboardWill Delegate
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var tableViewFrame = self.tableView.frame
            tableViewFrame.size.height = self.view.frame.size.height - keyboardSize.height - 60
            self.tableView.frame = tableViewFrame
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
            var tableViewFrame = self.tableView.frame
            tableViewFrame.origin.x = 0
            tableViewFrame.origin.y = 0
            tableViewFrame.size.width = self.view.frame.size.width
            tableViewFrame.size.height = self.view.frame.size.height
            self.tableView.frame = tableViewFrame
            
        }
    }
    
}
