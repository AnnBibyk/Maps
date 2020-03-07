//
//  DownloadOperator.swift
//  Maps
//
//  Created by Anna Bibyk on 05.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation

protocol DownloadOperatorDelegate {
    func updateProgress(progress: Float)
}

enum OperationState : Int {
    case ready
    case executing
    case finished
}

class DownloadOperation : Operation {
    
    private var task : URLSessionDownloadTask!
    private var observation: NSKeyValueObservation?
    var downloadProgress : Float?
    var delegate: DownloadOperatorDelegate?

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
        
        print("downloading \(self.task.originalRequest?.url?.absoluteString ?? "")")
        
        observation = task.progress.observe(\.fractionCompleted) { progress, _ in
            self.downloadProgress = Float(progress.fractionCompleted)
            self.delegate?.updateProgress(progress: self.downloadProgress!)
        }
        self.task.resume()
    }
    
    deinit {
        observation?.invalidate()
    }
    
    override func cancel() {
        super.cancel()
        
        self.task.cancel()
    }

}

