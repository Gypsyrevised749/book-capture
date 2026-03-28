import Foundation
import Vision

// MARK: - Vision OCR CLI
// Usage: swift vision-ocr.swift <image_path> [--lang ja,en]
// Output: JSON { "text": "...", "confidence": 0.95, "blocks": [...] }

struct OCRBlock: Codable {
    let text: String
    let confidence: Float
    let boundingBox: [Double] // [x, y, width, height] normalized
}

struct OCRResult: Codable {
    let text: String
    let confidence: Float
    let blocks: [OCRBlock]
    let pageCount: Int
}

func isRTLLanguage(_ languages: [String]) -> Bool {
    // Japanese vertical text (tategaki) reads right-to-left across columns
    return languages.first == "ja"
}

func performOCR(imagePath: String, languages: [String]) throws -> OCRResult {
    guard FileManager.default.fileExists(atPath: imagePath) else {
        throw NSError(domain: "OCR", code: 1, userInfo: [NSLocalizedDescriptionKey: "Image not found: \(imagePath)"])
    }

    let imageURL = URL(fileURLWithPath: imagePath)

    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil),
          let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
        throw NSError(domain: "OCR", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to load image: \(imagePath)"])
    }

    let semaphore = DispatchSemaphore(value: 0)
    var ocrBlocks: [OCRBlock] = []
    var ocrError: Error?

    let request = VNRecognizeTextRequest { request, error in
        if let error = error {
            ocrError = error
            semaphore.signal()
            return
        }

        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            semaphore.signal()
            return
        }

        for observation in observations {
            guard let candidate = observation.topCandidates(1).first else { continue }
            let box = observation.boundingBox
            let block = OCRBlock(
                text: candidate.string,
                confidence: candidate.confidence,
                boundingBox: [
                    Double(box.origin.x),
                    Double(box.origin.y),
                    Double(box.size.width),
                    Double(box.size.height)
                ]
            )
            ocrBlocks.append(block)
        }
        semaphore.signal()
    }

    request.recognitionLevel = .accurate
    request.recognitionLanguages = languages
    request.usesLanguageCorrection = true

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    try handler.perform([request])
    semaphore.wait()

    if let error = ocrError {
        throw error
    }

    // Sort blocks by position:
    // - For Japanese vertical text (RTL): top-to-bottom, then RIGHT-to-LEFT (columns read right to left)
    // - For horizontal text (LTR): top-to-bottom, then left-to-right
    let rtl = isRTLLanguage(languages)
    let sorted = ocrBlocks.sorted { a, b in
        let ay = 1.0 - a.boundingBox[1] // Flip Y (Vision uses bottom-left origin)
        let by = 1.0 - b.boundingBox[1]
        if abs(ay - by) > 0.02 { // Same row threshold
            return ay < by
        }
        if rtl {
            return a.boundingBox[0] > b.boundingBox[0] // Right-to-left for vertical Japanese
        }
        return a.boundingBox[0] < b.boundingBox[0] // Left-to-right for horizontal text
    }

    let fullText = sorted.map { $0.text }.joined(separator: "\n")
    let avgConfidence: Float = sorted.isEmpty ? 0.0 :
        sorted.reduce(0.0) { $0 + $1.confidence } / Float(sorted.count)

    return OCRResult(
        text: fullText,
        confidence: avgConfidence,
        blocks: sorted,
        pageCount: 1
    )
}

// MARK: - Main

func main() {
    let args = CommandLine.arguments

    guard args.count >= 2 else {
        let errorJSON = "{\"error\": \"Usage: swift vision-ocr.swift <image_path> [--lang ja,en]\"}"
        FileHandle.standardError.write(errorJSON.data(using: .utf8)!)
        exit(1)
    }

    let imagePath = args[1]

    // Parse --lang argument
    var languages = ["ja", "en"]
    if let langIdx = args.firstIndex(of: "--lang"), langIdx + 1 < args.count {
        languages = args[langIdx + 1].split(separator: ",").map(String.init)
    }

    // Resolve to absolute path
    let absolutePath: String
    if imagePath.hasPrefix("/") {
        absolutePath = imagePath
    } else {
        absolutePath = FileManager.default.currentDirectoryPath + "/" + imagePath
    }

    do {
        let result = try performOCR(imagePath: absolutePath, languages: languages)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(result)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }
    } catch {
        let escaped = error.localizedDescription
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        let errorJSON = "{\"error\": \"\(escaped)\"}"
        FileHandle.standardError.write(errorJSON.data(using: .utf8)!)
        exit(1)
    }
}

main()
