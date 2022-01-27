//
//  MessageDecryptView.swift
//  Encryptify
//
//  Created by Artur Rybak on 27/01/2022.
//

import SwiftUI

struct MessageDecryptView: View {
    var input: URL
    var components: URLComponents
    var share: String?
    var sentOn: String?
    
    init(url: URL) {
        input = url
        components = URLComponents(
            url: input,
            resolvingAgainstBaseURL: false
        )!
        share = getQueryStringParameter(url: components, param: "share")!
        sentOn = getQueryStringParameter(url: components, param: "date")!
    }
    
    
    var body: some View {
        VStack {
            Text("Share is: \(share!)")
            Text("Date is : \(getDateFromString(sentOn!) ?? Date())")
        }
        let _ = print("components are: \(components.queryItems!)")
    }
    
    func getDateFromString(_ dateAsString: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd.hh:mm:ssz"
        return df.date(from: dateAsString)
    }
    
    func getQueryStringParameter(url: URLComponents, param: String) -> String? {
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

struct MessageDecryptView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDecryptView(url: URL(string: "encryptify://message?share=1-477850e373e437&date=2022-01-27.09:12:55GMT")!)
    }
}
