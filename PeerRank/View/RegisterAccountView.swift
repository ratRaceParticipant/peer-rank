//
//  RegisterAccountView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 26/10/24.
//

import SwiftUI

struct RegisterAccountView: View {
    @StateObject var vm: RegisterAccountViewModel
    @Environment(\.presentationMode) var presentationMode
    var isUpdate: Bool
    init(
        userConfigModel: UserConfigModel,
        isUpdate: Bool = false
    ){
        self._vm = StateObject(
            wrappedValue: RegisterAccountViewModel(
                userConfigModel: userConfigModel
            )
        )
        self.isUpdate = isUpdate
    }
    
    var body: some View {
        VStack(alignment: .leading,spacing: 15) {
            WarningTextView(warningType: .userNameCanBeEditedOnce)
            CommonViews.textField(
                bindingText: $vm.userName,
                placeholderText: "Enter Username"
            )
            .disabled(isUpdate)
            
            
            CommonViews.textField(
                bindingText: $vm.displayName,
                placeholderText: "Enter Display Name"
            )
            Button {
                Task {
                    withAnimation {
                        vm.registerLoadingStatus = .inprogress
                    }
                    await vm.writeUserConfigToiCloud(isUpdate: isUpdate)
                    withAnimation {
                        vm.registerLoadingStatus = .notStarted
                    }
                    if vm.validationStatus == .noError {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }
            } label: {
                if vm.registerLoadingStatus == .notStarted {
                    CommonViews.buttonLabel()
                } else {
                    ProgressView()
                        .tint(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Color.accentColor
                        )
                        .cornerRadius(10)
                }
                
            }
            .padding(.horizontal)

            Spacer()
        }
        .alert("Error!", isPresented: Binding(value: $vm.validationStatus), actions: {
            Button("Ok") {
                
            }
        }, message: {
            Text(vm.validationStatus.getValidationError())
        })
        .padding()
        .navigationTitle("Register")
        
    }
}

#Preview {
    NavigationStack {
        RegisterAccountView(
            userConfigModel: UserConfigModel(),
            isUpdate: false
        )
    }
}
