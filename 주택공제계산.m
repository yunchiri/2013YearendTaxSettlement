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

long calculatedHouseOfferSavings//청약저축
long calculatedHouseOfferTotalSavings//주택청약종합저축
long calculatedHouseWorkersSave//근로자주택마련저축

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
inputTotalSum  = houseRentLoanPrincipalRepaymentAmt_LoanOrganization + houseRentLoanPrincipalRepaymentAmt_Liver + 	 houseMonthlyRentAmt + houseLongtermLoanAmt15Under + houseLongtermLoanAmt15to29 + houseLongtermLoanAmt30Over + houseFixedInterestRateNonDeferredRepaymentLoan + houseEtcLoan + houseOfferSavings + houseOfferTotalSavings  + houseWorkersSave
if ( inputTotalSum == 0 ) {
	calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = 0
	calculatedHouseRentLoanPrincipalRepaymentAmtLiver = 0
	calculatedHouseMonthlyRentAmt = 0
	calculatedHouseOfferSavings = 0
	calculatedHouseOfferTotalSavings = 0
	calculatedHouseWorkersSave = 0
	calculatedHouseLongtermLoanAmt15Under = 0
	calculatedHouseLongtermLoanAmt15to29 = 0
	calculatedHouseLongtermLoanAmt30Over = 0 
	calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
	calculatedHouseEtcLoan = 0
	return  0;
}

//한도 계산 
if ( houseLongtermLoanAmt15Under > 0  ) maxLimitAmt = max( maxLimitAmt , limit6000000)
if ( houseLongtermLoanAmt15to29 > 0 ) maxLimitAmt =  max ( maxLimitAmt, limit10000000)
if ( houseLongtermLoanAmt30Over > 0 ) maxLimitAmt = max ( maxLimitAmt, limit15000000)
if ( houseFixedInterestRateNonDeferredRepaymentLoan > 0 ) maxLimitAmt = max ( maxLimitAmt, limit5000000)
if ( houseEtcLoan > 0 ) maxLimitAmt = max ( maxLimitAmt, limit15000000)



//주택임차차입금 원리금 상환액 대출기간 한도 계산
if ( houseRentLoanPrincipalRepaymentAmt_LoanOrganization > 0 && calculatedSumAmt < maxLimitAmt){
	calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = truncate( houseRentLoanPrincipalRepaymentAmt_LoanOrganization * 0.4 ,0)

	
	if ( calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization >= maxLimitAmt ) {

		calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = maxLimitAmt
		calculatedHouseRentLoanPrincipalRepaymentAmtLiver = 0
		calculatedHouseMonthlyRentAmt = 0
		calculatedHouseOfferSavings = 0
		calculatedHouseOfferTotalSavings = 0
		calculatedHouseWorkersSave = 0
		calculatedHouseLongtermLoanAmt15Under = 0
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0
	}
	calculatedSumAmt = calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
}

//주택임차차입금 원리금 상환액 거주자 한도 계산
if( houseRentLoanPrincipalRepaymentAmt_Liver > 0 && calculatedSumAmt < maxLimitAmt){
	calculatedHouseRentLoanPrincipalRepaymentAmtLiver	= truncate(	houseRentLoanPrincipalRepaymentAmt_Liver * 0.4 ,0)

	if ( calculatedSumAmt + calculatedHouseRentLoanPrincipalRepaymentAmtLiver >= maxLimitAmt ){
			calculatedHouseRentLoanPrincipalRepaymentAmtLiver = maxLimitAmt - calculatedSumAmt
			calculatedHouseMonthlyRentAmt = 0
			calculatedHouseOfferSavings = 0
			calculatedHouseOfferTotalSavings = 0
			calculatedHouseWorkersSave = 0
			calculatedHouseLongtermLoanAmt15Under = 0
			calculatedHouseLongtermLoanAmt15to29 = 0
			calculatedHouseLongtermLoanAmt30Over = 0 
			calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
			calculatedHouseEtcLoan = 0
	}
	calculatedSumAmt = calculatedSumAmt + calculatedHouseRentLoanPrincipalRepaymentAmtLiver
}

//월세한도 계산
if ( houseMonthlyRentAmt > 0 && calculatedSumAmt < maxLimitAmt)
{
	if (totalSalary <= 50000000)
	{
		calculatedHouseMonthlyRentAmt	= truncate(	houseMonthlyRentAmt* 0.5 ,0)

		if (calculatedSumAmt + calculatedHouseMonthlyRentAmt >= maxLimitAmt) {
			calculatedHouseMonthlyRentAmt = maxLimitAmt - calculatedSumAmt 
			calculatedHouseOfferSavings = 0
			calculatedHouseOfferTotalSavings = 0
			calculatedHouseWorkersSave = 0
			calculatedHouseLongtermLoanAmt15Under = 0
			calculatedHouseLongtermLoanAmt15to29 = 0
			calculatedHouseLongtermLoanAmt30Over = 0 
			calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
			calculatedHouseEtcLoan = 0
		}
		calculatedSumAmt = calculatedSumAmt + calculatedHouseMonthlyRentAmt
	}
}


