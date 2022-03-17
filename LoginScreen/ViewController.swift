//
//  ViewController.swift
//  LoginScreen
//
//  Created by Michael Worden on 3/16/22.
//

import UIKit
import LocalAuthentication


class ViewController: UIViewController {

	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var blockImage: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		blockImage.transform = CGAffineTransform(rotationAngle: 3.1414159265)
		
		loginButton.layer.backgroundColor = UIColor(red: 207/255, green: 80/255, blue: 84/255, alpha: 1).cgColor
		loginButton.layer.cornerRadius = 22
	}
	
	@IBAction func loginButtonPressed(_ sender: Any) {
		//
		let localAuthenticationContext = LAContext()
		var authorizationError: NSError?
		let authReason = "Authentication required to Login"
		
		if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError)
		{
			localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: authReason)
			{
				success, evaluateError in
				if success
				{
					print("Successfully logged in via TouchID")
					DispatchQueue.main.async {
						self.performSegue(withIdentifier: "loggedIn", sender: nil)
					}
				}
				else
				{
					guard let error = evaluateError else {
						return
					}
					print (error)
				}
			}
			
		}
		else  // Can't log in with biometrics
		{
			guard let error = authorizationError else {
				return
			}
			print (error)
		}
	}
	
	
}

