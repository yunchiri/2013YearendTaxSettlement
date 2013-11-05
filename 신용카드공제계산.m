//2013년 연말정산 신용카드 계산 로직 
/*
create : hernardo@gmail.com

*/

//사용분
long	creditCardAmtUsedAmt		//신용카드 사용분 6
long	cashReceiptUsedAmt 			//현금영수증 사용분 7
long	debitAndPrepaidCardUsedAmt	//직불-선불카드 사용분 8
long	traditionalMarketUseAmt		//전통시장 사용분 9
long	publicTransportUseAmt		//대중교통 이용분 19
//총급여
long 	totalPayRoll				//총급여 15-1
long 	totalPayRollOf20percent		//총급여 20% 17번에 사용됨
//공제
long	traditionalMarketUseAmtOfDeductionAmt					//전통시장 사용분 공제액 11
long	publicTransportUseAmtOfDeductionAmt						//대중교통 이용분 공제액 12
long	debitAndPrepaidCardAndCashReceiptUsedAmtOfDeductionAmt	//직불-선불카드   현금영수증 사용분 공제액 13
long 	creditCardAmtUsedAmtOfDeductionAmt						//신용카드 사용분 공제액 14
//공제제외금액 15
long	minUsedAmt								//최저사용금액 15-2
long	deductionExclusiveAmt					//공제제외금액 15-3
//나머지 계산 
long	deductionAbleAmt						//공제가능금액 16
long	deductionLimitAmt						//공제한도액 17
long	generalDeductionAmt						//일반 공제금액 18
long	tradtionalMarketAdditionalDeducionAmt	//전통시장 추가 공제금액 19
long	publicTransportAdditionalDeducionAmt	//대중교통 추가 공제금액20
long	finalDeductionAmt						//최종 공제금액 21

//mapping 은 알아서  
//cashReceiptUsedAmt = getDatabase('신용카드사용분')


//11 전통시장 사용분 공제액 
traditionalMarketUseAmtOfDeductionAmt = traditionalMarketUseAmtOfDeductionAmt* 0.3	 

//12 대중교통 이용분 공제액 
publicTransportUseAmtOfDeductionAmt = publicTransportUseAmt * 0.3		 

//13 직불-선불카드, 현금영수증 사용분 공제액 
debitAndPrepaidCardAndCashReceiptUsedAmtOfDeductionAmt = ( cashReceiptUsedAmt + debitAndPrepaidCardUsedAmt ) * 0.3 

//14 신용카드 사용분 공제액
creditCardAmtUsedAmtOfDeductionAmt = creditCardAmtUsedAmt * 0.15 

//15 공제제외금액 계산		deductionExclusive
//15-1 총급여
totalPayRoll = getDatabase('총급여')

//15-2 최저사용금액 
minUsedAmt = totalPayRoll * 0.25 

//15-3 공제제외금액
If ( minUsedAmt <=  creditCardAmtUsedAmt){
	deductionExclusiveAmt = minUsedAmt * 0.15 
}else{
	deductionExclusiveAmt = creditCardAmtUsedAmt * 0.15 + ( minUsedAmt - creditCardAmtUsedAmt ) * 0.3 
}

//16 공제가능금액 ( 11 + 12 + 13 + 14  -(15-3))
deductionAbleAmt = ( traditionalMarketUseAmtOfDeductionAmt + publicTransportUseAmtOfDeductionAmt + debitAndPrepaidCardAndCashReceiptUsedAmtOfDeductionAmt + creditCardAmtUsedAmtOfDeductionAmt ) - deductionExclusiveAmt

//17 공제한도액

totalPayRollOf20percent	= totalPayRoll * 0.2

deductionLimitAmt = min( 3000000, totalPayRollOf20percent )

//18 일반 공제금액

generalDeductionAmt	= min(deductionAbleAmt , deductionLimitAmt)

//19 전통시장 추가 공제금액
long minAmt16minus17 //16-17
minAmt16minus17 = deductionAbleAmt  - deductionLimitAmt

If (minAmt16minus17 < 0 ){
	minAmt16minus17 = 0 
}

tradtionalMarketAdditionalDeducionAmt = min(1000000,min( minAmt16minus17 , traditionalMarketUseAmtOfDeductionAmt ))

//20 대중교통 추가 공제금액
long minAmt16minus17minus19 // 16-17-19

minAmt16minus17minus19 = deductionAbleAmt  - deductionLimitAmt - tradtionalMarketAdditionalDeducionAmt

if ( minAmt16minus17minus19 < 0){
	minAmt16minus17minus19 = 0
}

publicTransportAdditionalDeducionAmt = min(1000000,min(minAmt16minus17minus19 , publicTransportUseAmtOfDeductionAmt))

//21 최종 공제금액
finalDeductionAmt = generalDeductionAmt + tradtionalMarketAdditionalDeducionAmt + publicTransportAdditionalDeducionAmt

return finalDeductionAmt