//저축 마련 저축 소득공제 - 청약저축 한도계산
if( houseOfferSavings > 0 && calculatedSumAmt < maxLimitAmt ){
	calculatedHouseOfferSavings = min( truncate( houseOfferSavings * 0.4 ,0 ) , limit480000 )

	if ( calculatedSumAmt + calculatedHouseOfferSavings >= maxLimitAmt)
	{
		calculatedHouseOfferSavings = maxLimitAmt - calculatedSumAmt
		calculatedHouseOfferTotalSavings = 0
		calculatedHouseWorkersSave = 0
		calculatedHouseLongtermLoanAmt15Under = 0
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0
	}
	calculatedSumAmt =  calculatedSumAmt + calculatedHouseOfferSavings
}

//저축 마련 저축 소득공제 - 주택청약종합저축
if( houseOfferTotalSavings > 0 && calculatedSumAmt < maxLimitAmt ){
	calculatedHouseOfferTotalSavings = min( truncate( houseOfferTotalSavings * 0.4 ,0) , limit480000 )

	if ( calculatedSumAmt + calculatedHouseOfferTotalSavings >= maxLimitAmt)
	{
		calculatedHouseOfferTotalSavings = maxLimitAmt - calculatedSumAmt
		calculatedHouseWorkersSave = 0
		calculatedHouseLongtermLoanAmt15Under = 0
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0
	}
	calculatedSumAmt =  calculatedSumAmt + calculatedHouseOfferTotalSavings
}


//저축 마련 저축 소득공제 - 근로자주택마련저축
if( houseWorkersSave > 0 && calculatedSumAmt < maxLimitAmt ){
	calculatedHouseWorkersSave = truncate( houseWorkersSave * 0.4 ,0)

	if ( calculatedSumAmt + calculatedHouseWorkersSave >= maxLimitAmt)
	{
		calculatedHouseWorkersSave = maxLimitAmt - calculatedSumAmt
		calculatedHouseLongtermLoanAmt15Under = 0
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0
	}
	calculatedSumAmt =  calculatedSumAmt + calculatedHouseWorkersSave
}


//(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년미만 한도계산 
if( houseLongtermLoanAmt15Under > 0 && calculatedSumAmt < maxLimitAmt ){
	calculatedHouseLongtermLoanAmt15Under = houseLongtermLoanAmt15Under

	if ( calculatedSumAmt + calculatedHouseLongtermLoanAmt15Under >= maxLimitAmt)
	{
		calculatedHouseLongtermLoanAmt15Under = maxLimitAmt - calculatedSumAmt
		calculatedHouseLongtermLoanAmt15to29 = 0
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0
	}
	calculatedSumAmt =  calculatedSumAmt + calculatedHouseLongtermLoanAmt15Under
}

//(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년~29년 한도계산 
if( houseLongtermLoanAmt15to29  > 0  && calculatedSumAmt < maxLimitAmt ){

	calculatedHouseLongtermLoanAmt15to29 = houseLongtermLoanAmt15to29
	if ( calculatedSumAmt +  calculatedHouseLongtermLoanAmt15to29 >= maxLimitAmt )
	{
		calculatedHouseLongtermLoanAmt15to29 = maxLimitAmt -  calculatedSumAmt
		calculatedHouseLongtermLoanAmt30Over = 0 
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0
	} 
	calculatedSumAmt = calculatedSumAmt + calculatedHouseLongtermLoanAmt15to29
}

//(2011년 이전 차입분) 장기주택저당차입금이자상환액_30년이상 한도계산
if( houseLongtermLoanAmt30Over  > 0 && calculatedSumAmt < maxLimitAmt  ){

	calculatedHouseLongtermLoanAmt30Over = houseLongtermLoanAmt30Over
	if ( calculatedSumAmt +  calculatedHouseLongtermLoanAmt30Over >= maxLimitAmt )
	{
		calculatedHouseLongtermLoanAmt30Over = maxLimitAmt -  calculatedSumAmt
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
		calculatedHouseEtcLoan = 0
	} 
	calculatedSumAmt = calculatedSumAmt + calculatedHouseLongtermLoanAmt30Over
}

//(2012년 이후 차입분 15년 이상) 고정금리비거치식 상환대출
if( houseFixedInterestRateNonDeferredRepaymentLoan  > 0 && calculatedSumAmt < maxLimitAmt  ){

	calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = houseFixedInterestRateNonDeferredRepaymentLoan
	if ( calculatedSumAmt +  calculatedHouseFixedInterestRateNonDeferredRepaymentLoan >= maxLimitAmt )
	{
		calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = maxLimitAmt - calculatedSumAmt
		calculatedHouseEtcLoan = 0		
	} 
	calculatedSumAmt = calculatedSumAmt + calculatedHouseFixedInterestRateNonDeferredRepaymentLoan
}


//(2012년 이후 차입분 15년 이상) 기타대출
if( houseEtcLoan  > 0  && calculatedSumAmt < maxLimitAmt ){

	calculatedHouseEtcLoan = houseEtcLoan
	if ( calculatedSumAmt +  calculatedHouseEtcLoan >= maxLimitAmt )
	{
		calculatedHouseEtcLoan = maxLimitAmt -  calculatedHouseEtcLoan
	} 
	calculatedSumAmt = calculatedSumAmt + calculatedHouseEtcLoan
}


return calculatedSumAmt // 주택공제 금액 
