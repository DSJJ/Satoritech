//
//  UserService.swift
//  Satoritech
//
//  Created by David Jiménez  on 17/07/25.
//

import Foundation
import Combine

protocol UserServiceProtocol {
  func fetchUsers(matching query: String) -> AnyPublisher<[UserDTO], Error>
}

class UserService: UserServiceProtocol {
  func fetchUsers(matching query: String) -> AnyPublisher<[UserDTO], Error> {
    guard var components = URLComponents(string: "https://mockUser.com") else {
      return Fail(error: ServiceError.invalidURL).eraseToAnyPublisher()
    }
    
    components.queryItems = [URLQueryItem(name: "q", value: query)]
    guard let url = components.url else {
      return Fail(error: ServiceError.invalidURL).eraseToAnyPublisher()
    }
    
    let request = URLRequest(url: url)
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: [UserDTO].self, decoder: JSONDecoder())
      .mapError { error in
        if error is DecodingError {
          return ServiceError.decoding
        } else {
          return ServiceError.network(message: error.localizedDescription)
        }
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}

class MockUserService: UserServiceProtocol {
  var shouldSimulateError = false
  
  func fetchUsers(matching query: String) -> AnyPublisher<[UserDTO], Error> {
    if shouldSimulateError {
      return Fail(error: ServiceError.network(message: "Simulated failure from mock."))
        .eraseToAnyPublisher()
    }
        
    let mockBase = [
      ("X example 1", "X_example1@gmail.com"),
      ("X example 2", "X_example2@gmail.com"),
      ("X example 3", "X_example3@gmail.com"),
      ("X example 4", "X_example4@gmail.com"),
      ("X example 5", "X_example5@gmail.com"),
      ("X example 6", "X_example6@gmail.com"),
      ("X example 7", "X_example7@gmail.com"),
      ("X example 8", "X_example8@gmail.com"),
      ("X example 9", "X_example9@gmail.com"),
      ("X example 10", "X_example10@gmail.com")
    ]
    
    let result = mockBase.map {
      let replacedName = $0.0.replacingOccurrences(of: "X", with: query)
      let replacedEmail = $0.1.replacingOccurrences(of: "X", with: query)
      return UserDTO(
        name: replacedName,
        email: replacedEmail,
        address: "Calle Falsa \(Int.random(in: 1...999)), Colonia Fantasía, CDMX",
        phone: "55 \(Int.random(in: 1000...9999)) \(Int.random(in: 1000...9999))"
      )
    }
    
    return Just(result)
      .setFailureType(to: Error.self)
      .delay(for: .milliseconds(300), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
