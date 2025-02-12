//
//  CharacterArchetypeManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/30/23.
//

import Foundation

class CharacterArchetypeManager: ObservableObject {
    @Published var isResultsPopupShowing: Bool = false
    
    @Published var background: String = ""
    
    // Column 1 - Column 3
    @Published var q1SliderVal: Double = 3.0
    @Published var q2SliderVal: Double = 3.0
    @Published var q3SliderVal: Double = 3.0
    @Published var q4SliderVal: Double = 3.0
    @Published var q5SliderVal: Double = 3.0
    @Published var q6SliderVal: Double = 3.0
    @Published var q7SliderVal: Double = 3.0
    @Published var q8SliderVal: Double = 3.0
    @Published var q9SliderVal: Double = 3.0
    // Column 4 - Column 6
    @Published var q10SliderVal: Double = 3.0
    @Published var q11SliderVal: Double = 3.0
    @Published var q12SliderVal: Double = 3.0
    @Published var q13SliderVal: Double = 3.0
    @Published var q14SliderVal: Double = 3.0
    @Published var q15SliderVal: Double = 3.0
    @Published var q16SliderVal: Double = 3.0
    @Published var q17SliderVal: Double = 3.0
    @Published var q18SliderVal: Double = 3.0
    // Column 7 - Column 9
    @Published var q19SliderVal: Double = 3.0
    @Published var q20SliderVal: Double = 3.0
    @Published var q21SliderVal: Double = 3.0
    @Published var q22SliderVal: Double = 3.0
    @Published var q23SliderVal: Double = 3.0
    @Published var q24SliderVal: Double = 3.0
    @Published var q25SliderVal: Double = 3.0
    @Published var q26SliderVal: Double = 3.0
    @Published var q27SliderVal: Double = 3.0
    // Column 10 - Column 12
    @Published var q28SliderVal: Double = 3.0
    @Published var q29SliderVal: Double = 3.0
    @Published var q30SliderVal: Double = 3.0
    @Published var q31SliderVal: Double = 3.0
    @Published var q32SliderVal: Double = 3.0
    @Published var q33SliderVal: Double = 3.0
    @Published var q34SliderVal: Double = 3.0
    @Published var q35SliderVal: Double = 3.0
    @Published var q36SliderVal: Double = 3.0
    
    // Column 1
    @Published var innocentSum: Double = 0
    // Column 2
    @Published var orphanSum: Double = 0
    // Column 3
    @Published var warriorSum: Double = 0
    // Column 4
    @Published var caregiverSum: Double = 0
    // Column 5
    @Published var seekerSum: Double = 0
    // Column 6
    @Published var loverSum: Double = 0
    // Column 7
    @Published var destroyerSum: Double = 0
    // Column 8
    @Published var creatorSum: Double = 0
    // Column 9
    @Published var rulerSum: Double = 0
    // Column 10
    @Published var magicianSum: Double = 0
    // Column 11
    @Published var sageSum: Double = 0
    // Column 12
    @Published var jesterSum: Double = 0
    
    
    @Published var oneArchetype: String = ""
    @Published var oneDescription: String = ""
    
    @Published var twoArchetype: String = ""
    @Published var twoDescription: String = ""
    
    @Published var threeArchetype: String = ""
    @Published var threeDescription: String = ""
    
    
    var topThree: [String] = []
    
    func calculateArchetypes() {
        topThree = []
        
        innocentSum = q1SliderVal + q4SliderVal + q7SliderVal
        orphanSum = q2SliderVal + q5SliderVal + q8SliderVal
        warriorSum = q3SliderVal + q6SliderVal + q9SliderVal
        caregiverSum = q10SliderVal + q13SliderVal + q16SliderVal
        seekerSum = q11SliderVal + q14SliderVal + q17SliderVal
        loverSum = q12SliderVal + q15SliderVal + q18SliderVal
        destroyerSum = q19SliderVal + q22SliderVal + q25SliderVal
        creatorSum = q20SliderVal + q23SliderVal + q26SliderVal
        rulerSum = q21SliderVal + q24SliderVal + q27SliderVal
        magicianSum = q28SliderVal + q31SliderVal + q34SliderVal
        sageSum = q29SliderVal + q32SliderVal + q35SliderVal
        jesterSum = q30SliderVal + q33SliderVal + q36SliderVal
        
        let mapping = ["Innocent": innocentSum, "Orphan": orphanSum, "Warrior": warriorSum, "Caregiver": caregiverSum, "Seeker": seekerSum, "Lover": loverSum, "Destroyer": destroyerSum, "Creator": creatorSum, "Ruler": rulerSum, "Magician": magicianSum, "Sage": sageSum, "Jester": jesterSum]
        
        let sortedMapping = sortDictionaryByIndex(dictionary: mapping)
        
        print("The top three archetypes are: ")
        var i = 0
        for (key, value) in sortedMapping {
            if i > 2 { break }
            print(key)
            print(value)
            topThree.append(key)
            i += 1
        }
        
        oneArchetype = topThree[0]
        oneDescription = returnDescription(archetype: oneArchetype)
        
        twoArchetype = topThree[1]
        twoDescription = returnDescription(archetype: twoArchetype)
        
        threeArchetype = topThree[2]
        threeDescription = returnDescription(archetype: threeArchetype)
        
        background = returnBackground(archetype: oneArchetype)
    }
    
