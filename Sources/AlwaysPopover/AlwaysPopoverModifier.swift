//
//  AlwaysPopoverModifier.swift
//  Popovers
//
//  Copyright © 2021 PSPDFKit GmbH. All rights reserved.
//

import SwiftUI

public struct AlwaysPopoverModifier<PopoverContent>: ViewModifier where PopoverContent: View {
    
  public let isPresented: Binding<Bool>
  public var canOverlapSourceViewRect: Bool = true
  public let contentBlock: () -> PopoverContent
    
  // Workaround for missing @StateObject in iOS 13.
  private struct Store {
    var anchorView = UIView()
  }
  @State private var store = Store()
  
  public func body(content: Content) -> some View {
    content
    .background(InternalAnchorView(uiView: store.anchorView))
    .onChange(of: isPresented.wrappedValue) { newValue in
      if isPresented.wrappedValue {
        presentPopover()
      } else {
        if let presentVC = store.anchorView.closestVC()?.presentedViewController {
          presentVC.dismiss(animated: true)
        }
      }
    }
  }
  
  private func presentPopover() {
    let contentController = ContentViewController(rootView: contentBlock(), isPresented: isPresented)
    contentController.modalPresentationStyle = .popover
    
    let view = store.anchorView
    guard let popover = contentController.popoverPresentationController else { return }
    popover.sourceView = view
  
    popover.sourceRect = view.bounds
    popover.delegate = contentController
    popover.canOverlapSourceViewRect = canOverlapSourceViewRect
    
    guard let sourceVC = view.closestVC() else { return }
  
    if let presentedVC = sourceVC.presentedViewController {
        presentedVC.dismiss(animated: true) {
            sourceVC.present(contentController, animated: true)
        }
    } else {
        sourceVC.present(contentController, animated: true)
    }
  }
  
  private struct InternalAnchorView: UIViewRepresentable {
    typealias UIViewType = UIView
    let uiView: UIView
    
    func makeUIView(context: Self.Context) -> Self.UIViewType {
        uiView
    }
    
    func updateUIView(_ uiView: Self.UIViewType, context: Self.Context) { }
  }
}
