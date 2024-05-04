import XCTest
@testable import UnityIOSPlugin

final class UnityIOSPluginTests: XCTestCase
{
    var performanceMonitor: PerformanceMonitor!
    
    override func setUpWithError() throws
    {
        super.setUp()
        performanceMonitor = PerformanceMonitor()
    }

    override func tearDownWithError() throws
    {
        performanceMonitor = nil
        super.tearDown()
    }

    func testPerformanceMonitorResponse() throws {
        
        let expectation = XCTestExpectation(description: "Wait for asynchronous operation to complete")
        
        performanceMonitor.startTracking()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5)
        {
            let response = self.performanceMonitor.stopTracking()
            print(response)
            
            self.performanceMonitor.startTracking()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10)
        {
            let response = self.performanceMonitor.stopTracking()
            print(response)
            
            self.performanceMonitor.startTracking()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15)
        {
            let response = self.performanceMonitor.stopTracking()
            print(response)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }

    func testPerformanceExample() throws
    {
        // Measure performance of the PerformanceMonitor Test method.
        measure {
            
        }	
    }
}
