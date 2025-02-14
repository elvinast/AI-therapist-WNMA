//
//  CheckInView.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 24/12/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct CheckInView: View {
    @StateObject var checkInManager = CheckInManager()
    @EnvironmentObject var homeManager: HomeManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    @State private var happinessSliderValue = 5.0
    @State private var depressionSliderValue = 5.0
    @State private var anxietySliderValue = 5.0
    
    @State private var todaysDate = Date()
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("SoftCoral"), Color("SoftCoral")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text(todaysDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 30, design: .serif))
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, 8)
                    ScrollView {
                        
                        // Goals
                        VStack {
                            Text("What are your goals for today?")
                                .foregroundColor(.white)
                                .font(.system(size: 20, design: .serif))
                            
                            TextField("Enter text", text: $checkInManager.goalOne, prompt: Text("Enter text").foregroundColor(.white))
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 10)
                                .foregroundColor(.white)
                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                        .padding(20)
                                        .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                                )
                            
                            TextField("Enter text", text: $checkInManager.goalTwo, prompt: Text("Enter text").foregroundColor(.white))
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 10)
                                .foregroundColor(.white)
                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                        .padding(20)
                                        .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                                )
                            
                            TextField("Enter text", text: $checkInManager.goalThree, prompt: Text("Enter text").foregroundColor(.white))
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 10)
                                .foregroundColor(.white)
                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                        .padding(20)
                                        .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                                )
                        }
                        .padding(.bottom, 40)
                        
                        // Gratitude
                        VStack {
                            Text("What are you grateful for today?")
                                .foregroundColor(.white)
                                .font(.system(size: 20, design: .serif))
                            
                            TextField("Enter text", text: $checkInManager.gratitude, prompt: Text("Enter text").foregroundColor(.white))
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 10)
                                .foregroundColor(.white) // Ensures the text itself is white
                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                        .padding(20)
                                        .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                                )
                                .padding(.bottom, 40)

                        }
                        
                        // Mood sliders
                        VStack {
                            
                            Text("Please tell us how you're feeling today")
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                                .font(.system(size: 18, design: .serif))
                                .bold()
                                .padding(10)
                            
                            
                            HStack {
                                // Happiness
                                VStack(alignment: .center) {
                                    Text("Happiness")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, design: .serif))
                                    CirclularSlider(sliderValue: $checkInManager.happinessSliderVal)
                                    
                                    switch checkInManager.happinessSliderVal {
                                    case 0...4:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.red)
                                    case 4...7:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.yellow)
                                    case 7...10:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.green)
                                    default:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.white)
                                    }
                                    
                                }
                                .padding(.trailing, 20)
                                
                                // Depression
                                VStack(alignment: .center) {
                                    Text("Depression")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, design: .serif))
                                    CirclularSlider(sliderValue: $checkInManager.depressionSliderVal)
                                    switch checkInManager.depressionSliderVal {
                                    case 0...4:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.green)
                                    case 4...7:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.yellow)
                                    case 7...10:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.red)
                                    default:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.trailing, 20)
                                
                                // Anxiety
                                VStack(alignment: .center) {
                                    Text("Anxiety")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, design: .serif))
                                    CirclularSlider(sliderValue: $checkInManager.anxeitySliderVal)
                                    switch checkInManager.anxeitySliderVal {
                                    case 0...4:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.green)
                                    case 4...7:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.yellow)
                                    case 7...10:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.red)
                                    default:
                                        Image(systemName: "face.smiling.inverse")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.bottom, 40)
                            
                            
                            // Journal Prompt
                            VStack {
                                
                                HStack {
                                    Text("Journal Entry")
                                        .foregroundColor(.white)
                                        .padding(.bottom, 20)
                                        .font(.system(size: 18, design: .serif))
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Image(systemName: "pencil.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 15)
                                }
                                
                                TextField("Enter text", text: $checkInManager.journalEntry, prompt: Text("Enter text").foregroundColor(.white), axis: .vertical)
                                    .font(.system(size: 20, design: .serif))
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .lineLimit(5...10)
//                                    .frame(width: 300)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 1)
                                            .frame(minWidth: 200, minHeight: 100, maxHeight: 300)
                                    )
                                
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .padding(.bottom, 60)
                            
                            if checkInManager.isErrorInCheckIn {
                                Text(checkInManager.errorText)
                                    .foregroundColor(.red)
                                    .font(.system(size: 20, design: .serif))
                                    .padding(.bottom, 20)
                            }
                            
                            // Finish Check in
                            Button(action: {
                                if let user = profileStateManager.userProfile {
                                    checkInManager.checkIn(userID: user.id!)
                                }
                                if checkInManager.isErrorInCheckIn == false {
                                    homeManager.isCheckInPopupShowing = false
                                }
                            }) {
                                Text("Finish check in")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("SoftCoral"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 55)
                                    .background(Color("WarmBeige"))
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                    .padding(.horizontal, 20)
                                
                                
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    .scrollDismissesKeyboard(.immediately)
                }
                .padding(.top, 25)
                .padding(.bottom, 25)
            }
        }.environmentObject(checkInManager)
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
            .environmentObject(ProfileStatusManager())
            .environmentObject(CheckInManager())
            .environmentObject(HomeManager())
    }
}


