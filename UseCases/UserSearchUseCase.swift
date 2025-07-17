//
//  UserSearchUseCase.swift
//  Satoritech
//
//  Created by David Jiménez  on 17/07/25.
//

import Foundation
import Combine

class SearchUsersUseCase {
  private let service: UserServiceProtocol
  
  init(service: UserServiceProtocol = MockUserService()) {
    self.service = service
  }
  
  func execute(query: String) -> AnyPublisher<[User], Error> {
    service.fetchUsers(matching: query)
      .map { $0.map { User(from: $0) } }
      .eraseToAnyPublisher()
  }
}
