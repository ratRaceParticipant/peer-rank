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
        cloudKitHandler: CloudKitHandler,
        userConfigModel: UserConfigModel,
        isUpdate: Bool = false
    ){
        self._vm = StateObject(
            wrappedValue: RegisterAccountViewModel(
                cloudKitHandler: cloudKitHandler,
                userConfigModel: userConfigModel
            )
        )
        self.isUpdate = isUpdate
    }
    
    var body: some View {
        VStack(alignment: .leading,spacing: 15) {
            Text("You will not be able to update the username after the first time.")
                .foregroundStyle(.secondary)
                .font(.footnote)
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
                if vm.validationStatus == .noError {
                    Task {
                        await vm.writeUserConfigToiCloud(isUpdate: isUpdate)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                
            } label: {
                CommonViews.buttonLabel()
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
            cloudKitHandler: CloudKitHandler(),
            userConfigModel: UserConfigModel(),
            isUpdate: false
        )
    }
}
