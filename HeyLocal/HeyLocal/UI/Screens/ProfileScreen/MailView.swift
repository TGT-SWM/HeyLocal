//
//  MailView.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import MessageUI
import SwiftUI

// MARK: - MailView (메일 전송 화면 추가)

struct MailView: UIViewControllerRepresentable {
	// 파라미터
	var to: String
	var subject: String
	var content: String

	typealias UIViewControllerType = MFMailComposeViewController

	func makeUIViewController(context: Context) -> MFMailComposeViewController {
		if MFMailComposeViewController.canSendMail() {
			let view = MFMailComposeViewController()
			view.mailComposeDelegate = context.coordinator
			view.setToRecipients([to])
			view.setSubject(subject)
			view.setMessageBody(content, isHTML: false)
			return view
		}
		
		return MFMailComposeViewController()
	}
	
	func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}
	
	class Coordinator : NSObject, MFMailComposeViewControllerDelegate{
		var parent : MailView
		
		init(_ parent: MailView){
			self.parent = parent
		}
		
		func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
			controller.dismiss(animated: true)
		}
	}
}
