//
//  UserSearchViewModel.swift
//  Satoritech
//
//  Created by David Jiménez  on 17/07/25.
//

import Foundation
import Combine

class UserSearchViewModel: ObservableObject {
  @Published var searchText: String = ""
  @Published var users: [User] = []
  @Published var hasSearched: Bool = false
  @Published var errorMessage: String?
  @Published var isLoading: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  private let searchUseCase: SearchUsersUseCase
  
  init(searchUseCase: SearchUsersUseCase = SearchUsersUseCase()) {
    self.searchUseCase = searchUseCase
  }
  
  func search() {
    hasSearched = true
    errorMessage = nil
    isLoading = true
    
    if searchText.isEmpty {
      users.removeAll()
      isLoading = false
    } else {
      searchUseCase.execute(query: searchText)
        .sink { [weak self] completion in
          self?.isLoading = false
          if case let .failure(error) = completion {
            self?.errorMessage = error.localizedDescription
            self?.users = []
          }
        } receiveValue: { [weak self] users in
          self?.users = users
        }
        .store(in: &cancellables)
    }
  }
}
