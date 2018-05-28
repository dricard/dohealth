# DOHEALTH Script for Alfred.app

[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)  [![Twitter](https://img.shields.io/badge/twitter-@hexaedre-blue.svg?style=flat)](https://twitter.com/hexaedre)  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**DOHEALTH** is a script, written in **Swift**, that is used in an [Alfred][alfred] / [workflow][workflows] to write health informaiton to a [Day One 2][dayone] journal.

### What it does

It takes an input string as part of an Alfred action and creates an entry in a health journalyou specify in [Day One][dayone] with the content of the entry formated with a prefix depending on the type of data you're logging, i.e., `eaten:`, or `drank:` plus the input string and with optional tags.

The idea is to be able to quickly log health related information during the day with as little friction as possible. This can be used later to see patterns in your habits (eating some food is followed by these symptoms, etc.), or to report to a nutritionist or doctor. Many things can be logged automatically with IFTTT (like weight measurement taken with a smart scale, which can be directed to log into the same health journal), but some things fall outside of the automation capabilities. This is for those things you want to track.

### Installation

You need a few things to make use of this script:

#### What you need

- you need the latest version of [Day One 2][dayone]
- you must have installed the Day One CLI (command line interface): menu `/Day One/Install Command Line Tools.../` and follow the instructions.
- you need to have [Aldred][alfred] installed, with a [PowerPack][powerpack] license (required to use [workflows][workflows])

#### Installation

- download and unzip the `dohealth` package.
- double-click the `.alfredworkflow` file to install the workflow in Alfred.
- open the workflow and double-click the `external script` module.
- click the `open workflow folder in finder` button to the left of the `cancel`button. ![button](http://hexaedre.com/resources/alfredOpenFolder.png)
- copy the `DoHealthLogger` file (the one without extension) from the `dohealth` package to the workflow folder.
- you can close the workflow folder and Alfred's preferences window.
- you're good to go!

#### Usage

Invoke Alfred (for me this is `⌘-space`), type `dohealth` (although I can usually just type `doh`) then `return` to select the workflow, then type the text you want to log, and press `return`.

The default entry is for something you ate and the script will create a journal entry stating that you ate, with the default tags specified in the script. So `⌘-space` `doh` `return` `a muffin and a glass of milk` `return` will create a journal entry `eaten: a muffin and a glass of milk` with tags `dohealth` and `health` for instance.

There are five types of things you can track with DoHealth:

- food (what you ate)
- symptoms (how you feel, cramps, headache, etc.)
- medication (what you took, including vitamines or food supplements)
- water (how much you drank if you want to track this — and you should!)
- measurements (things like blood sugar, ketone levels, weight, blood pressure, etc.)

Each of those has a specific prefix to use when invoking the script, and each one will begin the journal entry with a different prefix as well as including specific tags in addition to the default ones.

The pattern is always the same for each type:

A 'option flag' to determine which type of entry it is, followed by 0 or more optional tags, then the '@' character and the entry text.

Examples:

A measurement entry:
-l cetone @0.1 mmol/l

A medication entry:
-m matin @vitamines B complex, B2, D, C, Omega-3

#### Entry types syntax

##### Food

`-t optinal_tag @food eaten`

##### Symptom

`-s optinal_tag @symptom observed`

##### Medication

`-m optinal_tag @medication taken`

##### Water

`-w optinal_tag @water drank`

##### Measurement

`-l optinal_tag @measurement results`

#### Default tags

All entries will have the `santé` and the `dohealth` tags added by default.

#### Swift version

This script is made for **Swift 4.0**.

#### Modifying the script

You can modify for example the default journal to log into, the default tags, etc. by modifying the script in the included `DoHealthLogger.swift` file. You must then compile the script and make it executable and put it in the workflow folder.

#### How to contribute

I'm always happy to improve my code and learn, so if you find things to improve please submit a pull request.

##### Here are some ways you can contribute:

* by reporting bugs
* by writing or editing documentation
* by writing code ( no patch is too small : fix typos, add comments, clean up * inconsistent whitespace )
* by refactoring code
* by closing issues
* by reviewing patches
* Submitting an Issue

I use the GitHub issue tracker to track bugs and features. Before submitting a bug report or feature request, check to make sure it hasn't already been submitted.

##### Submitting a Pull Request

1. Fork the repository.
1. Create a topic branch.
1. Implement your feature or bug fix.
1. Add, commit, and push your changes.
1. Submit a pull request.

This is based on [https://github.com/middleman/middleman-heroku/blob/master/CONTRIBUTING.md](https://github.com/middleman/middleman-heroku/blob/master/CONTRIBUTING.md)

#### License

Dolog is Copyright © 2017 Denis Ricard. It is free software, and may be redistributed under the terms specified in the LICENSE file.

#### About

I'm an iOS developer. You can find my web site at [hexaedre.com](http://hexaedre.com), find me on Twitter under [@hexaedre](http://twitter.com/hexaedre), or [contact me](http://hexaedre.com/contact/).

[dayone]: http://dayoneapp.com
[alfred]: https://www.alfredapp.com
[workflows]: https://www.alfredapp.com/workflows/
[powerpack]: https://www.alfredapp.com/powerpack/
[dolog]: http://hexaedre.com/scripts/dolog/