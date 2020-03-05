//
//  DownloadOperation.swift
//  Maps
//
//  Created by Anna Bibyk on 04.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation

class DownloadOperation : Operation {
    
    private var task : URLSessionDownloadTask!
    
    enum OperationState : Int {
        case ready
        case executing
        case finished
    }

    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    
    init(session: URLSession, downloadTaskURL: URL, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) {
        super.init()
        
        task = session.downloadTask(with: downloadTaskURL, completionHandler: { [weak self] (localURL, response, error) in
            if let completionHandler = completionHandler {
                completionHandler(localURL, response, error)
            }
            self?.state = .finished
        })
    }
    
    override func start() {
        
        if(self.isCancelled) {
            state = .finished
            return
        }
        state = .executing
        
        print("downloading \(self.task.originalRequest?.url?.absoluteString)")
        
        self.task.resume()
    }

    override func cancel() {
        super.cancel()
      
        self.task.cancel()
    }
}
