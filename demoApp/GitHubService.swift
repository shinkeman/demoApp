import Foundation

class GitHubService {
    enum ServiceError: Error, CustomStringConvertible {
        case urlCreation
        case network
        case parsing

        var description: String {
            switch self {
            case .urlCreation:
                return "Error Initializing URL."
            case .network:
                return "Network error: Please check on connection."
            case .parsing:
                return "Error parsing response."
            }
        }
    }

    static private let baseUrl: String = "https://api.github.com/search/repositories?q="

    static func fetchRepositories(query: String) async throws -> [RepositoryModel] {
        guard let urlString = "\(baseUrl)\(query)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed), let url = URL(string: urlString)
        else {
            throw ServiceError.urlCreation
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 180

        var data: Data!
        var response: URLResponse!
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw ServiceError.network
        }

        if let response = response as? HTTPURLResponse {
            let statusCode = response.statusCode
            if !(200...300 ~= statusCode ) {
                throw ServiceError.network
            }
        } else {
            throw ServiceError.network
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedResponse = try decoder.decode(RepositoryResponse.self, from: data)
            return decodedResponse.items
        } catch {
            throw ServiceError.parsing
        }
    }
}
