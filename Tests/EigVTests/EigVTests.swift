import Testing
@testable import EigV

#if os(macOS)
@Suite struct EigVTests {

    @available(macOS 13.3, *)
    @Test func testEigenvaluesOfDiagonalMatrix() throws {
        let matrix = [
            [1.0, 0.0],
            [0.0, 2.0]
        ]
        let result = try eig(matrix)
        let expectedValues = [Complex(1.0, 0.0), Complex(2.0, 0.0)]
        
        #expect(result.values == expectedValues)
    }

    @available(macOS 13.3, *)
    @Test func testEigenvaluesOfSymmetricMatrix() throws {
        let matrix = [
            [2.0, 1.0],
            [1.0, 2.0]
        ]
        let result = try eig(matrix)
        let expectedValues = [Complex(3.0, 0.0), Complex(1.0, 0.0)]
        
        #expect(result.values == expectedValues)
    }

    @available(macOS 13.3, *)
    @Test func testNonSquareMatrixThrowsError() {
        let matrix = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ]
        
        #expect(throws: EigError.nonSquareMatrixInput) {
            try eig(matrix)
        }
    }

    @available(macOS 13.3, *)
    @Test func testComplexEigenvalues() throws {
        let matrix = [
            [0.0, -1.0],
            [1.0, 0.0]
        ]
        let result = try eig(matrix)
        let expectedValues = [Complex(0.0, 1.0), Complex(0.0, -1.0)]
        
        #expect(result.values == expectedValues)
    }

    @available(macOS 13.3, *)
    @Test func testEigenvectors() throws {
        let matrix_2 = [
            [2.0, 0.0],
            [0.0, 3.0]
        ]
        let result_2 = try eig(matrix_2, left: true, right: true)
        
        #expect(result_2.left != nil)
        #expect(result_2.right != nil)
    }

    @available(macOS 13.3, *)
    @Test func testDgeevErrorHandling() {
        let matrix = [[Double]]()
        #expect(throws: EigError.internalError) {
            try eig(matrix)
        }
    }

}
#endif
