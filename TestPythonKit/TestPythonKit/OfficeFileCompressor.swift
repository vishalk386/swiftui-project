//
//  OfficeFileCompressor.swift
//  TestPythonKit
//
//  Created by Vishal Kamble on 04/10/23.
//

import Foundation

class OfficeFileCompressor {
    private let pythonProcess: Process
    
    init() {
        self.pythonProcess = Process()
        if let pythonScriptsFolder = Bundle.main.path(forResource: "PythonScripts", ofType: nil) {
            self.pythonProcess.launchPath = "/usr/bin/python3" // Path to Python interpreter
            self.pythonProcess.arguments = ["-c", """
                import sys
                sys.path.append("\(pythonScriptsFolder)")
                from compress_office import compress
            """]
            self.pythonProcess.launch()
        } else {
            print("Python scripts folder not found in the app bundle.")
        }
    }
    
    deinit {
        self.pythonProcess.terminate()
        self.pythonProcess.waitUntilExit()
    }
    
    func compressOfficeFiles(filePaths: [String]) {
        let compressScript = """
            result = compress(\(filePaths))
            print(result)
        """
        let output = self.runPythonScript(script: compressScript)
        print(output)
    }
    
    private func runPythonScript(script: String) -> String {
        let pipe = Pipe()
        self.pythonProcess.standardOutput = pipe
        let errorPipe = Pipe()
        self.pythonProcess.standardError = errorPipe
        self.pythonProcess.arguments = ["-c", script]
        self.pythonProcess.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        self.pythonProcess.waitUntilExit()
        let output = String(data: data, encoding: .utf8) ?? ""
        let error = String(data: errorData, encoding: .utf8) ?? ""
        if !error.isEmpty {
            print("Error running Python script: \(error)")
        }
        return output
    }
}



class PythonWrapper {
    private let pythonProcess: Process
    
    init() {
        self.pythonProcess = Process()
        self.pythonProcess.launchPath = "/usr/bin/python3" // Path to Python interpreter
    }
    
    func compressFiles(filePaths: [String]) {
        let script = """
            from compress_office import compress
            import sys
            compress(\(filePaths))
        """
        self.runPythonScript(script: script)
    }
    
    private func runPythonScript(script: String) {
        let pipe = Pipe()
        self.pythonProcess.standardOutput = pipe
        self.pythonProcess.arguments = ["-c", script]
        self.pythonProcess.launch()
        self.pythonProcess.waitUntilExit()
        
    }
    
    
    
}
