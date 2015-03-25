//
//  ImgurUploaderTests.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/23/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import XCTest
import CoreGraphics
import Quick
import Nimble
import Mockingjay
import ShakedownSample

class ImgurUploaderTests: ImageUploaderTests {

    override var uploader: ImageUploader {
        return ImgurUploader(clientID: "TestClientID")
    }
    
    override var expectedURL: NSURL {
        return NSURL(string: "http://i.imgur.com/HV2zEeU.png")!
    }
    
    override func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        expect(request.URL.absoluteString) == "https://api.imgur.com/3/image"
        expect(request.valueForHTTPHeaderField("Authorization")) == "Client-ID TestClientID"
        expect(request.HTTPMethod) == "POST"
        let response = NSHTTPURLResponse(URL: request.URL, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, json("Imgur"))
    }
    
}
