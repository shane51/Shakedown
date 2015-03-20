//
//  JIRAReporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/20/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

class JIRAReporter: Reporter {

    // JIRA instance URL. This will be something like https://yourcompany.atlassian.net
    let instanceURL: String
    // JIRA username/password
    // Issues will show as being created by this user, so you may wish to create an "API User" account to use
    // If you submit a build to the App Store with this token included, people may be able to extract it, so _MAKE SURE_ the account is limited
    let username, password: String
    // JIRA Project key. This is the prefix before the ticket number, i.e. if had ticket MG-300, your project key would be MG
    let projectKey: String
    // Issue type to create. If you don't track bugs as "Bug," (like, if everything is a "Task" or something dumb like that) you probably want to change this
    let issueType: String
    // If your project has a specific field for reproducibility, specify it here, otherwise reproducibility will be appended to the description in JIRA
    // If you set this field, it's _suuuuuuuper_ important you make sure Shakedown.reproducibilityOptions is accurate, because if it's not, JIRA will
    // reject tickets with invalid reproducibility values
    let reproducibilityField: String?
    
    init(instanceURL: String, username: String, password: String, projectKey: String, issueType: String = "Bug", reproducibilityField: String? = nil) {
        self.instanceURL = instanceURL
        self.username = username
        self.password = password
        self.projectKey = projectKey
        self.issueType = issueType
        self.reproducibilityField = reproducibilityField
        super.init()
    }

    override func fileBugReport(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ReportCompletion) {
        uploadImagesAndLogs(report, imageUploader: imageUploader, logUploader: logUploader) { screenshotURL, logURL, error in
            if error ==  nil {
                self.uploadReport(report, screenshotURL: screenshotURL, logURL: logURL, completion: completion)
            } else {
                completion(completionText: nil, error: error)
            }
        }
    }
    
    func uploadReport(report: BugReport, screenshotURL: NSURL?, logURL: NSURL?, completion: ReportCompletion) {
        let description = issueBody(report, screenshotURL: screenshotURL, logURL: logURL)
        let body = [
            "fields": [
                "project" : ["key" : projectKey],
                "summary": report.title,
                "description": issueBody(report, screenshotURL: screenshotURL, logURL: logURL),
                "issuetype": ["name" : issueType]
            ]
        ]
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "\(instanceURL)/rest/api/2/issue/")!)
        let bodyData = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: nil)
        request.HTTPBody = bodyData
        request.HTTPMethod = "POST"
        let authString = "\(username):\(password)"
        let base64Auth = authString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.base64EncodedStringWithOptions(nil)
        request.allHTTPHeaderFields = [
            "Authorization" : "Basic \(base64Auth!)",
            "Content-Type": "application/json"
        ]
        session.dataTaskWithRequest(request) { data, _, error in
            let data = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject]
            let id = data?["key"] as? String ?? ""
            completion(completionText: id, error: error)
            }.resume()
        
    }

    func issueBody(report: BugReport, screenshotURL: NSURL?, logURL: NSURL?) -> String {
        var strung = "\(report.description)\n\n"
        if reproducibilityField == nil {
            strung += "h4. Reproducibility\n \(report.reproducibility)\n\n"
        }
        if report.reproductionSteps.count > 0 {
            strung += "h4. Steps to Reproduce\n"
            strung += "\n".join(report.reproductionSteps.map { "# \($0)" })
            strung += "\n\n"
        }
        if let screenshotURLString = screenshotURL?.absoluteString {
            strung += "h4. Screenshot\n !\(screenshotURLString)!\n\n"
        }
        if let logURLString = logURL?.absoluteString {
            strung += "h4. Logs\n \(logURLString)\n\n"
        }
        return strung
    }


}