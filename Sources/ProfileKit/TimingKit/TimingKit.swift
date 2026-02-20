//
//  TimingKit.swift
//  ProfileKit
//
//  Created by Денис Солодовник on 20.02.2026.
//

import Foundation

public struct TimingKitParameters {

    let logEnabled: Bool
    let prefix: String
    let decimalCount: Int
    let skipFirstChecks: Int
    let numberOfChecks: Int

    /// Options Constructor
    /// - Parameters:
    ///   - logEnabled: Should the result be printed to the console?
    ///   - decimalCount: Number of decimal part
    ///   - numberOfChecks: Number of code checks
    public init(
        logEnabled: Bool = true,
        prefix: String = "Test result",
        decimalCount: Int = 5,
        skipFirstChecks: Int = 50,
        numberOfChecks: Int = 150
    ) {
        self.logEnabled = logEnabled
        self.prefix = prefix
        self.decimalCount = decimalCount
        self.skipFirstChecks = skipFirstChecks
        self.numberOfChecks = numberOfChecks
    }
}

#if PROFILERKIT_ENABLED

// TimingKit is used to test code execution speed.

public struct TimingKit {

    /// Testing code execution speed
    /// - Parameters:
    ///   - function: your code closure
    ///   - parameters: Fine tuning parameters
    /// - Returns: Code execution time in seconds
    public func test(
        function: () -> Void,
        parameters: TimingKitParameters = .init()
    ) -> Double {

        let count = max(parameters.numberOfChecks, 15)

        var timings: [Double] = []
        for index in 0..<count {
            let startTime = CFAbsoluteTimeGetCurrent()
            function()
            let endTime = CFAbsoluteTimeGetCurrent() - startTime
            if index > parameters.skipFirstChecks {
                timings.append(endTime)
            }
        }

        let timing = timings.reduce(0, +) / Double(count)

        if parameters.logEnabled {
            let str = String(format: "\(parameters.prefix): %.\(parameters.decimalCount)f sec.", timing)
            print(str)
        }

        return timing
    }
}

#else
public struct TimingKit {

    public init() {}

    @discardableResult
    public func test(
        function: () -> Void,
        parameters: TimingKitParameters = .init()
    ) -> Double {
        return -1
    }
}
#endif
