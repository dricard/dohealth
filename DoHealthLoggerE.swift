#!/usr/bin/env xcrun swift

import Foundation

/* *********************************
	 		DOHEALTH Script
			English version
   ********************************* */


/* *********************************
	 MODIFY THESE 3 PROPERTIES
	         AS NEEDED
********************************* */

// the journal to log to in Day One

let dayOneJournal = "health"

// the default tag(s) to add to all entries. If you don't
// add at least one default tag, you'll have to modify the code below.
// tags *can* have spaces

let defaultTags = ["dohealth", "health" ]

/* ********************************* */


// requires Swift 4.0


//-- get parameter input
// `argument` holds the text entered in Alfred by the user
// I initialize it with an example of something the user could enter
// for testing. Use the various examples to test different cases.
// In real use the argument will be replaced with what the user typed of course

// var argument = "-l ketone @0.1 mmol/l"
// var argument = "-m morning @vitamins B complex, B2, D, C, Omega-3"
// var argument = "-s evening @cramps"
// var argument = "-w pm @700 ml of water"
// var argument = "-t anniversary @chocolat cake"
// var argument = "-t 2 @salmon with kale and avocados"
 var argument = "-t 1 @egg, avocado and coffee"
// var argument = "-t 3 @beef with asparagus and mushrooms"
// var argument = "-t 0 @hazelnuts and almonds"

// these test arguments are missing the '@' character
// var argument = "-l ketone 0.1 mmol/l"
// var argument = "-m morning vitamins B complex, B2, D, C, Omega-3"
// var argument = "-s evening cramps"
// var argument = "-w pm 700 ml of water"
// var argument = "-t anniversary chocolat cake"
// var argument = "yogourt 0% with almonds"


#if swift(>=4.0)
	if CommandLine.arguments.count > 1 {
		argument = CommandLine.arguments[1]
	}
#elseif swift(>=1.0)
	print("Unsupported version of Swift (<= 4.0) please update to Swift 4.0")
	break
#endif

// MARK: - Properties

// variable 'entryText' will hold the food passed in

var entryText  = ""

// `outputString` is the result of the script that will be passed to the CLI, 
// we initialize it with the Day One CLI command, setting the default journal
// and the default tags.

var outputString: String = "dayone2 --journal "

enum EntryType: String {
	case food = "eaten:"
	case symptom = "symptoms:"
	case medication = "taken:"
	case water = "drank:"
	case measure = "measured:"
	
	var extraDefaultTags: String {
		switch self {
			case .food:
				return ""
			case .symptom:
				return "symptom "
			case .medication:
				return "medication "
			case .water:
				return "water "
			case .measure:
				return "measure "
		}
	}
}

func entryType(for argument: String) -> (EntryType, Bool) {
	
	if let _ = argument.index(of: "@") {
		if argument.hasPrefix("-t") {
			return (.food, true)
		} else if argument.hasPrefix("-s") {
			return (.symptom, true)
		} else if argument.hasPrefix("-m") {
			return (.medication, true)
		} else if argument.hasPrefix("-w") {
			return (.water, true)
		} else if argument.hasPrefix("-l") {
			return (.measure, true)
		} else {
			// default case with no prefix
			return (.food, false)
		}
	} else {
		// if we can't find an '@' character then the user forgot it and we can't separate
		// the tags from the entry text, so we pass the whole thing as the entry text
		if argument.hasPrefix("-t") {
			return (.food, false)
		} else if argument.hasPrefix("-s") {
			return (.symptom, false)
		} else if argument.hasPrefix("-m") {
			return (.medication, false)
		} else if argument.hasPrefix("-w") {
			return (.water, false)
		} else if argument.hasPrefix("-l") {
			return (.measure, false)
		} else {
			// default case with no prefix
			return (.food, false)
		}
	}
}

// MARK: - Utilities

func replaceSpaces(in tag: String) -> String {
	return tag.replacingOccurrences(of: "_", with: "\\ ")
}

