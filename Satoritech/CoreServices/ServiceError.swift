//
//  ServiceError.swift
//  Satoritech
//
//  Created by David Jiménez  on 17/07/25.
//

import Foundation

enum ServiceError: LocalizedError, Equatable {
  case invalidURL
  case decoding
  case network(message: String)
  case unknown
  
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "La URL proporcionada no es válida."
    case .decoding:
      return "Ocurrió un error al decodificar la respuesta del servidor."
    case .network(let message):
      return "Error de red: \(message)"
    case .unknown:
      return "Ha ocurrido un error desconocido."
    }
  }
}
