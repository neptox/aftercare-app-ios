//
//  UserProfileScreenViewController.swift
//  Aftercare
//
//  Created by Dimitar Grudev on 9/9/17.
//  Copyright © 2017 Dimitar Grudev. All rights reserved.
//

import Foundation
import UIKit

class UserProfileScreenViewController: UIViewController, ContentConformer {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var headerView: UIView?
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContentPadding: NSLayoutConstraint!
    
    //MARK: - Delegate
    
    var contentDelegate: ContentDelegate?
    
    //MARK: - Public
    
    var header: InitialPageHeaderView! {
        return headerView as! InitialPageHeaderView
    }
    
    //MARK: - fileprivates
    
    fileprivate var calculatedConstraints = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            if !calculatedConstraints {
                calculatedConstraints = true
                let topPadding = self.view.safeAreaInsets.top
                headerHeightConstraint.constant += topPadding
                let bottomPadding = self.view.safeAreaInsets.bottom
                bottomContentPadding.constant -= bottomPadding
            }
        }
    }
    
}

//MARK: - apply theme and appearance

extension UserProfileScreenViewController {
    
    func setup() {
        
        header.updateTitle(NSLocalizedString("My Profile", comment: ""))
        
        guard let data = UserDataContainer.shared.userInfo else { return }
        
        fullNameLabel.textColor = .white
        fullNameLabel.font = UIFont.dntLatoLightFont(size: UIFont.dntTitleFontSize)
        if let first = data.firstName {
            var fullName = first
            if let last = data.lastName {
                fullName += " " + last
            }
            fullNameLabel.text = fullName
        }
        
        emailLabel.textColor = .white
        emailLabel.font = UIFont.dntLatoLightFont(size: UIFont.dntLargeTextSize)
        if let email = data.email {
            emailLabel.text = email
        }
        
        addressLabel.textColor = .white
        addressLabel.font = UIFont.dntLatoLightFont(size: UIFont.dntLargeTextSize)
        var address = ""
        if let postal = data.postalCode {
            address += postal
        }
        if let city = data.city {
            address += " " + city
        }
        if let country = data.country {
            address += " " + country
        }
        
        ageLabel.textColor = .white
        ageLabel.font = UIFont.dntLatoLightFont(size: UIFont.dntLargeTextSize)
        if let age = data.birthDay {
            ageLabel.text = age.description
        }
        
        genderLabel.textColor = .white
        genderLabel.font = UIFont.dntLatoLightFont(size: UIFont.dntLargeTextSize)
        genderLabel.text = data.gender.rawValue
        
        if let image = UserDataContainer.shared.userAvatar {
            userAvatarImage.image = image
        }
        userAvatarImage.layer.cornerRadius = userAvatarImage.frame.size.width / 2
        userAvatarImage.layer.masksToBounds = true
        
        let themeManager = ThemeManager.shared
        themeManager.setDCBlueTheme(to: editProfileButton, ofType: .ButtonDefault)
    }
    
}

//MARK: - InitialPageHeaderViewDelegate

extension UserProfileScreenViewController: InitialPageHeaderViewDelegate {
    
    func mainMenuButtonIsPressed() {
        contentDelegate?.openMainMenu()
    }
    
}

//MARK: - IBActions

extension UserProfileScreenViewController {
    
    @IBAction func editButtonPressed(_ sender: Any) {
        let vcID = String(describing: EditUserProfileScreenViewController.self)
        contentDelegate?.requestLoadViewController(vcID, nil)
    }
    
}
