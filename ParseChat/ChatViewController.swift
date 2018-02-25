//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Mario Martinez on 2/23/18.
//  Copyright © 2018 csumb. All rights reserved.
//

//TODO: check username constrains

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var chatMessageField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        fetchMessages()
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fetchMessages), userInfo: nil, repeats: true)
        
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMessages()
        refreshControl.endRefreshing()
    }
    
    func fetchMessages() {
        let query = PFQuery(className: "Message")
        query.order(byDescending: "_created_at")
        query.includeKey("user")
        
        
        query.findObjectsInBackground { ( messages: [PFObject]?, error: Error?) in
            if let mess = messages {
                self.messages = mess
                
                self.tableView.reloadData()
            } else {
                print("Error receiving the messages")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButton(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage["user"] = PFUser.current()      // TODO: 
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message\(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let mess = messages[indexPath.row]
        
        if let user = mess["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        
        cell.messageLabel.text = mess["text"] as? String
        
        
        return cell
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
