//
//  TimingKit.swift
//  ProfileKit
//
//  Created by Денис Солодовник on 20.02.2026.
//

import Foundation

#if PROFILERKIT_ENABLED

public struct TimingKit {

    public init() {}

    @discardableResult
    public func test(
        function: () -> Void,
        count: Int = 15,
        name: String = #function
    ) -> Double {

        let maxCount = max(count, 15)

        var timings: [Double] = []
        for index in 0..<maxCount {
            let startTime = CFAbsoluteTimeGetCurrent()
            function()
            let endTime = CFAbsoluteTimeGetCurrent() - startTime
            if index > 3 {
                timings.append(endTime)
            }
        }

        let timing = timings.reduce(0, +) / Double(count)
        print(String(format: "%s: %.5f sec.", name, timing))

        return timing
    }
}

#else
public struct TimingKit {

    public init() {}
    public func test(
        function: () -> Void,
        count: Int = 15,
        name: String = #function
    ) -> Double {
        return -1
    }
}
#endif
