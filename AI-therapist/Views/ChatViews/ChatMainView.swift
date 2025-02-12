//
//  ChatMainView.swift
//  Radiant
//
//  Created by Elvina Shamoi on 11/01/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatMainView: View {
    
//    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @StateObject var chatManager = ChatManager()
    
    @State var text: String
    
    // vars for the loading response animation
    @State var textForLoadingResponse: String = ""
    let finalText: String = "....."
    
    let db = Firestore.firestore()
    
    @State var messages: [Message] = []
    var welcomeMessage = "Hi there! I'm your AI therapist, a chatbot designed to help you. You can talk to me to help with your mental health questions, find professional help, and improve your mood. You can ask me all types of questions and I'll help you as best I can!"
    
    var body: some View {
        ZStack {
            Image("Chat_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
//                    Image("RadiantBotPic")
//                        .resizable()
//                        .frame(width: 100, height: 100)
//
                    Text("Powered by OpenAI")
                        .foregroundColor(.white)
                        .font(.system(size: 14, design: .serif))
                        .padding(.leading, 10)
                        .padding(.top, 10)
                    Spacer()
                    
                    Button(action: {
                        // rate limiting check
                        if let rateLimit = profileStateManager.processFirestoreWrite() {
                            print(rateLimit)
                        } else {
                            self.messages = []
                            print("user hit reset chat, outside of ")
                            if let user = profileStateManager.userProfile {
                                chatManager.clearMessages(userID: user.id!)
                            }
                        }
                    }) {
                        Text("Reset Chat")
                            .foregroundColor(.white)
                            .font(.system(size: 16, design: .serif))
                        
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(maxWidth: 20, maxHeight: 20, alignment: .trailing)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)
                }
                .padding(.leading, 20)
                .padding(.trailing, 30)
                
                
                
                ScrollViewReader { value in
                    // This is the scroll view.
                    ScrollView {
                        // Messages
                        VStack(alignment: .leading) {
                            MessageFromBot(text: welcomeMessage)
                            ForEach(chatManager.messages, id: \.id) { message in
                                if message.id != nil {
                                    if (message.isMessageFromUser!) {
                                        if let userPhoto = profileStateManager.userProfile?.userPhotoNonPremium {
                                            MessageFromYou(text: message.content, profilePhoto: Image(userPhoto))
                                                .id(message.id)
                                        } else {
                                            MessageFromYou(text: message.content, profilePhoto: Image("default_prof_pic"))
                                                .id(message.id)
                                        }
//                                        MessageFromYou(text: message.content)
//                                            .id(message.id)
                                    } else {
                                        MessageFromBot(text: message.content)
                                            .id(message.id)
                                    }
                                } else {
                                    Text("")
                                }
                            }
                            if chatManager.displayLoadingMessage {
                                MessageFromBot(text: textForLoadingResponse)
                                    .id(chatManager.messages.count - 1)
                                    .onAppear {
                                        typeWriter()
                                    }
                            }
                        }
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 5)
//                    .onAppear {
//                        value.scrollTo(self.messages.last?.id)
//                    }
//                    .onChange(of: self.messages.count) { _ in
//                        value.scrollTo(self.messages.last?.id)
//                    }
                    
                }
                
                // Error Text
                if chatManager.isErrorSendingMessage == true {
                    Text(chatManager.errorText)
                        .foregroundColor(.red)
                        .font(.system(size: 14, design: .serif))
                }
                
                // Message send bar
                HStack {
                    TextField("Hi!", text: $text, axis: .vertical)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.leading, 35)
                        .lineLimit(1...4)
                        .font(.system(size: 16, design: .serif))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                                .padding(.leading, 35)
                        )
                        
                        
                    if self.text == "" {
                        Button(action: {
                            // Do nothing if no text is entered
                        }) {
                            Image(systemName: "paperplane")
                                .resizable()
                                .frame(maxWidth: 25, maxHeight: 25, alignment: .trailing)
                                .padding(.leading, 15)
                                .foregroundColor(.gray)
                                .padding(.trailing, 40)
                        }
                    } else {
                        Button(action: {
                            
                            // Rate limiting check
                            if let rateLimit = profileStateManager.processFirestoreWrite() {
                                print(rateLimit)
                            } else {
                                if let user = profileStateManager.userProfile {
                                    print("user pressed send message button")
                                    if chatManager.sendMessage(userID: user.id!, content: self.text, isPremiumUser: user.isPremiumUser, lastMessageSendDate: user.lastMessageSendDate, numMessagesSentToday: user.numMessagesSentToday) == true {
                                        // message sent successfully
                                        if user.isPremiumUser == false {
                                            profileStateManager.retrieveUserProfile(userID: user.id!)
                                        }
                                    }
                                }
                                self.text = ""
                            }
                        }) {
                            Image(systemName: "paperplane")
                                .resizable()
                                .frame(maxWidth: 25, maxHeight: 25, alignment: .trailing)
                                .padding(.leading, 15)
                                .foregroundColor(.blue)
                                .padding(.trailing, 40)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .adaptsToKeyboard()
            .padding(.top, 100)
            .scrollDismissesKeyboard(.immediately)
            .animation(.easeInOut(duration: 1.0))
        }
        .background(Color.clear)
//        .ignoresSafeArea(.keyboard)
        .environmentObject(chatManager)
        .onAppear {
//            if let user = profileStateManager.userProfile {
//                chatManager.retrieveMessages(userID: user.id!)
//            }
        }
    }
    
    func typeWriter(at position: Int = 0) {
        if position == 0 {
            textForLoadingResponse = ""
        }
        if position < finalText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                textForLoadingResponse.append(finalText[position])
                typeWriter(at: position + 1)
            }
        }
    }
    