    func sortDictionaryByIndex(dictionary: [String: Double]) -> [String: Double] {
        // Create an array of tuples, where each tuple contains the key and value of the dictionary
        var tuples = dictionary.map { ($0.key, $0.value) }

        // Sort the tuples by the value of the index
        tuples.sort { $0.1 > $1.1 }

        // Create a new dictionary from the sorted tuples
        var sortedDictionary = [String: Double]()
        for tuple in tuples {
            sortedDictionary[tuple.0] = tuple.1
        }

        // Return the sorted dictionary
        return sortedDictionary
    }
    
    func returnDescription(archetype: String) -> String {
//        var description: String = ""
        switch archetype {
        case "Innocent": return "The Innocent is pure, virtuous, and faultless. They are often seen as children or child-like, and they have a strong sense of optimism and hope. The Innocent is always looking for the good in people and in the world, and they believe that anything is possible."
        case "Orphan": return "The Orphan feels lost, alone, and vulnerable due to a lack of care. As a result, they often have to learn to fend for themselves and become independent at a young age. The Orphan is resilient and abitious, often filled with hope despite their circumstances."
        case "Warrior": return "The Warrior is brave, strong, and skilled in combat. They are often seen as protectors or defenders of their people or way of life. The Warrior is willing to fight for what they believe in, even if it means sacrificing their own safety or well-being."
        case "Caregiver": return "The Caregiver archetype is a character who is selfless, compassionate, and nurturing. They are often seen as healers, and they are driven by a desire to help others. The Caregiver is always willing to lend a helping hand, and they are always there for the people they love."
        case "Seeker": return "The Seeker is curious, inquisitive, and always searching for knowledge. They are often seen as explorers or adventurers, and they are driven by a desire to learn and grow. The Seeker is always looking for new experiences and challenges, and they are not afraid to step outside of their comfort zone."
        case "Lover": return "The Lover is passionate, romantic, and sensual. They are often seen as artists, musicians, or poets, and they are driven by a desire to express their love for life and for others. The Lover is always seeking out new experiences and connections, and they are not afraid to express their emotions."
        case "Destroyer": return "The Destroyer is destructive, chaotic, and often violent. They are often seen as villains or anti-heroes, and they are driven by a desire to destroy or overthrow the status quo. The Destroyer is not afraid to use violence or force to achieve their goals, and they often see themselves as agents of change."
        case "Creator": return "The Creator is imaginative, innovative, and driven to create. They are often seen as artists, inventors, or scientists, and they are driven by a desire to bring their visions to life. The Creator is always looking for new ways to express themselves, and they are not afraid to take risks."
        case "Ruler": return "The Ruler is in charge, whether they are a king, queen, president, CEO, or any other type of leader. They are often seen as strong, confident, and decisive. The Ruler is driven by a desire to achieve their goals and to leave their mark on the world."
        case "Magician": return "The Magician is wise, powerful, and often mysterious. They are often seen as sorcerers or alchemists, and they are driven by a desire to understand the mysteries of the universe. The Magician is able to use their knowledge and power to create change, both in themselves and in the world around them."
        case "Sage": return "The Sage is wise, knowledgeable, and often mysterious. They are often seen as teachers, philosophers, or mentors, and they are driven by a desire to share their knowledge and wisdom with others. The Sage is able to see the big picture and to offer guidance and insights that can help others to grow and develop."
        case "Jester": return "The Jester is funny, witty, and often mischievous. They are often seen as clowns, fools, or tricksters, and they are driven by a desire to entertain and to make people laugh. The Jester is able to see the absurdity of the world, and they are not afraid to point it out in a humorous way."
        default: return ""
        }
    }
    
    func returnBackground(archetype: String) -> String {
        switch archetype {
        case "Innocent": return "CA_Innocent"
        case "Orphan": return "CA_Orphan"
        case "Warrior": return "CA_Warrior"
        case "Caregiver": return "CA_Caregiver"
        case "Seeker": return "CA_Seeker"
        case "Lover": return "CA_Lover"
        case "Destroyer": return "CA_Destroyer"
        case "Creator": return "CA_Creator"
        case "Ruler": return "CA_Ruler"
        case "Magician": return "CA_Magician"
        case "Sage": return "CA_Sage"
        case "Jester": return "CA_Jester"
        default: return ""
        }
    }
    
}
