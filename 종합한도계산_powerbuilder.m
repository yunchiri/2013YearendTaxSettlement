//**소득세 소득공제 종합한도 계산

decimal guaranteedInsurance//보험료공제 - 보장성보험료
decimal medicalExpenseDeduction// 의료비공제
decimal educationExpenseDeduction// 교육비공제
decimal houseFundDeduction// 자택자금공제
decimal contributeDeduction// 기부금공제자
decimal smallBusinessDeduction // 소기업`소상공인 공제부금 공제
decimal houseSavingDeduction// 주택마련저축 소득공제
decimal startUpInverstmentDeduction// 창업투자조합 출자등 소득공제
decimal cardsDeduction// 신용카드 등 소득공제
decimal associationContributionDeduction// 우리사주조합출연금 소득공제

  
decimal maxLimit
decimal totalIncomeDeduction
decimal specialDeductionTotalLimitExcessAmt
maxLimit = 25000000

//mapping
guaranteedInsurance 		=	ads_exact.object.secrt_inf_fee[idx]

medicalExpenseDeduction 	=	ads_exact.object.medi_fee_deduc[idx]

educationExpenseDeduction 	=	ads_exact.object.educ_fee_deduc[idx]

houseFundDeduction 			=	ads_exact.object.house_fund_repay_deduc[idx] &
								+  ads_exact.object.house_fund_repay_liver_deduc[idx] &
								+ ads_exact.object.monthly_rent_deduc[idx] &
								+ ads_exact.object.house_fund_save_int_deduc[idx] &
								+ ads_exact.object.house_fund_save_int_15_deduc[idx] &
								+ ads_exact.object.house_fund_save_int_30_deduc[idx] &
								+ ads_exact.object.fixed_rate_repay_loan[idx] &
								+ ads_exact.object.etc_repay_loan[idx]

contributeDeduction 		=	ads_exact.object.cont_amt_deduc[idx] //2013년도 지정기부금만

smallBusinessDeduction 		=	ads_exact.object.SMALL_BUSINESS_INCOMETAX_DEDUC[idx]

houseSavingDeduction 		=	ads_exact.object.house_fund_save1_deduc[idx] &
								+ ads_exact.object.house_fund_save2_deduc[idx] &
								+ ads_exact.object.house_fund_save3_deduc[idx] &
								+ ads_exact.object.worker_house_saving_amt[idx] 

startUpInverstmentDeduction =	ads_exact.object.found_invest_income_deduc[idx]

cardsDeduction 				=	ads_exact.object.card_deduc[idx]

associationContributionDeduction = ads_exact.object.ESOP_WITHDRAWAL_DEDUC_AMT[idx]


//계산시작
totalIncomeDeduction = guaranteedInsurance + medicalExpenseDeduction + educationExpenseDeduction + houseFundDeduction + contributeDeduction + smallBusinessDeduction + houseSavingDeduction + startUpInverstmentDeduction + cardsDeduction + associationContributionDeduction 

specialDeductionTotalLimitExcessAmt = totalIncomeDeduction - maxLimit

if specialDeductionTotalLimitExcessAmt <= 0 then

	return 0 
end if


return specialDeductionTotalLimitExcessAmt