//    func retrieveMessages(userID: String) {
//        self.messages = []
//
//        let collectionRef = self.db.collection(Constants.FStore.messageCollectionName).whereField("userID", isEqualTo: userID).order(by: "date", descending: false)
//
//        collectionRef.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error retrieving comments: \(err.localizedDescription)")
//            } else if let querySnapshot = querySnapshot {
//                for document in querySnapshot.documents {
//                    let message = Message(
//                        id: document.documentID,
//                        userID: document.data()["userID"] as? String,
//                        isMessageFromUser: document.data()["isMessageFromUser"] as? Bool,
//                        content: document.data()["content"] as? String,
//                        date: document.data()["date"] as? Date)
//                    self.messages.append(message)
//                    print("Message was retrieved, messageID: \(document.documentID), message content: \(document.data()["content"] as? String ?? "No Content")")
//                }
//            }
//        }
//    }
    
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

struct ChatMainView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMainView(text: "hello")
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
            .environmentObject(ChatManager())
    }
}


struct MessageFromYou : View {
    let text: String?
    let profilePhoto: Image?
    var body: some View {
        
//        HStack {
//            ZStack {
//                // Create the bubble shape
//                RoundedRectangle(cornerRadius: 20)
//                    .fill(Color.blue)
//
//                // Add the text content
//                Text(text ?? "No text")
//                    .padding()
//                    .foregroundColor(.white)
//                    .font(.system(size: 16, design: .serif))
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.white)
//            .cornerRadius(20)
//            .padding(.leading, 60)
            
//            Label(text ?? "", systemImage: "")
//                .font(.system(size: 16, design: .serif))
//                .foregroundColor(.white)
//                .padding()
//                .background(.blue.opacity(0.75), in: Capsule())
//                .padding(.leading, 60)
//
//
//            RoundedRectangle(cornerRadius: 25)
//                .fill(Color.blue)
//                .frame(minWidth: 40, maxWidth: 300, maxHeight: .infinity)
//                .overlay {
//                    Text(text ?? "")
//                        .font(.system(size: 16, design: .serif))
//                        .padding()
//                }
//
//            profilePhoto!
//                .resizable()
//                .frame(width: 40, height: 40)
//                .clipShape(Circle())
//                .padding(.trailing, 10)
//
//        }
//        .padding(.trailing, 8)
        ChatBubble(direction: .right) {
            Text(text ?? "")
                .padding(.all, 20)
                .foregroundColor(.white)
                .background(Color.blue.opacity(0.70))
                .font(.system(size: 16, design: .serif))
        }
        
    }
}

