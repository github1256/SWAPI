//
//  SWAPIAppFastTests.swift
//  SWAPIAppFastTests
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import XCTest
@testable import SWAPIApp

class SWAPIAppFastTests: XCTestCase {
    
    // MARK: - Fast Tests: Word Count Extension
    
    func testWordCountExtensionReturnsCorrectCount() {
        let wordCount = SampleText.sampleOpeningCrawl.wordCount
        XCTAssertEqual(wordCount, 78)
    }
    
    func testWordCountExtensionReturnsCorrectCountForSampleText() {
        let wordCount = SampleText.sampleTextWithContractions.wordCount
        XCTAssertEqual(wordCount, 31)
    }
}

struct SampleText {
    static var sampleOpeningCrawl = "Luke Skywalker has returned to\r\nhis home planet of Tatooine in\r\nan attempt to rescue his\r\nfriend Han Solo from the\r\nclutches of the vile gangster\r\nJabba the Hutt.\r\n\r\nLittle does Luke know that the\r\nGALACTIC EMPIRE has secretly\r\nbegun construction on a new\r\narmored space station even\r\nmore powerful than the first\r\ndreaded Death Star.\r\n\r\nWhen completed, this ultimate\r\nweapon will spell certain doom\r\nfor the small band of rebels\r\nstruggling to restore freedom\r\nto the galaxy..."
    static var sampleTextWithContractions = "This will be a random string with random contractions so that we can test whether it'll be able to parse word counts correctly. It'll be interesting to see, don't you think?"
}
