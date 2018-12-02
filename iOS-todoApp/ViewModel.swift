//
//  ViewModel.swift
//  iOS-todoApp
//
//  Created by 조세상 on 01/12/2018.
//  Copyright © 2018 조세상. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
struct Model {
    let repoName : String
    let repoURL : String
}
class LoginModel {
    var email = ""
    var password = ""
    convenience init(email: String, password: String){
        self.init()
        self.email = email
        self.password = password
    }
}
protocol  ValidationViwModel {
    var errorMessage : String { get }
    var data : Variable<String> { get set }
    var errorValue : Variable<String?> { get }
    
    func validateCredentials() -> Bool
}

class PasswordViewModel : ValidationViwModel {
    var errorMessage: String = "Please enter a valid password"
    var data : Variable<String> = Variable("")
    
    var errorValue: Variable<String?> = Variable("")
    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (6, 15)) else {
            errorValue.value = errorMessage
            return false
        }
        errorValue.value = ""
        return true
    }
    func validateLength( text : String, size: (min : Int, max : Int) ) -> Bool{
        return (size.min...size.max).contains(text.count)
    }
    
}
class EmailIdViewModel : ValidationViwModel {
    var errorMessage: String = "Please enter a valid email"
    var data : Variable<String> = Variable("")
    var errorValue: Variable<String?> = Variable("")
    
    func validateCredentials() -> Bool {
        
        guard validatePattern(text: data.value) else {
            errorValue.value = errorMessage
            return false
        }
        
        errorValue.value = ""
        return true
    }
    func validatePattern(text : String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
}
class LoginViewModel {
    let model : LoginModel = LoginModel()
    let disposebag = DisposeBag()
    
    // Initialize ViewModels
    let emailIdViewModel = EmailIdViewModel()
    let passwordViewModel = PasswordViewModel()
    
    let isSucess : Variable<Bool> = Variable(false)
    let isLoading : Variable<Bool> = Variable(false)
    let errorMsg : Variable<String> = Variable("")
    
    func validateCredentials() -> Bool{
        return emailIdViewModel.validateCredentials() && passwordViewModel.validateCredentials()
    }
    func loginUser(){
        model.email = emailIdViewModel.data.value
        model.password = passwordViewModel.data.value
        
        self.isLoading.value = true
        
        
    }
}
class ViewModel {
    let searchText = Variable("")
    
    
    lazy var data : Driver<[Model]> = {
        return Observable.of([Model]()).asDriver(onErrorJustReturn: [])
    }()
}
