//
//  UserRegistrationView.swift
//  Encryptify
//
//  Created by Artur Rybak on 13/01/2022.
//

import SwiftUI
import UIKit
import PhotosUI

struct UserRegistrationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    @ObservedObject private var userVM = UserViewModel()
    @State private var showingImagePicker = false
    @State private var selectedPhoto: UIImage? = nil
    @State var userName = ""
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Contact Name")) {
                        TextField("Name", text: $userName)
                    }
                    Section(header: Text("Avatar")) {
                            Button(action: {
                                showingImagePicker.toggle()

                            }) {Text("browse..").font(.headline)}
                            //.buttonStyle(GradientButtonStyle())
                        
                    }
                    if selectedPhoto != nil {
                        Section(header: Text("Chosen Image")) {
                            HStack {
                                Spacer()
                                Image(uiImage: selectedPhoto!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle().stroke(.white, lineWidth: 4)
                                    }
                                    .shadow(radius: 3)
                                Spacer()
                            }
                            .listRowBackground(Color.clear)

                        }
                        Button(action: {
                            print("Signed In \(userName)")
                            userVM.name = userName
                            userVM.image = selectedPhoto
                            userVM.save(isSigningIn: true)
                            userVM.getCurrentUser()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Spacer()
                                Text("Sign In")
                                    .font(.title2)
                                Spacer()
                            }
                        }
                        .accentColor(.white)
                        .padding(15)
                        .background(K.Colors.gradient)
                        .cornerRadius(10)
                        .listRowBackground(Color.clear)
                        .disabled(userName.isEmpty || selectedPhoto == nil)
                        
                    }
                        
                }

            }
            .navigationTitle("Add User")
            .sheet(isPresented: $showingImagePicker) {
                renderPicker()
            }
        }
    }
    
    private func renderPicker() -> some View {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        return PhotoPicker(configuration: configuration, showingImagePicker: $showingImagePicker, selectedPhoto: $selectedPhoto)
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    var configuration: PHPickerConfiguration
    
    @Binding var showingImagePicker: Bool
    @Binding var selectedPhoto: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
      
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // The client is responsible for presentation and dismissal
            picker.dismiss (animated: true)
            
            // Get the first item provider from the results
            let itemProvider = results.first?.itemProvider

            // Access the UIImage representation for the result
            if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) {  image, error in
                        if let image = image as? UIImage {
                            self.parent.selectedPhoto = self.cropPhoto(image: image)
                        } else {
                                print("Could not load image", error?.localizedDescription ?? "")
                        }
                }
            }

            // Set isPresented to false because picking has finished.
            parent.showingImagePicker = false
        }
        
        func cropPhoto(image: UIImage) -> UIImage {
            // The shortest side
            let sideLength = min(
                image.size.width,
                image.size.height
            )

            // Determines the x,y coordinate of a centered
            // sideLength by sideLength square
            let sourceSize = image.size
            let xOffset = (sourceSize.width - sideLength) / 2.0
            let yOffset = (sourceSize.height - sideLength) / 2.0

            // The cropRect is the rect of the image to keep,
            // in this case centered
            let cropRect = CGRect(
                x: xOffset,
                y: yOffset,
                width: sideLength,
                height: sideLength
            ).integral

            // Center crop the image
            let sourceCGImage = image.cgImage!
            let croppedCGImage = sourceCGImage.cropping(
                to: cropRect
            )!
            
            let croppedImage = UIImage(
                cgImage: croppedCGImage,
                scale: image.imageRendererFormat.scale,
                orientation: image.imageOrientation
            )
            return croppedImage
        }
    }
}

struct UserRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        UserRegistrationView()
    }
}
