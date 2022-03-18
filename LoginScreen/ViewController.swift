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
	
	@IBOutlet weak var loginImage: UIImageView!
	
	@IBOutlet weak var loginPrompt: UILabel!
	
	@IBOutlet weak var loginHint: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		blockImage.transform = CGAffineTransform(rotationAngle: 3.1414159265)
		
		loginButton.layer.backgroundColor = UIColor(red: 207/255, green: 80/255, blue: 84/255, alpha: 1).cgColor
		loginButton.layer.cornerRadius = 22
		updateLoginScreen()
	}
	
	func updateLoginScreen() {
		
		var loginMethod = "email"
		let localAuthenticationContext = LAContext()
		print(localAuthenticationContext.biometricType)
		
		switch localAuthenticationContext.biometricType {
		case .touchID:
			print("TouchID Capable")
			loginImage.image = UIImage(named: "Touch_ID_logo")
			loginMethod = "TouchID"
		case .faceID:
			print("FaceID Capable")
			loginImage.image = UIImage(named: "Face_ID_logo")
			loginMethod = "FaceID"
		case .none:
			print ("No Biometrics present")
			loginImage.image = UIImage(named: "login-rounded-right--v1")
			loginMethod = "email"
			
		}
		loginImage.transform = CGAffineTransform(scaleX: -1, y: 1)
		loginPrompt.text = "Sign in with \(loginMethod)"
		loginHint.text = "Use \(loginMethod) for fast and easy login"
		
	}
	@IBAction func loginButtonPressed(_ sender: Any) {
		//
		//let bmType = self.biometricType
		
		attemptBiometricLogin()
		
		
	}
	
	func attemptBiometricLogin () {
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


extension LAContext {
	enum BiometricType: String {
		case none
		case touchID
		case faceID
	}

	var biometricType: BiometricType {
		var error: NSError?

		guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
			return .none
		}

		if #available(iOS 11.0, *) {
			switch self.biometryType {
			case .none:
				return .none
			case .touchID:
				return .touchID
			case .faceID:
				return .faceID
			@unknown default:
				return .none
				//#warning("Handle new Biometric type")
			}
		}
		
		return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
	}
}
