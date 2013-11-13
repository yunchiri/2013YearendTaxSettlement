//2013년 연말정산 주택공제 계산 로직 
/*
create : hernardo@gmail.com
date : 2013-11-7
*/

/*
houseRentLoanPrincipalRepaymentAmt_LoanOrganization
houseRentLoanPrincipalRepaymentAmt_Liver
houseMonthlyRentAmt
houseOfferSavings
houseOfferTotalSavings
houseWorkersSave
houseLongtermLoanAmt15Under
houseLongtermLoanAmt15to29
houseLongtermLoanAmt30Over
houseFixedInterestRateNonDeferredRepaymentLoan
houseEtcLoan

*/

//입력받은 금액
long houseRentLoanPrincipalRepaymentAmt_LoanOrganization //주택임차차입금원리금상환액_대출기관
long houseRentLoanPrincipalRepaymentAmt_Liver //주택임차차입금원리금상환액_거주자
long houseMonthlyRentAmt //월세액
long houseLongtermLoanAmt15Under //(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년미만
long houseLongtermLoanAmt15to29 //(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년~29년
long houseLongtermLoanAmt30Over //(2011년 이전 차입분) 장기주택저당차입금이자상환액_30년이상
long houseFixedInterestRateNonDeferredRepaymentLoan //(2012년 이후 차입분 15년 이상) 고정금리비거치식 상환대출
long houseEtcLoan //(2012년 이후 차입분 15년 이상) 기타대출

long houseOfferSavings//청약저축
long houseOfferTotalSavings//주택청약종합저축
long houseWorkersSave//근로자주택마련저축

//한도 계산 후 연말정산에 사용할 금액
long calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization //주택임차차입금원리금상환액_대출기관
long calculatedHouseRentLoanPrincipalRepaymentAmtLiver //주택임차차입금원리금상환액_거주자
long calculatedHouseMonthlyRentAmt //월세액
long calculatedHouseLongtermLoanAmt15Under //(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년미만
long calculatedHouseLongtermLoanAmt15to29 //(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년~29년
long calculatedHouseLongtermLoanAmt30Over //(2011년 이전 차입분) 장기주택저당차입금이자상환액_30년이상
long calculatedHouseFixedInterestRateNonDeferredRepaymentLoan //(2012년 이후 차입분 15년 이상) 고정금리비거치식 상환대출
long calculatedHouseEtcLoan //(2012년 이후 차입분 15년 이상) 기타대출

long calculatedhouseOfferSavings//청약저축
long calculatedhouseOfferTotalSavings//주택청약종합저축
long calculatedhouseWorkersSave//근로자주택마련저축

//한도 금액들
long maxLimitAmt
long totalSalary
long calculatedSumAmt

long limit6000000 
long limit10000000
long limit15000000
long limit5000000 
long limit3000000
long limit480000
//본격적인 계산
totalSalary = getFromDB('totalSalary')
limit6000000 = 6000000
limit10000000 = 10000000
limit15000000 = 15000000
limit5000000 = 5000000
limit3000000 = 3000000
limit480000 = 480000
maxLimitAmt = 3000000
//매핑 


//1. check sum(all) == 0 then return
long inputTotalSum ;
inputTotalSum  = houseRentLoanPrincipalRepaymentAmt_LoanOrganization + houseRentLoanPrincipalRepaymentAmt_Liver + 	 houseMonthlyRentAmt + houseLongtermLoanAmtUnder14 + houseLongtermLoanAmtUnder15to29 + houseLongtermLoanAmtOver30 + houseFixedInterestRateNonDeferredRepaymentLoan + houseEtcLoan 
if ( inputTotalSum == 0 ) {
	calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 0
	calculatedHouseRentLoanPrincipalRepaymentAmtLiver = 0
	calculatedHouseMonthlyRentAmt = 0
	calculatedhouseOfferSavings = 0
	calculatedhouseOfferTotalSavings = 0
	calculatedhouseWorkersSave = 0
	calculatedHouseLongtermLoanAmt15Under = 0
	calculatedHouseLongtermLoanAmt15to29 = 0
	calculatedHouseLongtermLoanAmt30Over = 0 
	calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
	calculatedHouseEtcLoan = 0
	return;
}

