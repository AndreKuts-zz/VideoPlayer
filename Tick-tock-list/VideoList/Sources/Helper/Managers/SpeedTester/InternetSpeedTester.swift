//
//  InternetSpeedTester.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/28/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation

typealias InternetSpeedTesterCompletionHandler = (_ error: Error?, _ megabytesPerSecond: Double?) -> Void

private struct Constant {
    static let defaultTimeoutInterval: Double = 7.0
    static let kilobytesInMegabyte: Double = 1024
    static let timeNotDefined: Double = 0.0
}

final class InternetSpeedTester: NSObject, InternetSpeedTesterProtocol {

    var speedTestCompletionBlock: InternetSpeedTesterCompletionHandler?

    private var startTime: CFAbsoluteTime = Constant.timeNotDefined
    private var stopTime: CFAbsoluteTime = Constant.timeNotDefined
    private var bytesReceived: Int = 0

    private var session: URLSession?
    private var url: URL?
    private var currentTask: URLSessionDataTask?

    init(url: URL, speedTestCompletionBlock: @escaping InternetSpeedTesterCompletionHandler) {
        super.init()

        self.url = url
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = Constant.defaultTimeoutInterval

        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        self.speedTestCompletionBlock = speedTestCompletionBlock
    }

    // MARK: - InternetSpeedCheckProtocol

    func startSpeedTracking() {
        guard let url = url else {
            return
        }
        stopSpeedTracking()
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0

        currentTask = session?.dataTask(with: url)
        currentTask?.resume()
    }

    func stopSpeedTracking() {
        currentTask?.cancel()
    }
}

// MARK: - URLSessionDelegate

extension InternetSpeedTester: URLSessionDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
    }
}

// MARK: - URLSessionDataDelegate

extension InternetSpeedTester: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let elapsedTime = stopTime - startTime
        if let aTempError = error as NSError?,
            aTempError.domain != NSURLErrorDomain,
            aTempError.code != NSURLErrorTimedOut,
            elapsedTime == Constant.timeNotDefined {
            speedTestCompletionBlock?(error, nil)
            return
        }
        setSpeedResult(elapsedTime)
    }

    private func setSpeedResult(_ elapsedTime: Double) {
        let speed = getSpeed(bytesReceived: Double(bytesReceived), elapsedTime: elapsedTime)
        speedTestCompletionBlock?(nil, speed)
    }

    private func getSpeed(bytesReceived: Double, elapsedTime: Double) -> Double {
        return bytesReceived / elapsedTime / Constant.kilobytesInMegabyte
    }
}
