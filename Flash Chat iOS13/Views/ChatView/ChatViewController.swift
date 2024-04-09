//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import NotificationCenter
import Combine

class ChatViewController: BaseViewController, UITableViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageTextfield: UITextField!
    
    //MARK: - Properties
    var chatViewModel: ChatViewModelProtocol?
    private var cancellables: [AnyCancellable] = []
    
    //MARK: - LifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        title = Constants.flashChatLogoName
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        setupNavigationLogoutButton()
        keyboardNotifications()
        setUpBinders()
    }
    
    //MARK: - Private Methods
    private func setUpBinders() {
        chatViewModel?.messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] messages in
            guard let self,
                  let messages else { return }
            
            self.handleMessagesLoaded(messages)
        }.store(in: &cancellables)
        
        chatViewModel?.isMessageSent.sink { [weak self] isSend in
            guard let self else { return }
            
            self.messageTextfield.placeholder = isSend ? Constants.writeMessagePlaceholder : Constants.messageNotSendPlaceholder
            self.messageTextfield.text = Constants.blankString
        }.store(in: &cancellables)
        
        chatViewModel?.logOutConfirmation.dropFirst().sink { [weak self] isUserLogedOut in
            guard isUserLogedOut else { return }
            
            self?.navigationController?.popToRootViewController(animated: true)
        }.store(in: &cancellables)
    }
    
    @objc private func clickLogOutButton() {
        chatViewModel?.logOutUser()
    }
    
    private func handleMessagesLoaded(_ messages: [Message]) {
        guard !messages.isEmpty else { return }

            self.tableView.reloadData()
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    private func setDelegates() {
        messageTextfield.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavigationLogoutButton() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: Constants.logOutBarButton,
                                                              style: .done,
                                                              target: self,
                                                              action: #selector(clickLogOutButton))]
    }
    
    //MARK: - IBActions
    @IBAction private func sendPressed(_ sender: UIButton) {
        guard let messageBody = messageTextfield.text else { return }
        
        chatViewModel?.sendNewMessage(messageBody: messageBody)
    }
    
}

//MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        view.frame.origin.y = -keyboardRect.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    private func keyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}

//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let messagesCount = chatViewModel?.getCurrentMessagesCount() else { return 0 }
        
        return messagesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? MessageCell,
              let cellData = chatViewModel?.senderMessageAndCellDetails(indexPath.row)
        else {
            return UITableViewCell()
        }
        
        cell.setUpCellComponents(messageLabelText: cellData.senderTextMessage,
                                 messageLabelTextColor: UIColor(named: cellData.messageCellModel.messageLableTextColor) ?? UIColor(),
                                 messageBubbleBgColor: UIColor(named: cellData.messageCellModel.messageBubbleBgColor) ?? UIColor(),
                                 avatarImage: cellData.messageCellModel.avatarImageViewHide,
                                 rightAvatarImage: cellData.messageCellModel.rightAvatarImageHide)

        return cell
    }

}