func removeSpecialCharacters(in tag: String) -> String {
	// escape special characters
	// ! ? $ % # & * ( ) blank tab | ' ; " < > \ ~ ` [ ] { }
	var returnedTag = tag
	returnedTag = returnedTag.replacingOccurrences(of: "!", with: "\\!")
	returnedTag = returnedTag.replacingOccurrences(of: "?", with: "\\?")
	returnedTag = returnedTag.replacingOccurrences(of: "$", with: "\\$")
	returnedTag = returnedTag.replacingOccurrences(of: "%", with: "\\%")
	returnedTag = returnedTag.replacingOccurrences(of: "#", with: "\\#")
	returnedTag = returnedTag.replacingOccurrences(of: "&", with: "\\&")
	returnedTag = returnedTag.replacingOccurrences(of: "*", with: "\\*")
	returnedTag = returnedTag.replacingOccurrences(of: "(", with: "\\(")
	returnedTag = returnedTag.replacingOccurrences(of: ")", with: "\\)")
	returnedTag = returnedTag.replacingOccurrences(of: "|", with: "\\|")
	returnedTag = returnedTag.replacingOccurrences(of: "'", with: "\\'")
	returnedTag = returnedTag.replacingOccurrences(of: ";", with: "\\;")
	returnedTag = returnedTag.replacingOccurrences(of: "<", with: "\\<")
	returnedTag = returnedTag.replacingOccurrences(of: ">", with: "\\>")
	returnedTag = returnedTag.replacingOccurrences(of: "\\", with: "\\\\")
	returnedTag = returnedTag.replacingOccurrences(of: "~", with: "\\~")
	returnedTag = returnedTag.replacingOccurrences(of: "`", with: "\\`")
	returnedTag = returnedTag.replacingOccurrences(of: "[", with: "\\[")
	returnedTag = returnedTag.replacingOccurrences(of: "]", with: "\\]")
	returnedTag = returnedTag.replacingOccurrences(of: "{", with: "\\{")
	returnedTag = returnedTag.replacingOccurrences(of: "}", with: "\\}")

	return returnedTag
}

// MARK: - Process

// add journal name and default tags

outputString += dayOneJournal + " --tags "

for defaulTag in defaultTags {
	let tag = defaulTag.replacingOccurrences(of: " ", with: "\\ ")
	outputString += tag + " "
}

// check type of entry and if we need to process tags

let (type, hasTags) = entryType(for: argument)

// add extra default tags for entry type

outputString += type.extraDefaultTags

//-- Process tags if present, otherwise just pass the input

if hasTags {
	
	// find the index of the tags separator
	
	if let endOfTags = argument.index(of: "@") {

		// Map the tags into an array. The first tag (index 0) will be the tag option marker (-t) and will be
		// omitted
		
		let tags = String(argument.prefix(upTo: endOfTags)).split(separator: " ").map{ String($0) }

		// Now process the entryText part to remove the end of tags marker
		
		// get the entryText part of the input
		
		let foodSection = String(argument.suffix(from: endOfTags))
		
		// find the index of the tags separator in this string (different than above)
		
		let endTagIndex = foodSection.index(of: "@")!
		
		// The entryText proper starts after the tags separator
		
		let tagIndex = foodSection.index(after: endTagIndex)

		// get the entryText
		
		entryText = String(foodSection.suffix(from: tagIndex))
		
		// Now we have the entryText, we then process and format the tags
		// Add the tags to the output string separated by spaces
		// skipping the first one which is the `-t` marker
			
		for tag in tags.dropFirst() {
			
			// first we process underscores (_) in tags to replace them with escaped spaces so they're
			// treated as a single tag
			var processedTag = replaceSpaces(in: tag)
			processedTag = removeSpecialCharacters(in: processedTag)

			// here we replace the shorthands for breakfast, lunch, etc.
			
			if tag == "1" {
				processedTag = "breakfast"
			} else if tag == "2" {
				processedTag = "lunch"
			} else if tag == "3" {
				processedTag = "dinner"
			} else if tag == "0" {
				processedTag = "snack"
			}
			
			// add this processed tag to the output string
			
			outputString += processedTag + " "
		}
	}
			
} else {
	
	// no tags, so just pass the input string (entry text) as received
	
	entryText = argument
}

// Add the entryText/symptom to the output string (enclosed in quotes to prevent the CLI to interpret special characters)

outputString += " -- new" + " \"" + type.rawValue + " " + entryText + "\""

// pass the result of the script, we suppress the newline character in the output

print(outputString, terminator:"")
