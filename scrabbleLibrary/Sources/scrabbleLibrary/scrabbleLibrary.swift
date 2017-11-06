// char key and its value in the game
let tileScore  = ["a": 1, "c": 3, "b": 3, "e": 1, "d": 2, "g": 2,
                  "f": 4, "i": 1, "h": 4, "k": 5, "j": 8, "m": 3,
                  "l": 1, "o": 1, "n": 1, "q": 10, "p": 3, "s": 1,
                  "r": 1, "u": 1, "t": 1, "w": 4, "v": 4, "y": 4,
                  "x": 8, "z": 10]

// sevenLetterValidity check whether it contains punctuations or numbers and if it meets the length requirement
enum sevenLetterValidity: Error {
    case minimumLength
    case containNonLetter
}

public struct Word {
    // core Instance variables
    public var word: String
    public var definition: String
    public var wordScore: Int
    
    public var scrabbleDictionary: [String: String] = [:]
    public var scrabbleDictionaryByScore: [String: Int] = [:]
    
    // for further computation for analyzing 3-letter possible words from the user input (7-letter word)
    public var characterOccurence:[[String: Int]] = []
    public var wordsSequecebyScrabbleWords: [String: Int] = [:]
    
    public init(word: String) {
        let scrabbleWords: String = "/Users/hyoungsunpark/Desktop/mpcsSwift/HW3_problem03/3letter_words.txt"
        self.word = word
        do {
            let data = try String(contentsOfFile: scrabbleWords, encoding: String.Encoding.utf8)
            for line in data.components(separatedBy: .newlines) {
                var charArray = [Character](line)
                if charArray.count > 0 {
                    scrabbleDictionary[(String(charArray[0...2]))] = (String(charArray[3..<charArray.count])).trimmingCharacters(in: .whitespaces)
                }
            }
        } catch {
            print(">>> Error")
        }
        self.definition = scrabbleDictionary[word]!
        var score = 0
        for char in word {
            if tileScore.keys.contains(String(char).lowercased()) {
                score += tileScore[String(char).lowercased()]!
            }
        }
        self.wordScore = score
        var valueForSortedDictionary = 0
        for char in scrabbleDictionary.keys {
            for each in char {
                if tileScore.keys.contains(String(each).lowercased()) {
                    valueForSortedDictionary += tileScore[String(each).lowercased()]!
                }
                scrabbleDictionaryByScore[String(char)] = valueForSortedDictionary
                valueForSortedDictionary = 0
            }
        }
        for (key, _) in scrabbleDictionary {
            var eachCharOccur: [String: Int] = [:]
            for each in key {
                if let exist = eachCharOccur[String(each).lowercased()] {
                    eachCharOccur[String(each).lowercased()]! = exist + 1
                } else {
                    eachCharOccur[String(each).lowercased()] = 1
                }
            }
            characterOccurence.append(eachCharOccur)
        }
    }
    public func getValue() -> Int {
        return self.wordScore
    }
    
    /* this function is to figure out what might be possible 3 letter possible words can be extracted from the input user provides (7-letter)*/
    public func allPossibleScrabble (sevenLetter: String) throws {
        guard sevenLetter.count == 7 else {
            throw sevenLetterValidity.minimumLength
        }
        let nonLetter = CharacterSet.punctuationCharacters
        let charset = CharacterSet(charactersIn: sevenLetter)
        guard charset.isDisjoint(with: nonLetter) && !("0"..."9").contains(sevenLetter) else {
            throw sevenLetterValidity.containNonLetter
        }
        // Create a dictionary for the seven-letter words with each character's occurence
        var sevenLetterOccurence: [String: Int] = [:]
        for char in sevenLetter {
            if let exist = sevenLetterOccurence[String(char)] {
                sevenLetterOccurence[String(char)] = exist + 1
            } else {
                sevenLetterOccurence[String(char)] = 1
            }
        }
        // possible 3-letter scrabble words Dictionary
        var possible3LetterScrabble: [[String: Int]] = []
        for element in characterOccurence {
            var count = 0
            for (key, value) in element {
                if sevenLetterOccurence[key] == nil {
                    count += 0
                } else if sevenLetterOccurence[key]! >= value {
                    count += 1
                }
            }
            if count == element.count {
                possible3LetterScrabble.append(element)
            }
        }
        // storing each character into a string format (just like scrabble words) and its value (based on tileScore)
        var stringPossibleWords: [String: Int] = [:]
        for possibleWords in possible3LetterScrabble {
            var stringWords = ""
            var stringWordsValue = 0
            for (key, _) in possibleWords {
                stringWords.append(String(key))
                stringWordsValue += tileScore[key]!
            }
            stringPossibleWords[stringWords] = stringWordsValue
        }
        // sort the possible words by its value for presenting the srabble words by descending order
        let sortedPossibleWordsByValue = stringPossibleWords.sorted(by: { $0.value > $1.value })
        for (key, value) in sortedPossibleWordsByValue {
            print("\(key) \(value)")
        }
    }
}
extension Word: Equatable, Comparable, CustomStringConvertible {
    // Equatable function implemented by the Word's score value
    public static func == (lhs: Word, rhs: Word) -> Bool {
        if lhs.wordScore == rhs.wordScore {
            return true
        }
        else {
            return false
        }
    }
    // Comparable function implemented by the Word's score value
    public static func < (lhs: Word, rhs: Word) -> Bool {
        if lhs.wordScore < rhs.wordScore {
            return true
        }
        else {
            return false
        }
    }
    public var description: String {
        return "\(self.word)'s value is: \(self.wordScore) and its definition is >>> \(self.definition)"
    }
}