struct MessageFromBot : View {
    let text: String?
    var body: some View {
        
//        HStack {
//            Image("RadiantBotPic")
//                .resizable()
//                .frame(width: 40, height: 40)
//                .clipShape(Circle())
//                .padding(.trailing, 10)
//
//            ZStack {
//                // Create the bubble shape
//                RoundedRectangle(cornerRadius: 16)
//                    .fill(Color.black.opacity(0.80))
//
//                // Add the text content
//                Text(text ?? "No text")
//                    .padding()
//                    .foregroundColor(.white)
//                    .font(.system(size: 16, design: .serif))
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.white)
//            .cornerRadius(16)
//            .padding(.trailing, 50)
//
//        }
//        .padding(.leading, 15)
        ChatBubble(direction: .left) {
            Text(text ?? "")
                .padding(.all, 20)
                .foregroundColor(.white)
                .background(Color.black.opacity(0.70))
                .font(.system(size: 16, design: .serif))
        }
        
    }
}


struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}


struct ChatBubble<Content>: View where Content: View {
    let direction: ChatBubbleShape.Direction
    let content: () -> Content
    init(direction: ChatBubbleShape.Direction, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.direction = direction
    }
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }
            content().clipShape(ChatBubbleShape(direction: direction))
            if direction == .left {
                Spacer()
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .padding(.bottom, 5)
//        .padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 20)
//        .padding((direction == .right) ? .leading : .trailing, 50)
    }
}


struct ChatBubbleShape: Shape {
    enum Direction {
        case left
        case right
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        return (direction == .left) ? getLeftBubblePath(in: rect) : getRightBubblePath(in: rect)
    }
    
    private func getLeftBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x: width - 20, y: height))
            p.addCurve(to: CGPoint(x: width, y: height - 20),
                       control1: CGPoint(x: width - 8, y: height),
                       control2: CGPoint(x: width, y: height - 8))
            p.addLine(to: CGPoint(x: width, y: 20))
            p.addCurve(to: CGPoint(x: width - 20, y: 0),
                       control1: CGPoint(x: width, y: 8),
                       control2: CGPoint(x: width - 8, y: 0))
            p.addLine(to: CGPoint(x: 21, y: 0))
            p.addCurve(to: CGPoint(x: 4, y: 20),
                       control1: CGPoint(x: 12, y: 0),
                       control2: CGPoint(x: 4, y: 8))
            p.addLine(to: CGPoint(x: 4, y: height - 11))
            p.addCurve(to: CGPoint(x: 0, y: height),
                       control1: CGPoint(x: 4, y: height - 1),
                       control2: CGPoint(x: 0, y: height))
            p.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: 11.0, y: height - 4.0),
                       control1: CGPoint(x: 4.0, y: height + 0.5),
                       control2: CGPoint(x: 8, y: height - 1))
            p.addCurve(to: CGPoint(x: 25, y: height),
                       control1: CGPoint(x: 16, y: height),
                       control2: CGPoint(x: 20, y: height))
        }
        return path
    }
    
    private func getRightBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x:  20, y: height))
            p.addCurve(to: CGPoint(x: 0, y: height - 20),
                       control1: CGPoint(x: 8, y: height),
                       control2: CGPoint(x: 0, y: height - 8))
            p.addLine(to: CGPoint(x: 0, y: 20))
            p.addCurve(to: CGPoint(x: 20, y: 0),
                       control1: CGPoint(x: 0, y: 8),
                       control2: CGPoint(x: 8, y: 0))
            p.addLine(to: CGPoint(x: width - 21, y: 0))
            p.addCurve(to: CGPoint(x: width - 4, y: 20),
                       control1: CGPoint(x: width - 12, y: 0),
                       control2: CGPoint(x: width - 4, y: 8))
            p.addLine(to: CGPoint(x: width - 4, y: height - 11))
            p.addCurve(to: CGPoint(x: width, y: height),
                       control1: CGPoint(x: width - 4, y: height - 1),
                       control2: CGPoint(x: width, y: height))
            p.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: width - 11, y: height - 4),
                       control1: CGPoint(x: width - 4, y: height + 0.5),
                       control2: CGPoint(x: width - 8, y: height - 1))
            p.addCurve(to: CGPoint(x: width - 25, y: height),
                       control1: CGPoint(x: width - 16, y: height),
                       control2: CGPoint(x: width - 20, y: height))
            
        }
        return path
    }
}




