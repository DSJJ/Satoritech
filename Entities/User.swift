//
//  User.swift
//  Satoritech
//
//  Created by David Jiménez  on 17/07/25.
//

import Foundation

struct User: Identifiable, Equatable {
  let id = UUID()
  let name: String
  let email: String
  let address: String
  let phone: String

  init(from dto: UserDTO) {
      self.name = dto.name
      self.email = dto.email
      self.address = dto.address
      self.phone = dto.phone
  }
}
