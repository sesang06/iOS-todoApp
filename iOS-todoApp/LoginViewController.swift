//
//  LoginViewController.swift
//  iOS-todoApp
//
//  Created by 조세상 on 02/12/2018.
//  Copyright © 2018 조세상. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class LoginViewController : UIViewController {
    
    var emailTextField : UITextField!
    var passwordTextField : UITextField!
    var loginButton : UIButton!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewModelBinding()
        
    }
    
    func createViewModelBinding(){
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailIdViewModel.data)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.do(onNext: { [unowned self] in
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        
        }).subscribe(onNext: { [unowned self] in
            if self.viewModel.validateCredentials() {
                self.viewModel.loginUser()
            }
        }).disposed(by: disposeBag)
    }
    func createCallbacks(){
        viewModel.isSucess.asObservable()
            .bind{ value in
                NSLog("Succsessful")
            }.disposed(by: disposeBag)
        
        viewModel.errorMsg.asObservable()
            .bind{ errorMessage in
                NSLog("FailUre")
            }.disposed(by: disposeBag)
    }
}
