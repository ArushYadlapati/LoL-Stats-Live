import SwiftUI

struct ContentView: View {
    @State private var responseText = "Press Refresh to Load Data"
    
    let urlString = "https://api.pandascore.co/lol/matches?filter%5Bstatus%5D=running"
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                Text(responseText)
                    .padding()
                    .font(.system(size: 14, design: .monospaced))
            }
            
            Button("Refresh") {
                fetchMatches()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
    
    func fetchMatches() {
        guard let url = URL(string: urlString) else {
            responseText = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    responseText = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    responseText = "No data received"
                }
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    responseText = jsonString
                }
            } else {
                DispatchQueue.main.async {
                    responseText = "Responses are certified Gluten Free (cooked)"
                }
            }
        }
        
        task.resume()
    }
}

@main
struct CurlApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
