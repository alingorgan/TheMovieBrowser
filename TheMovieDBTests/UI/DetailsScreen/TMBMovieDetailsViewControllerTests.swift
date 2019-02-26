//
//  TMBMovieDetailsViewControllerTests.swift
//  TheMovieDBTests
//
//  Created by Alin Gorgan on 2/26/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

@testable import TheMovieDB
import XCTest

final class TMBMovieDetailsViewControllerTests: XCTestCase {
    
    private var subject: TMBMovieDetailsViewController!
    private var view: UIView!
    private var moviewPosterImageView: UIImageView!
    
    override func setUp() {
        super.setUp()
        
        view = UIView()
        moviewPosterImageView = UIImageView()
        
        subject = TMBMovieDetailsViewController()
        subject.view = UIView()
        subject.imageView = moviewPosterImageView
    }
    
    override func tearDown() {
        view = nil
        subject = nil
        moviewPosterImageView = nil
        
        super.tearDown()
    }
    
    func test_viewWillAppear_notifiesPresenter() {
        var didLoadCalled = false
        
        let stubPresenter = TMBStubPopularMoviePresenter()
        stubPresenter.didLoadCalledStub = { _ in didLoadCalled = true}
        subject.presenter = stubPresenter
        
        subject.viewWillAppear(true)
        
        XCTAssertTrue(didLoadCalled)
    }
    
    func test_viewModel_updatedWithNewData_updatesTheUI() {
        
        let stubInitialViewModel = TMBMovieDetailsViewModel(title: "",
                                                            moviePoster: UIImage.from(color: .white),
                                                            backgroundColor: UIColor.black)
        
        let stubUpdatedViewModel =  TMBMovieDetailsViewModel(title: "",
                                                             moviePoster: UIImage.from(color: .green),
                                                             backgroundColor: UIColor.yellow)
        
        subject.viewModel = stubInitialViewModel
        XCTAssertEqual(subject.view.backgroundColor, stubInitialViewModel.backgroundColor)
        XCTAssertEqual(subject.title, stubInitialViewModel.title)
        XCTAssertEqual(subject.imageView.image, stubInitialViewModel.moviePoster)
        
        subject.viewModel = stubUpdatedViewModel
        XCTAssertEqual(subject.view.backgroundColor, stubUpdatedViewModel.backgroundColor)
        XCTAssertEqual(subject.title, stubUpdatedViewModel.title)
        XCTAssertEqual(subject.imageView.image, stubUpdatedViewModel.moviePoster)
    }
    
    
}

extension UIImage {
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
