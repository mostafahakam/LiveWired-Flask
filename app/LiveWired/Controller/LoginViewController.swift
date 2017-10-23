//
//  LoginController.swift
//  LiveWired
//
//  Created by Daniel Chau on 2017-10-18.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    let inputContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
        
    }()
    
    lazy var logRegButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 255, g: 136, b: 77)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleLogin(){
        guard let email = emailTextField.text, let password = PassTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                self.emailTextField.text = ""
                self.PassTextField.text = ""
                self.credentialMessage.alpha = 1
                self.view.endEditing(true)
                print(error ?? "User email or password is nil")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else {
            handleRegister()
        }
    }
    
    @objc func handleRegister(){
        
        guard let email = emailTextField.text, let password = PassTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                print(error ?? "User email or password is nil")
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://livewire-4d161.firebaseio.com/")
            let usersRef = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err ?? "User's Name is nil")
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            })
            
        })
        print(123)
    }
    
    
    
    let nameTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let nameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let emailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let credentialMessage: UILabel = {
        let cm = UILabel()
        cm.textAlignment = NSTextAlignment.center
        cm.text = "credentials are incorrect"
        cm.textColor = UIColor.white
        cm.font = UIFont.systemFont(ofSize: 15)
        cm.translatesAutoresizingMaskIntoConstraints = false
        return cm
    }()
    
    
    let PassTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
        
    }()
    
//    let profileImageView: UIImageView = {
//        let img = UIImageView()
//        img.image = UIImage(named: "Jouska")
//        img.translatesAutoresizingMaskIntoConstraints = false
//        img.contentMode = .scaleAspectFill
//        return img
//    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    let imageView: UIImageView = {
        let image    = UIImage(named: "Logo")
        let imageView = UIImageView(image: image!)
        return imageView
    }()
    
    @objc func handleLoginRegisterChange() {
        self.emailTextField.text = ""
        self.PassTextField.text = ""
        self.nameTextField.text = ""
        credentialMessage.alpha = 0
        
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        logRegButton.setTitle(title, for: .normal)
        
        inputsContainerViewHeightAnchor?.isActive = false
        inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant:  loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        emailTextField.isHidden = false
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = PassTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        PassTextField.isHidden = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 77, g: 77, b: 77)
        
        //instantiating the input viewer
        view.addSubview(inputContainerView)
        view.addSubview(logRegButton)
        view.addSubview(imageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(credentialMessage)
//        view.addSubview(profileImageView)
        
        setupImage()
        
        setupInputContainerView()
        setupLogRegButton()
        setupLoginRegisterSegmentedControll()
        setupCredentialMessage()
        
//        setupPorifleImageView()
    }
    
    func setupCredentialMessage() {
        credentialMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        credentialMessage.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 60).isActive = true
        credentialMessage.alpha = 0
    }
    
    func setupLoginRegisterSegmentedControll() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupImage(){
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.frame = CGRect(x: 0, y: 85, width: (self.view.frame.size.width), height: (self.view.frame.size.width*(1/3)))
    }
    
//    func setupPorifleImageView() {
//        //Constraints :  need x,y, width and height
//        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        profileImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
//    }
    
    func setupLogRegButton(){
        
        //Constraints :  need x,y, width and height
        logRegButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logRegButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        
        //how wide
        logRegButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        logRegButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputContainerView() {
        
        //Constraints :  need x,y, width and height
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true;
        
        
        
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparator)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparator)
        inputContainerView.addSubview(PassTextField)
        
        
        //Constraints :  need x,y, width and height
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        //Constraints :  need x,y, width and height
        nameSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //Constraints :  need x,y, width and height
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        
        //Constraints :  need x,y, width and height
        emailSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        //Constraints :  need x,y, width and height
        PassTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        PassTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        PassTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        passwordTextFieldHeightAnchor = PassTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
