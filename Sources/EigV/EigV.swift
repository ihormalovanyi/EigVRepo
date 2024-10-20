import Accelerate.vecLib

public enum EigError: Error, Equatable {
    
    case nonSquareMatrixInput
    case internalError
    
}

/// A structure representing a complex number.
public struct Complex: CustomStringConvertible, Equatable {
    
    /// The real part of the complex number.
    public let real: Double
    
    /// The imaginary part of the complex number.
    public let imaginary: Double
    
    init(_ real: Double, _ imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
    
    /// A textual representation of the complex number.
    public var description: String {
        "\(real)\(imaginary.sign == .minus ? "-" : "+")\(imaginary == 0 ? "0." : "\(abs(imaginary))")j"
    }
    
}

@available(iOS 16.4, *)
@available(macOS 13.3, *)
@available(macCatalyst 16.4, *)
/// Computes the eigenvalues and optionally the left and/or right eigenvectors of a real square matrix.
/// - Parameters:
///   - matrix: A square matrix represented as an array of arrays.
///   - left: A Boolean value indicating whether to compute the left eigenvectors.
///   - right: A Boolean value indicating whether to compute the right eigenvectors.
/// - Throws: `EigError` if the input is invalid or the computation fails.
/// - Returns: A tuple containing the eigenvalues and optional left and right eigenvectors.
public func eig(_ matrix: [[Double]], left: Bool = false, right: Bool = true) throws(EigError) -> (values: [Complex], left: [[Complex]]?, right: [[Complex]]?) {
    let matrixLength = matrix.count
    
    // Ensure the matrix is square.
    guard matrix.allSatisfy({ $0.count == matrixLength }) else {
        throw EigError.nonSquareMatrixInput
    }
    
    // https://netlib.org/lapack/explore-html-3.6.1/d9/d8e/group__double_g_eeigen_ga8ec1625302675b981eb34ed024b27a47.html
    
    // MARK: LAPACK section.
    
    // Define job options for LAPACK function. ACSII char equivalent ('V' = 86 | true, 'N' = 78 | false)
    var jobvl: Int8 = left ? 86 : 78
    var jobvr: Int8 = right ? 86 : 78
    
    var n = Int32(matrixLength)
    var lda = n
    
    // Matrix column-major ordered flat representation
    var a = (0..<matrixLength)
        .map { index in matrix.map { $0[index] } }
        .flatMap { $0 }
    
    // Prepare arrays to receive eigenvalues.
    var wr = [Double](repeating: 0.0, count: matrixLength)
    var wi = [Double](repeating: 0.0, count: matrixLength)
    
    // Prepare arrays to receive eigenvectors.
    var vl: [Double] = [Double](repeating: 0.0, count: matrixLength * matrixLength)
    var ldvl = n
    var vr: [Double]! = [Double](repeating: 0.0, count: matrixLength * matrixLength)
    var ldvr = n
    
    // Workspace variables.
    var work = [Double](repeating: 0.0, count: 4 * matrixLength)
    var lwork = 4 * n
    var info: Int32 = 0

    // Call LAPACK function to compute eigenvalues and eigenvectors.
    dgeev_(&jobvl, &jobvr, &n, &a, &lda, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &work, &lwork, &info)
    
    // Check for computation errors.
    guard info == 0 else {
        throw EigError.internalError
    }
    
    // MARK: Results processing section.
    let values = Array(zip(wr, wi)).map(Complex.init)
    let left = left ? vectors(wi: wi, vx: vl) : nil
    let right = right ? vectors(wi: wi, vx: vr) : nil
    
    return (values, left, right)
}

// Helper function to process eigenvectors.
func vectors(wi: [Double], vx: [Double]) -> [[Complex]] {
    let matrixLength = wi.count
    return (0..<matrixLength).map { row in
        var vector: [Complex] = []
        while vector.count < matrixLength {
            let column = vector.count
            let real = vx[row + matrixLength * column]
            
            if wi[column] == 0 {
                vector.append(Complex(real, 0))
            } else {
                let imag = vx[row + matrixLength * (column + 1)]
                vector.append(Complex(real, imag))
                vector.append(Complex(real, -imag))
            }
        }
        return vector
    }
}
