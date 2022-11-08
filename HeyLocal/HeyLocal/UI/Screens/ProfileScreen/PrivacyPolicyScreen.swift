//
//  PrivacyPolicyScreen.swift
//  HeyLocal
//  Terms of Service terms of use (이용약관 페이지)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct PrivacyPolicyScreen: View {
    @Environment(\.displayTabBar) var displayTabBar
    
    let intro : String = "<SWM-TGT>\n('https://heylocal.p-e.kr'이하 '현지야')은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다."
    
    let comment1: String = "< SWM-TGT >\n('https://heylocal.p-e.kr'이하 '현지야')은(는) 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n"
    let comment1_1: String = "1. 홈페이지 회원가입 및 관리\n회원 가입의사 확인, 회원자격 유지·관리, 서비스 부정이용 방지, 각종 고지·통지 목적으로 개인정보를 처리합니다.\n\n2. 민원사무 처리\n민원사항 확인 목적으로 개인정보를 처리합니다.\n\n3. 재화 또는 서비스 제공\n서비스 제공, 콘텐츠 제공을 목적으로 개인정보를 처리합니다.\n\n4. 마케팅 및 광고에의 활용\n신규 서비스(제품) 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공 , 인구통계학적 특성에 따른 서비스 제공 및 광고 게재 , 서비스의 유효성 확인, 접속빈도 파악 또는 회원의 서비스 이용에 대한 통계 등을 목적으로 개인정보를 처리합니다."
    
    let comment2: String = "① < SWM-TGT >은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.\n\n② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.\n"
    let comment2_1: String = "•  <홈페이지 회원가입 및 관리>\n\n•  <홈페이지 회원가입 및 관리>와 관련한 개인정보는 수집.이용에 관한 동의일로부터 <1년>까지 위 이용목적을 위하여 보유.이용됩니다.\n\n•  보유근거 : 사용자 맞춤 컨텐츠 제공을 위한 사용자 정보 보유\n\n•  관련법령 : 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년"
    
    let comment3: String = "① < SWM-TGT >은(는) 다음의 개인정보 항목을 처리하고 있습니다.\n"
    let comment3_1: String = "•  < 홈페이지 회원가입 및 관리 >\n\n•  필수항목 : 이메일, 비밀번호, 로그인ID\n\n•  선택항목 : 휴대전화번호, 성별, 이름, 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보"
    
    let comment4: String = "① < SWM-TGT >은(는) 개인정보를 제3자에게 제공하지 않습니다.\n"
    let comment5: String = "① < SWM-TGT >은(는) 개인정보 처리업무를 위탁하지 않습니다.\n"

    let comment6: String = "① < SWM-TGT > 은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n\n② 개인정보 파기의 절차 및 방법은 다음과 같습니다.\n"
    let comment6_1: String = "1. 파기절차\n< SWM-TGT > 은(는) 파기 사유가 발생한 개인정보를 선정하고, < SWM-TGT > 의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.\n\n2. 파기방법\n전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.\n종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.\n"
    
    let comment7: String = "① 정보주체는 SWM-TGT에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.\n\n② 제1항에 따른 권리 행사는SWM-TGT에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 SWM-TGT은(는) 이에 대해 지체 없이 조치하겠습니다.\n\n③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다.이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.\n\n④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.\n\n⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.\n\n⑥ SWM-TGT은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.\n"
    
    let comment8: String = "< SWM-TGT >은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.\n"
    let comment8_1: String = "1. 해킹 등에 대비한 기술적 대책\n<SWM-TGT>('현지야')은 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다.\n\n2. 개인정보의 암호화\n이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다."
    
    let comment9: String = "① SWM-TGT 은(는) 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다.\n\n② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다.\n"
    let comment9_1: String = "가. 쿠키의 사용 목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다.\n나. 쿠키의 설치•운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다.\n다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.\n"
    
    let comment10: String = "< SWM-TGT >은(는) 온라인 맞춤형 광고 등을 위한 행태정보를 수집·이용·제공하지 않습니다.\n"
    let comment11: String = "< SWM-TGT > 은(는) ｢개인정보 보호법｣ 제15조제3항 및 제17조제4항에 따라 ｢개인정보 보호법 시행령｣ 제14조의2에 따른 사항을 고려하여 정보주체의 동의 없이 개인정보를 추가적으로 이용·제공할 수 있습니다.\n이에 따라 < SWM-TGT > 가(이) 정보주체의 동의 없이 추가적인 이용·제공을 하기 위해서 다음과 같은 사항을 고려하였습니다.\n"
    
    let comment12: String = "< SWM-TGT > 은(는) 가명정보를 처리하지 않습니다.\n"
    
    let comment13: String = "① SWM-TGT 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n"
    let comment13_1: String = "•  개인정보 보호책임자\n•  성명 :우태균\n•  직책 :팀장\n•  직급 :팀장\n•  연락처 :010-2458-9804, dnxprbs@gmail.com\n"
    let comment13_2: String = "② 정보주체께서는 SWM-TGT 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. SWM-TGT 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다."
    
    
    let comment14: String = "정보주체는 ｢개인정보 보호법｣ 제39조의11에 따라 지정된 < SWM-TGT >의 국내대리인에게 개인정보 관련 고충처리 등의 업무를 위하여 연락을 취할 수 있습니다.\n< SWM-TGT >은(는) 정보주체의 개인정보 관련 고충처리 등 개인정보 보호책임자의 업무 등을 신속하게 처리할 수 있도록 노력하겠습니다."
    
    let comment15: String = "정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.\n\n1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)\n2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)\n3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)\n4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)\n\n「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.\n\n※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회(www.simpan.go.kr) 홈페이지를 참고하시기 바랍니다.\n"
    
    
    let comment16: String = "① < SWM-TGT >은(는) 영상정보처리기기를 설치·운영하지 않습니다.\n"
    let comment17: String = "① 이 개인정보처리방침은 2022년 10월 1부터 적용됩니다.\n"
    
    // MARK: - 제 1조 ~ 8조
    var content1: some View {
        VStack(alignment: .leading){
            /// 1조
            Group {
                Text("제 1조 (개인정보의 처리목적)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment1)
                
                HStack {
                    Spacer()
                        .frame(width: 10)
                    Text(comment1_1)
                }
            }
            
            Spacer()
                .frame(height: 23)
            
            /// 2조
            Group {
                Text("제 2조 (개인정보의 처리 및 보유 기간)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment2)
                
                HStack {
                    Spacer()
                        .frame(width: 10)
                    Text(comment2_1)
                }
            }
            
            Spacer()
                .frame(height: 23)
            
            /// 3조
            Group {
                Text("제 3조 (처리하는 개인정보의 항목)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment3)
                
                HStack {
                    Spacer()
                        .frame(width: 10)
                    Text(comment3_1)
                }
            }
            
            /// 4조
            Group {
                Text("제 4조 (개인정보의 제3자 제공에 관한 사항)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment4)
            }

            /// 5조
            Group {
                Text("제 5조 (개인정보처리의 위탁에 관한 사항)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment5)
            }

            /// 6조
            Group {
                Text("제 6조 (개인정보의 파기절차 및 파기방법)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment6)
                
                HStack {
                    Spacer()
                        .frame(width: 10)
                    Text(comment6_1)
                }
            }
            
            
            /// 7조
            Group {
                Text("제 7조 (정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment7)
            }
            
            
            /// 8조
            Group {
                Text("제 8조 (개인정보의 안전성 확보조치에 관한 사항)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment8)
                HStack {
                    Spacer()
                        .frame(width: 10)
                    Text(comment8_1)
                }
            }
        }
    }
    
    // MARK: - 제 9조 ~ 17조
    var content2: some View {
        VStack(alignment: .leading){
            /// 9조
            Group {
                Text("제 9조 (개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment9)
                HStack {
                    Spacer()
                        .frame(width: 10)
                    Text(comment9_1)
                }
            }
            
            /// 10조
            Group {
                Text("제 10조 (행태정보의 수집·이용·제공 및 거부 등에 관한 사항)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment10)
            }
            
            /// 11조
            Group {
                Text("제 11조 (추가적인 이용·제공 판단기준)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment11)
            }
            
            /// 12조
            Group {
                Text("제 12조 (가명정보를 처리하는 경우 가명정보 처리에 관한 사항)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment12)
            }
            
            /// 13조
            Group {
                Text("제 13조 (개인정보 보호책임자에 관한 사항)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment13)
                HStack {
                    Spacer()
                        .frame(width: 10)
                    Text(comment13_1)
                }
                Text(comment13_2)
            }
            
            /// 14조
            Group {
                Text("제 14조 (국내대리인의 지정)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment14)
            }
            
            /// 15조
            Group {
                Text("제 15조 (정보주체의 권익침해에 대한 구제방법)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment15)
            }
            
            /// 16조
            Group {
                Text("제 16조 (영상정보처리기기 운영·관리에 관한 사항)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment16)
            }
            
            /// 17조
            Group {
                Text("제 17조 (개인정보 처리방침 변경)")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.vertical, 3)
                
                
                /// 본문
                Text(comment17)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(intro)
                        .font(.system(size: 13))
                        .padding()
                    
                    Divider()
                }
                VStack(alignment: .leading) {
                    content1
                    content2
                }
                .padding()
                .font(.system(size: 12))
            }
        }
        .onAppear {
            displayTabBar(false)
        }
        .navigationTitle("서비스 이용약관")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton() )
    }
}

struct PrivacyPolicyScreen_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyScreen()
    }
}
