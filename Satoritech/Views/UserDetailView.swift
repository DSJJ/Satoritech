//
//  UserDetailView.swift
//  Satoritech
//
//  Created by David Jiménez  on 17/07/25.
//

import SwiftUI

struct UserDetailView: View {
  let user: User
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        Image(systemName: "figure.wave.circle.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 120, height: 120)
          .foregroundStyle(.blue.gradient)
          .padding(.top, 40)
        
        Text(user.name)
          .font(.largeTitle.weight(.semibold))
          .multilineTextAlignment(.center)
          .padding(.horizontal)
          .minimumScaleFactor(0.7)
        
        VStack(spacing: 16) {
          UserInfoRowView(title: "Correo electrónico",
                          value: user.email
                          , image: "envelope")
          UserInfoRowView(title: "Dirección",
                          value: user.address,
                          image: "house")
          UserInfoRowView(title: "Teléfono",
                          value: user.phone,
                          image: "phone")
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 4)
        .padding(.horizontal)
        
        Spacer(minLength: 60)
      }
    }
    .navigationTitle("Detalle")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color(.systemGroupedBackground))
  }
}

struct UserInfoRowView: View {
  let title: String
  let value: String
  let image: String
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: image)
        .foregroundStyle(.blue)
        .font(.title3)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.subheadline)
          .foregroundStyle(.secondary)
        Text(value)
          .font(.body)
          .foregroundStyle(.primary)
          .lineLimit(nil)
      }
      
      Spacer()
    }
  }
}

#Preview {
  UserDetailView(user: User(from: UserDTO(name: "David Sinai Jiménez Jiménez",
                                          email: "david@example.com",
                                          address: "Calle 1",
                                          phone: "55 1234 5678")))
}