struct DepressionView: View {
    
    @EnvironmentObject var checkInManager: CheckInManager
    var body: some View {
        
        
        ZStack {
            Image("CheckIn_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("Please rate your depression today: ")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .font(.system(size: 18, design: .monospaced))
                    .bold()
                    .padding(20)
                CirclularSlider(sliderValue: $checkInManager.depressionSliderVal)
                
                NavigationLink(destination: AnxeityView()) {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.system(size: 30, design: .monospaced))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .offset(y: 200)
                .padding(.bottom, 80)
            }
        }
        .padding(.bottom, 75)
    }
}


struct AnxeityView: View {
    @EnvironmentObject var checkInManager: CheckInManager
    var body: some View {
        
        ZStack {
            Image("CheckIn_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("Please rate your anxiety today: ")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .font(.system(size: 18, design: .monospaced))
                    .bold()
                    .padding(20)
                CirclularSlider(sliderValue: $checkInManager.anxeitySliderVal)
                
                
                NavigationLink(destination: GoalsView()) {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.system(size: 30, design: .monospaced))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .offset(y: 200)
                .padding(.bottom, 80)
            }
            
        }
        .padding(.bottom, 50)
    }
}


struct GoalsView: View {
    @EnvironmentObject var checkInManager: CheckInManager
    
    var body: some View {
        ZStack {
            Image("CheckIn_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("What are your goals for today?")
                    .foregroundColor(.white)
                    .font(.system(size: 20, design: .monospaced))
                
                TextField("Enter text", text: $checkInManager.goalOne)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .padding(20)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                    )
                
                TextField("Enter text", text: $checkInManager.goalTwo)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .padding(20)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                    )
                
                TextField("Enter text", text: $checkInManager.goalThree)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .padding(20)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                    )
                
                NavigationLink(destination: GratitudeView()) {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.system(size: 30, design: .monospaced))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .offset(y: 200)
                .padding(.bottom, 80)
            }
        }
    }
}

struct GratitudeView: View {
    @EnvironmentObject var checkInManager: CheckInManager
    @EnvironmentObject var homeManager: HomeManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    var body: some View {
        ZStack {
            Image("CheckIn_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Text("What are you grateful for today?")
                    .foregroundColor(.white)
                    .font(.system(size: 20, design: .monospaced))
                
                TextField("Enter text", text: $checkInManager.gratitude)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .padding(20)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                    )
                
                Button(action: {
                    if let user = profileStateManager.userProfile {
                        checkInManager.checkIn(userID: user.id!)
                    }
                    homeManager.isCheckInPopupShowing = false
                }) {
                    Text("Finish Check In")
                }
            }
        }
    }
}

struct UploadCheckInPhotoPopup: View {
    @EnvironmentObject var checkInManager: CheckInManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    var body: some View {
        Form {
            Section {
                PhotosPicker(selection: $checkInManager.selectedItem, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
                    if let data = checkInManager.data, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame( maxHeight: 300)
                    } else {
                        Label("Select a picture", systemImage: "photo.on.rectangle.angled")
                            .foregroundColor(.blue)
                    }
                }.onChange(of: checkInManager.selectedItem) { newValue in
                    guard let item = checkInManager.selectedItem.first else {
                        return
                    }
                    item.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data {
                                checkInManager.data = data
                            }
                        case .failure(let failure):
                            print("Error: \(failure.localizedDescription)")
                        }
                    }
                }
            }
            Section {
                Button("Confirm") {
                    // Function to post data to Firebase Storage
                    if let user = profileStateManager.userProfile {
//                        checkInManager.uploadPremiumCheckInPhoto(userID: user.id!)
                        checkInManager.isUploadCheckInPhotoShowing = false
                    }
                }.disabled(checkInManager.data == nil)
                    .foregroundColor(checkInManager.data == nil ? .gray : .blue)
                
            }
        }
    }
}

