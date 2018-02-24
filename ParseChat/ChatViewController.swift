//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Mario Martinez on 2/23/18.
//  Copyright © 2018 csumb. All rights reserved.
//

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
        
    }
    
    func fetchMessages() {
        let query = PFQuery(className: "Message")
        query.order(byDescending: "_created_at")
        
        query.findObjectsInBackground { ( messages: [PFObject]?, error: Error?) in
            if let mess = messages {
                print(mess)
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
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved")
            } else if let error = error {
                print("Problem saving message\(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.messages.count)
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let mess = messages[indexPath.row]
        
        print("Table function")
        print(messages)
        
        cell.messageLabel.text = mess["text"] as? String
        
        return cell
    }
    
    func onTimer() {
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
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
