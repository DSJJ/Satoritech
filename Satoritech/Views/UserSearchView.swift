//
//  UserSearchView.swift
//  Satoritech
//
//  Created by David Jiménez  on 17/07/25.
//

import SwiftUI

struct UserSearchView: View {
  @StateObject var viewModel: UserSearchViewModel = .init()
  
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          TextField("Buscar usuario", text: $viewModel.searchText)
            .textFieldStyle(.roundedBorder)
            .padding(.leading)
          
          Button("Buscar") {
            hideKeyboard()
            viewModel.search()
          }
          .buttonStyle(.borderedProminent)
          .padding(.trailing)
        } // End HStack
        
        if let errorMessage = viewModel.errorMessage {
          MessageView(image: "exclamationmark.warninglight",
                      title: errorMessage,
                      color: .red)
        }
        
        Group {
          if viewModel.isLoading {
            ProgressView()
              .padding(.top)
          } else if viewModel.users.isEmpty {
            if viewModel.hasSearched && viewModel.errorMessage == nil {
              MessageView(image: "person.fill.questionmark",
                          title: "Sin resultados",
                          color: .cyan)
            } else if !viewModel.hasSearched {
              MessageView(image: "magnifyingglass",
                          title: "Ingresa un nombre de usuario",
                          color: .gray)
            }
          } else {
            ScrollView {
              LazyVStack {
                ForEach(viewModel.users) { user in
                  NavigationLink(destination: UserDetailView(user: user)) {
                    UserRowView(user: user)
                  }
                  .buttonStyle(.plain)
                }
              } // End LazyVStack
            } // End ScrollView
          }
        } // End Group
        .animation(.easeInOut, value: viewModel.users)
        
        Spacer()
      } // End VStack
      .navigationTitle("Usuarios")
    } // End NavigationStack
  }
}

struct MessageView: View {
  let image: String
  let title: String
  let color: Color
  
  var body: some View {
    VStack(spacing: 12) {
      Image(systemName: image)
        .resizable()
        .frame(width: 60, height: 60)
        .foregroundColor(color)
      
      Text(title)
        .font(.headline)
        .foregroundStyle(color)
    } // End VStack
    .padding(.top, 40)
  }
}

struct UserRowView: View {
  let user: User
  
  @Environment(\.colorScheme) private var colorScheme
  
  var body: some View {
    HStack(spacing: 16) {
      Image(systemName: "figure.wave.circle.fill")
        .resizable()
        .frame(width: 44, height: 44)
        .foregroundColor(.cyan)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(user.name)
          .font(.system(.headline, design: .rounded))
          .foregroundStyle(.primary)
        
        Text(user.email)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .lineLimit(1)
      } // End VStack
      
      Spacer()
      
      Image(systemName: "chevron.right")
        .foregroundColor(.gray)
        .imageScale(.small)
    } // End HStack
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(.regularMaterial)
        .shadow(color: colorScheme == .dark
                ? Color.white.opacity(0.08)
                : Color.black.opacity(0.05),
                radius: 4, x: 0, y: 2)
    )
    .padding(.horizontal)
    .padding(.vertical, 4)
  }
}

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

#Preview("Resultado con usuarios") {
  UserSearchView(viewModel: {
    let vm = UserSearchViewModel()
    vm.searchText = "david"
    vm.hasSearched = true
    vm.users = [
      User(from: UserDTO(name: "David", email: "david@example.com", address: "Calle 1", phone: "+52 55 1234 5678")),
      User(from: UserDTO(name: "David Sinai", email: "DavidSinai@example.com", address: "Calle 1", phone: "+52 55 1234 5678")),
      User(from: UserDTO(name: "David Rafale", email: "DavidR@example.com", address: "Calle 1", phone: "+52 55 1234 5678")),
      User(from: UserDTO(name: "David Ernesto", email: "DavidE@example.com", address: "Calle 1", phone: "+52 55 1234 5678"))
    ]
    return vm
  }())
}

#Preview("Sin búsqueda") {
  UserSearchView(viewModel: {
    let vm = UserSearchViewModel()
    vm.searchText = ""
    vm.hasSearched = false
    return vm
  }())
}

#Preview("Resultado vacío") {
  UserSearchView(viewModel: {
    let vm = UserSearchViewModel()
    vm.searchText = "x"
    vm.hasSearched = true
    vm.users = []
    return vm
  }())
}

#Preview("Error de servicio") {
  UserSearchView(viewModel: {
    let vm = UserSearchViewModel()
    vm.searchText = "error"
    vm.hasSearched = true
    vm.errorMessage = "Error simulado para preview"
    return vm
  }())
}
