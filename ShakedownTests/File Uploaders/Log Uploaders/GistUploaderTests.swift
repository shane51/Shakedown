//
//  GistUploaderTests.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/23/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Mockingjay
import ShakedownSample

class GistUploaderTests: LogUploaderTests {
    
    override var expectedURL: NSURL {
        return NSURL(string: "https://gist.github.com/250756d267ea0646eb74")!
    }
    
    override func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        expect(request.URL.absoluteString) == "https://api.github.com/gists"
        expect(request.valueForHTTPHeaderField("Authorization")) == "token TestToken"
        let data = request.HTTPBody ?? request.HTTPBodyStream?.synchronouslyRead()
        let parsedJSON: AnyObject = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)!
        expect(parsedJSON.description) == jsonObject("GistRequest").description
        expect(request.HTTPMethod) == "POST"
        let response = NSHTTPURLResponse(URL: request.URL, statusCode: 201, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, jsonData("Gist"))
    }

    override var uploader: LogUploader {
        return GistUploader(authenticationToken: "TestToken")
    }
    
}
