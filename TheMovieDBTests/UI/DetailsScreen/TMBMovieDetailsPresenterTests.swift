//
//  TMBMovieDetailsPresenterTests.swift
//  TheMovieDBTests
//
//  Created by Alin Gorgan on 2/26/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

@testable import TheMovieDB
import XCTest

final class TMBMovieDetailsPresenterTests: XCTestCase {
    
    private var subject: TMBMovieDetailsPresenter!
    private var stubInteractor: TMBStubMovieDetailsInteractor!
    private var stubView: TMBMockMovieDetailsView!
    
    override func setUp() {
        super.setUp()
        
        stubInteractor = TMBStubMovieDetailsInteractor()
        subject = TMBMovieDetailsPresenter(interactor: stubInteractor)
        stubView = TMBMockMovieDetailsView()
    }
    
    override func tearDown() {
        stubInteractor = nil
        subject = nil
        stubView = nil
        
        super.tearDown()
    }
    
    func test_didLoad_updatesTheViewModel() {
        stubInteractor.loadImageForResultCalled = { }
        
        subject.didLoad(view: stubView)
        
        XCTAssertNotNil(stubView.viewModel)
    }
    
    func test_didLoad_notifiesTheInteractor() {
        var loadImageForResultCalled = false
        stubInteractor.loadImageForResultCalled = { loadImageForResultCalled = true }
        
        subject.didLoad(view: stubView)
        
        XCTAssertTrue(loadImageForResultCalled)
    }
    
}