//한도 계산 
if ( houseLongtermLoanAmt15Under > 0  ) maxLimitAmt = max( maxLimitAmt , limit6000000)
if ( houseLongtermLoanAmt15to29 > 0 ) maxLimitAmt =  max ( maxLimitAmt, limit10000000)
if ( houseLongtermLoanAmt30Over > 0 ) maxLimitAmt = max ( maxLimitAmt, limit15000000)
if ( houseFixedInterestRateNonDeferredRepaymentLoan > 0 ) maxLimitAmt = max ( maxLimitAmt, limit5000000)
if ( houseEtcLoan > 0 ) maxLimitAmt = max ( maxLimitAmt, limit15000000)


//주택임차차입금 원리금 상환액 대출기간 한도 계산
if ( houseRentLoanPrincipalRepaymentAmt_LoanOrganization > 0 ){
	calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = houseRentLoanPrincipalRepaymentAmt_LoanOrganization * 0.4

	
	if ( calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization >= maxLimitAmt ) {

		calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = maxLimitAmt
		calculatedHouseRentLoanPrincipalRepaymentAmtLiver = 0
		calculatedHouseMonthlyRentAmt = 0
		calculatedhouseOfferSavings = 0
		calculatedhouseOfferTotalSavings = 0
		calculatedhouseWorkersSave = 0
		calculatedHouseLongtermLoanAmt15Under = 0
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0
		return;
	}
	calculatedSumAmt = calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
}

//주택임차차입금 원리금 상환액 거주자 한도 계산
if( houseRentLoanPrincipalRepaymentAmt_Liver > 0 ){
	calculatedHouseRentLoanPrincipalRepaymentAmtLiver	=	houseRentLoanPrincipalRepaymentAmt_Liver * 0.4

	if ( calculatedSumAmt + calculatedHouseRentLoanPrincipalRepaymentAmtLiver >= maxLimitAmt ){
			//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
			calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedSumAmt
			calculatedHouseMonthlyRentAmt = 0
			calculatedhouseOfferSavings = 0
			calculatedhouseOfferTotalSavings = 0
			calculatedhouseWorkersSave = 0
			calculatedHouseLongtermLoanAmt15Under = 0
			calculatedHouseLongtermLoanAmt15to29 = 0
			calculatedHouseLongtermLoanAmt30Over = 0 
			calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
			calculatedHouseEtcLoan = 0

			return;
	}
	calculatedSumAmt = calculatedSumAmt + calculatedHouseRentLoanPrincipalRepaymentAmtLiver
}

//월세한도 계산
if ( houseMonthlyRentAmt > 0 )
{
	if (totalSalary <= 50000000)
	{
		calculatedHouseMonthlyRentAmt	=	houseMonthlyRentAmt* 0.5

		if (calculatedSumAmt + calculatedHouseMonthlyRentAmt >= maxLimitAmt) {
			//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
			// calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
			calculatedHouseMonthlyRentAmt = maxLimitAmt - calculatedSumAmt 
			calculatedhouseOfferSavings = 0
			calculatedhouseOfferTotalSavings = 0
			calculatedhouseWorkersSave = 0
			calculatedHouseLongtermLoanAmt15Under = 0
			calculatedHouseLongtermLoanAmt15to29 = 0
			calculatedHouseLongtermLoanAmt30Over = 0 
			calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
			calculatedHouseEtcLoan = 0

			return;
		}
		calculatedSumAmt = calculatedSumAmt + calculatedHouseMonthlyRentAmt
	}
}


//저축 마련 저축 소득공제 - 청약저축 한도계산
if( houseOfferSavings > 0){
	calculatedhouseOfferSavings = min( houseOfferSavings * 0.4 , limit480000 )

	if ( calculatedSumAmt + calculatedhouseOfferSavings >= maxLimitAmt)
	{
		//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
		// calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
		//calculatedHouseMonthlyRentAmt = maxLimitAmt - ccalculatedSumAmt 
		calculatedhouseOfferSavings = maxLimitAmt - calculatedSumAmt
		calculatedhouseOfferTotalSavings = 0
		calculatedhouseWorkersSave = 0
		calculatedHouseLongtermLoanAmt15Under = 0
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0

		return;
	}
	calculatedSumAmt =  calculatedSumAmt + calculatedhouseOfferSavings
}

