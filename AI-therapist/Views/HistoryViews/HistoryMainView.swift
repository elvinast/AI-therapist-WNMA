//
//  HistoryMainView.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 9/01/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage


struct HistoryMainView: View {
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    @StateObject var historyManager = HistoryManager()
    
    @State var days: [Day] = []
    
    var body: some View {
        ZStack {
            Image("History_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            
            VStack(alignment: .leading) {
                // Weekly Calendar
                if historyManager.focusedDay?.formattedDateForFirestore == Date().formatted(date: .abbreviated, time: .omitted) {
                    Text("Today")
                        .font(.system(size: 20, design: .serif))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .onAppear {
                            print(Date().formatted(date: .abbreviated, time: .omitted))
                        }
                } else {
                    Text(historyManager.focusedDay!.formattedDateForFirestore)
                        .font(.system(size: 20, design: .serif))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                    
                }
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(historyManager.days) { day in
                                DayBubble(day: day.self, dayOfMonth: day.dayOfMonth, isComplete: day.doesCheckInExist, doesCheckInPhotoExist: day.doesCheckInPhotoExist)
                            }
                        }
                    }
                    .onAppear {
                        proxy.scrollTo( historyManager.days[historyManager.days.count-1].id)
                    }
                }
                .padding(.bottom, 10)
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    if historyManager.focusedDay?.checkIn != nil {
                        HStack {
                            Text("Goals")
                                .font(.system(size: 20, design: .serif))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        // Goals one and two
                        HStack {
                            if let goalOne = historyManager.focusedDay?.checkIn?.goals![0] {
                                GoalCapsule(keyword: goalOne, symbol: "leaf", color: "blue")
                            }
                            if let goalTwo = historyManager.focusedDay?.checkIn?.goals![1] {
                                GoalCapsule(keyword: goalTwo, symbol: "pencil.circle", color: "green")
                            }
                        }
                        if let goalThree = historyManager.focusedDay?.checkIn?.goals![2] {
                            GoalCapsule(keyword: goalThree, symbol: "hand.point.up.braille.fill", color: "red")
                        }
                        
                        HStack {
                            
                            Text("Gratitude")
                                .font(.system(size: 20, design: .serif))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        if let gratitude = historyManager.focusedDay?.checkIn?.gratitude {
                            GoalCapsule(keyword: gratitude, symbol: "sun.min", color: "purple")
                        }
                        
                        
                        HStack {
                            Text("Mood")
                                .font(.system(size: 20, design: .serif))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        VStack {
                            HStack {
                                // Happiness
                                VStack {
                                    Text("Happiness")
                                        .font(.system(size: 15, design: .serif))
                                        .foregroundColor(.black)
                                    
                                    if let happinessVal = historyManager.focusedDay?.checkIn?.happinessScore {
                                        Text(String(format: "%.0f", happinessVal))
                                            .font(.system(size: 14, design: .serif))
                                            .foregroundColor(.black)
                                        
                                        SmileyFace(value: happinessVal, reverse: false)
                                    }
                                }
                                .padding(.trailing, 10)
                                // Depression
                                VStack {
                                    Text("Depression")
                                        .font(.system(size: 15, design: .serif))
                                        .foregroundColor(.black)
                                    
                                    if let depresisonVal = historyManager.focusedDay?.checkIn?.depressionScore  {
                                        Text(String(format: "%.0f", depresisonVal))
                                            .font(.system(size: 14, design: .serif))
                                            .foregroundColor(.black)
                                        
                                        SmileyFace(value: depresisonVal, reverse: true)
                                    }
                                }
                                .padding(.trailing, 20)
                                // Anxiety
                                VStack {
                                    Text("Anxiety")
                                        .font(.system(size: 15, design: .serif))
                                        .foregroundColor(.black)
                                    if let anxietyVal = historyManager.focusedDay?.checkIn?.anxietyScore  {
                                        Text(String(format: "%.0f", anxietyVal))
                                            .font(.system(size: 14, design: .serif))
                                            .foregroundColor(.black)
                                        SmileyFace(value: anxietyVal, reverse: true)
                                    }
                                }
                            }
                        }
                        
                        HStack {
                            Text("Journal")
                                .font(.system(size: 20, design: .serif))
                                .foregroundColor(.black)
                            
                            Spacer()
                            Image(systemName: "pencil.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                                .padding(.trailing, 10)
                        }
                        
                        
                        if let journalEntry = historyManager.focusedDay?.checkIn?.journalEntry {
                            JournalEntry(journalText: journalEntry)
                        }
                        
                        
                        // Todo: Find a better way to display the photo of the day
//                        HStack {
//                            Text("Photo of the day")
//                                .font(.system(size: 20, design: .serif))
//                                .foregroundColor(.white)
//
//                            Spacer()
//                            // Display the photo
//                            if historyManager.focusedDay!.doesCheckInPhotoExist == true {
//                                Image(uiImage: historyManager.checkInPremiumPhotos[self.historyManager.focusedDay!.formattedDateForFirestore] ?? UIImage())
//                                    .resizable()
//                                    .frame(width: 100, height: 100)
//                                    .clipShape(Circle())
//                                    .padding(.top, 40)
//                            }
//                        }
                    } else {
                        // add something to indicate no check-in was logged
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 100)
            }
            .padding(.top, 100)
            .onAppear {
                if let user = Auth.auth().currentUser?.uid {
                    historyManager.crossCheckDaysWithCheckInsFromFirstore(userId: user)
                    let seconds = 2.0
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    //                        for i in 0...historyManager.days.count - 1  {
                    //                            print(historyManager.days[i].formattedDateForFirestore)
                    //                            print(historyManager.days[i].checkInPremiumPhoto != nil)
                    //                        }
                    //                        historyManager.attatchPremiumCheckInPhotos(userId: user)
                    //                    }
                    
                } else {
                    print("no user yet")
                }
            }
            
        }
        .environmentObject(historyManager)
    }
}

struct HistoryMainView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryMainView()
            .environmentObject(HistoryManager())
    }
}


