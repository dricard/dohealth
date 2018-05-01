#!/usr/bin/env xcrun swift

import Foundation

/* *********************************
	 		DOEAT Script
   ********************************* */


/* *********************************
	 MODIFY THESE 3 PROPERTIES
	         AS NEEDED
********************************* */

// the journal to log to in Day One

let dayOneJournal = "foodjournal"

// the default tag(s) to add to all entries. If you don't
// add at least one default tag, you'll have to modify the code below.
// tags *can* have spaces

let defaultTags = ["doeat", "journal alimentaire", "cétogène"]

// the entry prefix

let entryPrefix = "mangé:"

/* ********************************* */


// requires Swift 4.0
// might work with Swift 2.0 but is untested
// Will not work with Swift 1.0


//-- get parameter input
// `argument` holds the text entered in Alfred by the user
// I initialize it with an example of something the user could enter
// for testing. 

var argument = "-t breakfast @œufs et bacon, café"
#if swift(>=4.0)
	if CommandLine.arguments.count > 1 {
		argument = CommandLine.arguments[1]
	}
#elseif swift(>=1.0)
	print("Unsupported version of Swift (<= 4.0) please update to Swift 4.0")
	break
#endif

// MARK: - Properties

// variable 'food' will hold the food passed in

var food  = ""

// `outputString` is the result of the script that will be passed to the CLI, 
// we initialize it with the Day One CLI command, setting the default journal
// and the default tags.

var outputString: String = "dayone2 --journal "

// add journal name and default tags

outputString += dayOneJournal + " --tags "

for defaulTag in defaultTags {
	let tag = defaulTag.replacingOccurrences(of: " ", with: "\\ ")
	outputString += tag + " "
}

// MARK: - Process input

//-- Test if tags are present

// weHaveTags is true if there are tags present

let weHaveTags = argument.hasPrefix("-t")

//-- Process tags if present, otherwise just pass the input

if weHaveTags {
	
	// find the index of the tags separator
	
	if let endOfTags = argument.index(of: "@") {

		// Map the tags into an array. The first tag (index 0) will be the tag option marker (-t) and will be
		// omitted
		
		let tags = String(argument.prefix(upTo: endOfTags)).split(separator: " ").map{ String($0) }
		
		// Now process the food part to remove the end of tags marker
		
		// get the food part of the input
		
		let foodSection = String(argument.suffix(from: endOfTags))
		
		// find the index of the tags separator in this string (different than above)
		
		let endTagIndex = foodSection.index(of: "@")!
		
		// The food proper starts after the tags separator
		
		let tagIndex = foodSection.index(after: endTagIndex)

		// get the food
		
		food = String(foodSection.suffix(from: tagIndex))
		
		// Now we have the food, we then process and format the tags
		// Add the tags to the output string separated by spaces
		// skipping the first one which is the `-t` marker
			
		for i in 1..<tags.count {
			
			// first we process underscores (_) in tags to replace them with escaped spaces so they're
			// treated as a single tag
			
			var tag = tags[i].replacingOccurrences(of: "_", with: "\\ ")
			
			// escape special characters
			// ! ? $ % # & * ( ) blank tab | ' ; " < > \ ~ ` [ ] { }
				
			tag = tags[i].replacingOccurrences(of: "!", with: "\\!")
			tag = tags[i].replacingOccurrences(of: "?", with: "\\?")
			tag = tags[i].replacingOccurrences(of: "$", with: "\\$")
			tag = tags[i].replacingOccurrences(of: "%", with: "\\%")
			tag = tags[i].replacingOccurrences(of: "#", with: "\\#")
			tag = tags[i].replacingOccurrences(of: "&", with: "\\&")
			tag = tags[i].replacingOccurrences(of: "*", with: "\\*")
			tag = tags[i].replacingOccurrences(of: "(", with: "\\(")
			tag = tags[i].replacingOccurrences(of: ")", with: "\\)")
			tag = tags[i].replacingOccurrences(of: "|", with: "\\|")
			tag = tags[i].replacingOccurrences(of: "'", with: "\\'")
			tag = tags[i].replacingOccurrences(of: ";", with: "\\;")
			tag = tags[i].replacingOccurrences(of: "<", with: "\\<")
			tag = tags[i].replacingOccurrences(of: ">", with: "\\>")
			tag = tags[i].replacingOccurrences(of: "\\", with: "\\\\")
			tag = tags[i].replacingOccurrences(of: "~", with: "\\~")
			tag = tags[i].replacingOccurrences(of: "`", with: "\\`")
			tag = tags[i].replacingOccurrences(of: "[", with: "\\[")
			tag = tags[i].replacingOccurrences(of: "]", with: "\\]")
			tag = tags[i].replacingOccurrences(of: "{", with: "\\{")
			tag = tags[i].replacingOccurrences(of: "}", with: "\\}")

			// here we replace the shorthands for breakfast, lunch, etc.
			
			if tags[i] == "1" {
				tag = "déjeuner"
			} else if tags[i] == "2" {
				tag = "dîner"
			} else if tags[i] == "3" {
				tag = "souper"
			} else if tags[i] == "0" {
				tag = "collation"
			}
			
			// add this processed tag to the output string
			
			outputString += tag + " "
		}
	} else {

		// user forgot the '@' separator so just pass the input string (food) as received
	
		food = argument
		
	}
		
} else {
	
	// no tags, so just pass the input string (food) as received
	
	food = argument
}

// Add the food to the output string (enclosed in quotes to prevent the CLI to interpret special characters)

outputString += " -- new" + " \"" + entryPrefix + " " + food + "\""

// pass the result of the script, we suppress the newline character in the output

print(outputString, terminator:"")