//저축 마련 저축 소득공제 - 주택청약종합저축
if( houseOfferTotalSavings > 0){
	calculatedhouseOfferTotalSavings = min( houseOfferTotalSavings * 0.4 , limit480000 )

	if ( calculatedSumAmt + calculatedhouseOfferTotalSavings >= maxLimitAmt)
	{
		//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
		// calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
		//calculatedHouseMonthlyRentAmt = maxLimitAmt - ccalculatedSumAmt 
		//calculatedhouseOfferSavings = maxLimitAmt - calculatedSumAmt
		calculatedhouseOfferTotalSavings = maxLimitAmt - calculatedSumAmt
		calculatedhouseWorkersSave = 0
		calculatedHouseLongtermLoanAmt15Under = 0
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0

		return;
	}
	calculatedSumAmt =  calculatedSumAmt + calculatedhouseOfferTotalSavings
}


//저축 마련 저축 소득공제 - 근로자주택마련저축
if( houseWorkersSave > 0){
	calculatedhouseWorkersSave = houseWorkersSave * 0.4 

	if ( calculatedSumAmt + calculatedhouseWorkersSave >= maxLimitAmt)
	{
		//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
		// calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
		//calculatedHouseMonthlyRentAmt = maxLimitAmt - ccalculatedSumAmt 
		//calculatedhouseOfferSavings = maxLimitAmt - calculatedSumAmt
		//calculatedhouseOfferTotalSavings = maxLimitAmt - calculatedhouseOfferTotalSavings
		calculatedhouseWorkersSave = maxLimitAmt - calculatedSumAmt
		calculatedHouseLongtermLoanAmt15Under = 0
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0

		return;
	}
	calculatedSumAmt =  calculatedSumAmt + calculatedhouseWorkersSave
}


//(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년미만 한도계산 
if( houseLongtermLoanAmt15Under > 0){
	calculatedHouseLongtermLoanAmt14Under = houseLongtermLoanAmt15Under * 0.4 

	if ( calculatedSumAmt + calculatedHouseLongtermLoanAmt14Under >= maxLimitAmt)
	{
		//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
		// calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
		//calculatedHouseMonthlyRentAmt = maxLimitAmt - ccalculatedSumAmt 
		//calculatedhouseOfferSavings = maxLimitAmt - calculatedSumAmt
		//calculatedhouseOfferTotalSavings = maxLimitAmt - calculatedhouseOfferTotalSavings
		//calculatedhouseWorkersSave = maxLimitAmt - calculatedSumAmt
		calculatedHouseLongtermLoanAmt15Under = maxLimitAmt - calculatedSumAmt
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0

		return;
	}
	calculatedSumAmt =  calculatedSumAmt + calculatedHouseLongtermLoanAmt14Under
}

//(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년~29년 한도계산 
if( houseLongtermLoanAmt15to29  > 0 ){

	calculatedHouseLongtermLoanAmt15to29 = houseLongtermLoanAmt15to29
	if ( calculatedSumAmt +  calculatedHouseLongtermLoanAmt15to29 >= maxLimitAmt )
	{
		
		//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
		// calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
		//calculatedHouseMonthlyRentAmt = maxLimitAmt - ccalculatedSumAmt 
		//calculatedhouseOfferSavings = maxLimitAmt - calculatedSumAmt
		//calculatedhouseOfferTotalSavings = maxLimitAmt - calculatedhouseOfferTotalSavings
		//calculatedhouseWorkersSave = maxLimitAmt - calculatedSumAmt
		//calculatedHouseLongtermLoanAmt15Under = maxLimitAmt - calculatedSumAmt
		calculatedHouseLongtermLoanAmt15to29 = maxLimitAmt -  houseLongtermLoanAmt15to29
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0

		return
	} 
	calculatedSumAmt = calculatedSumAmt + calculatedHouseLongtermLoanAmt15to29
}