struct DayBubble: View {
    @EnvironmentObject var historyManager: HistoryManager
    
    let day: Day?
    let dayOfMonth: Int?
    let isComplete: Bool?
    let isFocused: Bool = false
    
    let doesCheckInPhotoExist: Bool?
    @State var customImage: UIImage?
    
    var body: some View {
        
        Button(action: {
            historyManager.focusedDay = self.day
        }) {
            
            if historyManager.focusedDay != self.day {
                VStack {
                    Text("\(dayOfMonth!)")
                        .font(.system(size: 14, design: .serif))
                        .foregroundColor(.black)
                    
                    if isComplete! {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)
//                            if let isPhoto = self.doesCheckInPhotoExist {
//                                if isPhoto {
//                                    Image(uiImage: self.day!.checkInPremiumPhoto)
//                                        .resizable()
//                                        .frame(width: 40, height: 40)
//                                        .clipShape(Circle())
//                                }
//                            }
                            if self.day!.doesCheckInPhotoExist == true {
                                Image(uiImage: historyManager.checkInPremiumPhotos[self.day!.formattedDateForFirestore] ?? UIImage())
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                        }
                        
                    } else {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(.trailing, 10)
            } else {
                
                VStack {
                    Text("\(dayOfMonth!)")
                        .font(.system(size: 16, design: .serif))
                        .foregroundColor(.black)
                    
                    
                    
                    if isComplete! {
                        // check for a custom check-in photo
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                            if self.day!.doesCheckInPhotoExist == true {
                                Image(uiImage: historyManager.checkInPremiumPhotos[self.day!.formattedDateForFirestore] ?? UIImage())
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }
                        }
                        
                    } else {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(.trailing, 10)
            }
        }.animation(.easeInOut(duration: 0.2))
    }
}

struct GoalCapsule: View {
    let keyword: String
    let symbol: String
    let color: String
    var body: some View {
        
        switch color {
        case "blue": Label(keyword, systemImage: symbol)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.white)
                .padding(16)
                .background(.blue.opacity(0.75), in: Capsule())
        case "green": Label(keyword, systemImage: symbol)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.white)
                .padding(16)
                .background(.green.opacity(0.75), in: Capsule())
        case "red": Label(keyword, systemImage: symbol)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.white)
                .padding(16)
                .background(.red.opacity(0.75), in: Capsule())
        case "purple": Label(keyword, systemImage: symbol)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.white)
                .padding(16)
                .background(.purple.opacity(0.75), in: Capsule())
        case "white": Label(keyword, systemImage: symbol)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.black)
                .padding(20)
                .background(.white.opacity(0.75), in: Capsule())
        default: Label(keyword, systemImage: symbol)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.white)
                .padding(16)
                .background(.blue.opacity(0.75), in: Capsule())
        }
        
    }
}

struct JournalEntry: View {
    let journalText: String
    let backgroundImage = Image("notebook_paper")
    
    var body: some View {
        //        backgroundImage
        //            .resizable()
        //            .frame(width: 360, height: 140)
        //            .cornerRadius(20)
        //            .blur(radius: 2)
        //            .overlay {
        //                VStack {
        //                    HStack() {
        //                        Text(journalText)
        //                            .font(.system(size: 15, design: .serif))
        //                            .foregroundColor(.black)
        //                        Spacer()
        //                    }
        //
        //                    Spacer()
        //                }
        //                .padding(.leading, 30)
        //                .padding(.top, 18)
        //                .padding(.bottom, 10)
        //                .padding(.trailing, 10)
        //            }
        
        GoalCapsule(keyword: journalText, symbol: "pencil.circle", color: "white")
    }
}

struct SmileyFace: View {
    let value: Double
    let reverse: Bool
    var body: some View {
        if !reverse {
            switch value {
            case 0...3: Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
            case 4...6: Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.yellow)
            case 7...10: Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
            default: Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
            }
        } else {
            switch value {
            case 0...3: Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
            case 4...6: Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.yellow)
            case 7...10: Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
            default: Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
            }
        }
    }
}
