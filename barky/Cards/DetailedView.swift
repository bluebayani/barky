//
//  DetailedView.swift
//  barky
//
//  Created by Derrick Lee on 11/12/20.
//

import Foundation
import MessageUI
import SwiftUI
import UIKit

// when a card is clicked, it will show this view
// this view contains all of the dog's information, as well as the owner's contact information
struct detailedView: View {
    @ObservedObject var dog: Dog
    @ObservedObject var profile: User
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(dog.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 20, trailing: 32))
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    VStack {
                        Text(dog.name)
                            .font(.system(size: 32, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.black)
                        Text("\(dog.breed), \(dog.gender)")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.gray)
                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 10, trailing: 0))

                        // MARK: the button opens up the mail application. BUT it is disabled for xcode simulators due to lack of mail app

                        Button(action: {
                            self.isShowingMailView.toggle()
                        }) {
                            Text("Ask about \(dog.name)")
                                .font(.system(size: 18, weight: .bold, design: .default))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(8)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .disabled(!MFMailComposeViewController.canSendMail())
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(dog: dog, profile: profile, result: self.$result)
                        }

                        Text("Description")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                        Text(dog.description)
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                            .foregroundColor(.gray)
                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 10, trailing: 0))
                        Text("Overview")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                        Text("Temperament: \(dog.temperament)")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                        Text("Size: \(dog.size)")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                        Text("Weight: \(dog.weight) pounds")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                    }.layoutPriority(100)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
        }
    }
}

// below is code to open a view to compose an email over the current view
struct MailView: UIViewControllerRepresentable {
    @ObservedObject var dog: Dog
    @ObservedObject var profile: User
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>)
        {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?)
        {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        // populates the email with dog's name, owners email, and a default message.
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["\(profile.email)"])
        vc.setSubject("Bark! Inquiry about \(dog.name)")
        vc.setMessageBody("Hello! I am emailing to let you know im interested in \(dog.name) and I would love to discuss more with you :)", isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {}
}