//(2011년 이전 차입분) 장기주택저당차입금이자상환액_30년이상 한도계산
if( houseLongtermLoanAmt30Over  > 0 ){

	calculatedHouseLongtermLoanAmt30Over = houseLongtermLoanAmt30Over
	if ( calculatedSumAmt +  calculatedHouseLongtermLoanAmt30Over >= maxLimitAmt )
	{
		
		//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
		// calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
		//calculatedHouseMonthlyRentAmt = maxLimitAmt - ccalculatedSumAmt 
		//calculatedhouseOfferSavings = maxLimitAmt - calculatedSumAmt
		//calculatedhouseOfferTotalSavings = maxLimitAmt - calculatedhouseOfferTotalSavings
		//calculatedhouseWorkersSave = maxLimitAmt - calculatedSumAmt
		//calculatedHouseLongtermLoanAmt15Under = maxLimitAmt - calculatedSumAmt
		//calculatedHouseLongtermLoanAmt15to29 = maxLimitAmt -  calculatedSumAmt
		calculatedHouseLongtermLoanAmt30Over = maxLimitAmt -  calculatedHouseLongtermLoanAmt30Over
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0

		return
	} 
	calculatedSumAmt = calculatedSumAmt + calculatedHouseLongtermLoanAmt30Over
}

//(2012년 이후 차입분 15년 이상) 고정금리비거치식 상환대출
if( houseFixedInterestRateNonDeferredRepaymentLoan  > 0 ){

	calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = houseFixedInterestRateNonDeferredRepaymentLoan
	if ( calculatedSumAmt +  calculatedHouseFixedInterestRateNonDeferredRepaymentLoan >= maxLimitAmt )
	{
		
		//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
		// calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
		//calculatedHouseMonthlyRentAmt = maxLimitAmt - ccalculatedSumAmt 
		//calculatedhouseOfferSavings = maxLimitAmt - calculatedSumAmt
		//calculatedhouseOfferTotalSavings = maxLimitAmt - calculatedhouseOfferTotalSavings
		//calculatedhouseWorkersSave = maxLimitAmt - calculatedSumAmt
		//calculatedHouseLongtermLoanAmt15Under = maxLimitAmt - calculatedSumAmt
		//calculatedHouseLongtermLoanAmt15to29 = maxLimitAmt -  calculatedSumAmt
		//calculatedHouseLongtermLoanAmt30Over = maxLimitAmt -  calculatedHouseLongtermLoanAmt30Over
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = maxLimitAmt - calculatedHouseFixedInterestRateNonDeferredRepaymentLoan
		calculatedHouseEtcLoan = 0

		return
	} 
	calculatedSumAmt = calculatedSumAmt + calculatedHouseFixedInterestRateNonDeferredRepaymentLoan
}


//(2012년 이후 차입분 15년 이상) 기타대출
if( houseEtcLoan  > 0 ){

	calculatedHouseEtcLoan = houseEtcLoan
	if ( calculatedSumAmt +  calculatedHouseEtcLoan >= maxLimitAmt )
	{
		
		//calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 
		// calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
		//calculatedHouseMonthlyRentAmt = maxLimitAmt - ccalculatedSumAmt 
		//calculatedhouseOfferSavings = maxLimitAmt - calculatedSumAmt
		//calculatedhouseOfferTotalSavings = maxLimitAmt - calculatedhouseOfferTotalSavings
		//calculatedhouseWorkersSave = maxLimitAmt - calculatedSumAmt
		//calculatedHouseLongtermLoanAmt15Under = maxLimitAmt - calculatedSumAmt
		//calculatedHouseLongtermLoanAmt15to29 = maxLimitAmt -  calculatedSumAmt
		// calculatedHouseLongtermLoanAmt30Over = maxLimitAmt -  calculatedHouseLongtermLoanAmt30Over
		// calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = maxLimitAmt -  calculatedHouseEtcLoan

		return
	} 
	calculatedSumAmt = calculatedSumAmt + calculatedHouseEtcLoan
}


return calculatedSumAmt // 주택공제 금액 
