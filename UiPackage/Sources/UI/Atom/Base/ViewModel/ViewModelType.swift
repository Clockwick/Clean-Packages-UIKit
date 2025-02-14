//
//  ViewModelType.swift
//  UI
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

@MainActor
public protocol ViewModelType<Input, Output> {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}
