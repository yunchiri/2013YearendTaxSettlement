//**소득세 소득공제 종합한도 계산

long guaranteedInsurance//보험료공제 - 보장성보험료
long medicalExpenseDeduction// 의료비공제
long educationExpenseDeduction// 교육비공제
long houseFundDeduction// 자택자금공제
long contributeDeduction// 기부금공제자
long smallBusinessDeduction // 소기업`소상공인 공제부금 공제
long houseSavingDeduction// 주택마련저축 소득공제
long startUpInverstmentDeduction// 창업투자조합 출자등 소득공제
long cardsDeduction// 신용카드 등 소득공제
long associationContributionDeduction// 우리사주조합출연금 소득공제

  
long maxLimit
long totalIncomeDeduction
long specialDeductionTotalLimitExcessAmt
maxLimit = 25000000

totalIncomeDeduction = 
guaranteedInsurance +
medicalExpenseDeduction +
educationExpenseDeduction +
houseFundDeduction +
contributeDeduction +
smallBusinessDeduction +
houseSavingDeduction +
startUpInverstmentDeduction +
cardsDeduction +
associationContributionDeduction +

specialDeductionTotalLimitExcessAmt = totalIncomeDeduction - maxLimit

if (specialDeductionTotalLimitExcessAmt <= 0 )
{
	return 0 
}


return specialDeductionTotalLimitExcessAmt
