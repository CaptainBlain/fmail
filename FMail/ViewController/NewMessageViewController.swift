//
//  NewMessageViewController.swift
//  FMail
//
//  Created by Blain Ellis on 24/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit


protocol NewMessageViewControllerDelegate: AnyObject {
    func newMessageViewControllerDidSuccessfullyPost(_ post: Post)
    func newMessageViewControllerDidSuccessfullyComment(_ comment: Comment, onPost post: Post)
    func newMessageViewControllerDidSuccessfullyComment(_ newComment: Comment, on previousComment: Comment)
}
class NewMessageViewController: UIViewController {
    
    var post: Post?
    var comment: Comment?
    weak var delegate: NewMessageViewControllerDelegate?
    
    private var tableview: UITableView!
    private var subject = ""
    private var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        //Tableview
        tableview = UITableView(frame: self.view.frame)
        tableview.dataSource = self
        tableview.delegate = self;
        tableview.register(UINib(nibName: "MessageTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: MessageTextFieldTableViewCell.identifier)
        tableview.register(UINib(nibName: "MessageTextViewTableViewCell", bundle: nil), forCellReuseIdentifier: MessageTextViewTableViewCell.identifier)
        self.view.addSubview(tableview)
        
        if let post = post {
            subject = "Re: \(post.subject)"
        }
        
        //Buttons
        self.title = ""
        self.navigationItem.hidesBackButton = true
        let closeButton = UIBarButtonItem(image: UIImage(named: "close")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), style: UIBarButtonItem.Style.plain, target: self, action: #selector(NewMessageViewController.close(sender:)))
        closeButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = closeButton
        let sendButton = UIBarButtonItem(title: "Send", style: UIBarButtonItem.Style.plain, target: self, action: #selector(NewMessageViewController.send(sender:)))
        sendButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = sendButton
        
      
    }
    
    @objc
    func send(sender: UIBarButtonItem) {
        
        if let comment = comment {
            
            self.sendCommentComment(comment: comment, subject: subject, content: content) { (error, newComment) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                if let newComment = newComment {
                    self.navigationController?.dismiss(animated: true, completion: {
                        self.delegate?.newMessageViewControllerDidSuccessfullyComment(newComment, on: comment)
                    })
                }
            }           
        }
        else if let post = post {
            self.sendPostComment(post: post, subject: subject, content: content) { (error, comment) in
                if let error = error {
                    print(error)
                    return
                }
                
                if let comment = comment {
                    self.navigationController?.dismiss(animated: true, completion: {
                        self.delegate?.newMessageViewControllerDidSuccessfullyComment(comment, onPost: post)
                    })
                }
            }
        }
        else {
        
            self.sendPost(subject: subject, content: content) { (error, post) in
                if let error = error {
                    print(error)
                    return
                }
                
                if let post = post {
                    self.navigationController?.dismiss(animated: true, completion: {
                        self.delegate?.newMessageViewControllerDidSuccessfullyPost(post)
                    })
                }
            }
        }
    }
    
    @objc
    func close(sender: UIBarButtonItem) {
        
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
   

}

extension NewMessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 3
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 0;
        switch indexPath.row {
        case 0:
            height = 60
        case 1:
            height = 60;
        case 2:
            height = tableView.frame.size.height - 120;
        default:
            height = 0
        }
        return height;
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextFieldTableViewCell.identifier, for: indexPath) as! MessageTextFieldTableViewCell
            cell.delegate = self;
            cell.indexPath = indexPath
            cell.messageTitle = "To:"
            cell.messageString = "all@fmail.com"
            if let post = post {
                cell.messageString = post.ownerUsername + "@fmail.com"
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextFieldTableViewCell.identifier, for: indexPath) as! MessageTextFieldTableViewCell
            cell.delegate = self;
            cell.indexPath = indexPath
            cell.messageTitle = "Subject:"
            cell.messagePlaceholder = "What do you want to say?"
            cell.messageString = subject
            cell.captialType = UITextAutocapitalizationType.sentences
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextViewTableViewCell.identifier, for: indexPath) as! MessageTextViewTableViewCell
            cell.delegate = self;
            cell.indexPath = indexPath
            cell.messagePlaceholder = "Add some extra details?"
            cell.messageString = content
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextFieldTableViewCell.identifier, for: indexPath) as! MessageTextFieldTableViewCell
            cell.delegate = self;
            cell.indexPath = indexPath
            cell.messageTitle = ""
            cell.messageString = ""
            return cell
        }
        
    }
    
}

extension NewMessageViewController: UITableViewDelegate {
    
}

extension NewMessageViewController: MessageTextFieldTableViewCellDelegate {
    
    func messageTextFieldTableViewCellBeginEditing(forIndexPath indexPath: IndexPath) {
        
    }
    func messageTextFieldTableViewDidUpdateText(text: String, forIndexPath indexPath: IndexPath) {
        
        //Subject
        if indexPath.row == 1 {
            subject = text
        }
        
    }
}

extension NewMessageViewController: MessageTextViewTableViewCellDelegate {
    
    func messageTextViewTableViewCellBeginEditing(forIndexPath indexPath: IndexPath) {
        
    }
    func messageTextViewTableViewCellDidUpdateText(text: String, forIndexPath indexPath: IndexPath) {
        //Content
        if indexPath.row == 2 {
            content = text
        }
    }
}

//Mark: - Network
extension NewMessageViewController {
    
    func sendPost(subject: String, content: String, completion: @escaping (_ error: BMError?, _ post: Post?)->()) {
        
        if subject.isEmpty {
            
            completion(BMError(0, "Please enter a subject"), nil);
        }
        
        if let user = User.getUser(context: DatabaseController.shared.persistentContainer.viewContext) {
             
            AsynPosts.sendPost(forUser: user, subject: subject, content: content) { (error, post) in
                if let error = error {
                    completion(error, nil)
                    return
                }
                completion(nil, post)
            }
        }
        else {
            //Attempt to log the user in
            AsyncAuth.loginUser { (error, mappedUser) in
                  completion(BMError(0, "Unable to create post, please try again later"), nil);
            }
           
        }
    }
    
    func sendPostComment(post: Post, subject: String, content: String, completion: @escaping (_ error: BMError?, _ comment: Comment?)->()) {
        
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
                  completion(BMError(0, "Unable to create post, please try again later"), nil);
            }
           
        }
    }
    
    func sendCommentComment(comment: Comment, subject: String, content: String, completion: @escaping (_ error: BMError?, _ comment: Comment?)->()) {
        
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
                  completion(BMError(0, "Unable to create post, please try again later"), nil);
            }
           
        }
    }
    
}

extension NewMessageViewController {
    
    // MARK: - KeyboardWill Delegate
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var tableViewFrame = self.tableview.frame
            tableViewFrame.size.height = self.view.frame.size.height - keyboardSize.height - 60
            self.tableview.frame = tableViewFrame
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
            var tableViewFrame = self.tableview.frame
            tableViewFrame.origin.x = 0
            tableViewFrame.origin.y = 0
            tableViewFrame.size.width = self.view.frame.size.width
            tableViewFrame.size.height = self.view.frame.size.height
            self.tableview.frame = tableViewFrame
            
        }
    }
    
}
