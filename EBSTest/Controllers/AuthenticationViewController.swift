//
//  AuthenticationViewController.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 20.04.2022.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var googleLoginButton : UIButton!
    
    let signInConfig = GIDConfiguration.init(clientID: "465509666566-0v2f61hkbacml45cmgap1m6gr78lol63.apps.googleusercontent.com")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        if let token = AccessToken.current,
           !token.isExpired {
         
        } else {
            let loginButton = FBLoginButton(frame: CGRect(x: 0, y: 0, width: 250, height: 60))
            loginButton.center = view.center
            loginButton.permissions = ["public_profile", "email"]
            view.addSubview(loginButton)
        }
    }
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            
        }
    }
    private func configureNavigationBar() {
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        navigationItem.titleView = imageView
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(popVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(pushFavoriteVC))
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    @objc func pushFavoriteVC() {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
}

