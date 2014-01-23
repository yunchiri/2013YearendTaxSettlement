//2012년 연말정산 주택공제 계산 로직 
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
decimal houseRentLoanPrincipalRepaymentAmt_LoanOrganization //주택임차차입금원리금상환액_대출기관
decimal houseRentLoanPrincipalRepaymentAmt_Liver //주택임차차입금원리금상환액_거주자
decimal houseMonthlyRentAmt //월세액
decimal houseLongtermLoanAmt15Under //(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년미만
decimal houseLongtermLoanAmt15to29 //(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년~29년
decimal houseLongtermLoanAmt30Over //(2011년 이전 차입분) 장기주택저당차입금이자상환액_30년이상
decimal houseFixedInterestRateNonDeferredRepaymentLoan //(2012년 이후 차입분 15년 이상) 고정금리비거치식 상환대출
decimal houseEtcLoan //(2012년 이후 차입분 15년 이상) 기타대출

decimal houseOfferSavings//청약저축
decimal houseOfferTotalSavings//주택청약종합저축
//decimal houseOfferLongtermSavings //장기주택마련저축 
decimal houseWorkersSave//근로자주택마련저축

//한도 계산 후 연말정산에 사용할 금액
decimal calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization //주택임차차입금원리금상환액_대출기관
decimal calculatedHouseRentLoanPrincipalRepaymentAmtLiver //주택임차차입금원리금상환액_거주자
decimal calculatedHouseMonthlyRentAmt //월세액
decimal calculatedHouseLongtermLoanAmt15Under //(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년미만
decimal calculatedHouseLongtermLoanAmt15to29 //(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년~29년
decimal calculatedHouseLongtermLoanAmt30Over //(2011년 이전 차입분) 장기주택저당차입금이자상환액_30년이상
decimal calculatedHouseFixedInterestRateNonDeferredRepaymentLoan //(2012년 이후 차입분 15년 이상) 고정금리비거치식 상환대출
decimal calculatedHouseEtcLoan //(2012년 이후 차입분 15년 이상) 기타대출

decimal calculatedHouseOfferSavings//청약저축
decimal calculatedHouseOfferTotalSavings//주택청약종합저축

decimal calculatedHouseWorkersSave//근로자주택마련저축

//한도 금액들
decimal maxLimitAmt
decimal totalSalary
decimal calculatedSumAmt

decimal limit6000000 
decimal limit10000000
decimal limit15000000
decimal limit5000000 
decimal limit3000000
decimal limit480000
decimal limit720000

//본격적인 계산
totalSalary = ads_exact.object.wincome[idx] 
limit6000000 = 6000000
limit10000000 = 10000000
limit15000000 = 15000000
limit5000000 = 5000000
limit3000000 = 3000000
limit480000 = 480000
limit720000 = 720000
maxLimitAmt = 3000000


//변수 init
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


//매핑 
houseRentLoanPrincipalRepaymentAmt_LoanOrganization = ads_incm_deduc.object.house_fund_repay[1]         //주택차입원리금상환-대출기간
houseRentLoanPrincipalRepaymentAmt_Liver =  ads_incm_deduc.object.house_fund_repay_liver[1]         //주택차입원리금상환-거주자
houseOfferSavings = ads_incm_deduc.object.house_10[1]          //주택마련저축(청약저축)
houseOfferTotalSavings =  ads_incm_deduc.object.house_20[1]         //주택마련저축(청약종합저축)
houseWorkersSave =  ads_incm_deduc.object.house_31[1] 
houseMonthlyRentAmt = ads_incm_deduc.object.monthly_rent[1]               //월세
houseLongtermLoanAmt15Under = ads_incm_deduc.object.house_fund_save_int[1]     //장기주택저당차입금 15년 미만
houseLongtermLoanAmt15to29 = ads_incm_deduc.object.house_fund_save_int_15[1]  //15~29
houseLongtermLoanAmt30Over = ads_incm_deduc.object.house_fund_save_int_30[1]  //30
houseFixedInterestRateNonDeferredRepaymentLoan =  ads_incm_deduc.object.FIXED_RATE_REPAY_LOAN[1]  //고정금리 비거치상환 대출
houseEtcLoan =  ads_incm_deduc.object.ETC_REPAY_LOAN[1] //기타대출



//1. check sum(all) == 0 then return
decimal inputTotalSum ;
inputTotalSum  = houseRentLoanPrincipalRepaymentAmt_LoanOrganization + houseRentLoanPrincipalRepaymentAmt_Liver +    houseMonthlyRentAmt + houseLongtermLoanAmt15Under + houseLongtermLoanAmt15to29 + houseLongtermLoanAmt30Over + houseFixedInterestRateNonDeferredRepaymentLoan + houseEtcLoan + houseOfferSavings + houseOfferTotalSavings  + houseWorkersSave
if  inputTotalSum = 0 then
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
end if

//한도 계산 
if  houseLongtermLoanAmt15Under > 0 then  maxLimitAmt = max( maxLimitAmt , limit6000000)
if  houseLongtermLoanAmt15to29 > 0 then maxLimitAmt =  max ( maxLimitAmt, limit10000000)
if  houseLongtermLoanAmt30Over > 0 then maxLimitAmt = max ( maxLimitAmt, limit15000000)
if  houseFixedInterestRateNonDeferredRepaymentLoan > 0 then maxLimitAmt = max ( maxLimitAmt, limit15000000)
if  houseEtcLoan > 0 then  maxLimitAmt = max ( maxLimitAmt, limit5000000)



//주택임차차입금 원리금 상환액 대출기간 한도 계산
if  houseRentLoanPrincipalRepaymentAmt_LoanOrganization > 0 and calculatedSumAmt < maxLimitAmt then
  calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization = min(truncate( houseRentLoanPrincipalRepaymentAmt_LoanOrganization * 0.4 ,0) , limit3000000)

  
  if calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization > maxLimitAmt then

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
  end if
  calculatedSumAmt = calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization
end if

//주택임차차입금 원리금 상환액 거주자 한도 계산
if houseRentLoanPrincipalRepaymentAmt_Liver > 0 and calculatedSumAmt < maxLimitAmt then
  calculatedHouseRentLoanPrincipalRepaymentAmtLiver = min( truncate( houseRentLoanPrincipalRepaymentAmt_Liver * 0.4 ,0) , limit3000000)
  if totalSalary <= 50000000 then
      if  calculatedSumAmt + calculatedHouseRentLoanPrincipalRepaymentAmtLiver > maxLimitAmt then
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
      end if
      calculatedSumAmt = calculatedSumAmt + calculatedHouseRentLoanPrincipalRepaymentAmtLiver
  end if      
end if

//월세한도 계산
if houseMonthlyRentAmt > 0 and calculatedSumAmt < maxLimitAmt then

  if totalSalary <= 50000000 then
  
    calculatedHouseMonthlyRentAmt = min(truncate( houseMonthlyRentAmt* 0.5 ,0), limit3000000)

    if calculatedSumAmt + calculatedHouseMonthlyRentAmt > maxLimitAmt then
      calculatedHouseMonthlyRentAmt = maxLimitAmt - calculatedSumAmt 
      calculatedHouseOfferSavings = 0
      calculatedHouseOfferTotalSavings = 0
      calculatedHouseWorkersSave = 0
      calculatedHouseLongtermLoanAmt15Under = 0
      calculatedHouseLongtermLoanAmt15to29 = 0
      calculatedHouseLongtermLoanAmt30Over = 0 
      calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
      calculatedHouseEtcLoan = 0
    end if
    calculatedSumAmt = calculatedSumAmt + calculatedHouseMonthlyRentAmt
  end if
end if


//저축 마련 저축 소득공제 - 청약저축 한도계산
if houseOfferSavings > 0 and calculatedSumAmt < maxLimitAmt then
  calculatedHouseOfferSavings = min( truncate( houseOfferSavings * 0.4 ,0 ) , limit480000 )

  if  calculatedSumAmt + calculatedHouseOfferSavings > maxLimitAmt then
    calculatedHouseOfferSavings = maxLimitAmt - calculatedSumAmt
    calculatedHouseOfferTotalSavings = 0
    calculatedHouseWorkersSave = 0
    calculatedHouseLongtermLoanAmt15Under = 0
    calculatedHouseLongtermLoanAmt15to29 = 0
    calculatedHouseLongtermLoanAmt30Over = 0 
    calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
    calculatedHouseEtcLoan = 0
  end if
  calculatedSumAmt =  calculatedSumAmt + calculatedHouseOfferSavings
end if

//저축 마련 저축 소득공제 - 주택청약종합저축
if houseOfferTotalSavings > 0 and calculatedSumAmt < maxLimitAmt then
  calculatedHouseOfferTotalSavings = min( truncate( houseOfferTotalSavings * 0.4 ,0) , limit480000 )

  if  calculatedSumAmt + calculatedHouseOfferTotalSavings > maxLimitAmt then

    calculatedHouseOfferTotalSavings = maxLimitAmt - calculatedSumAmt
    calculatedHouseWorkersSave = 0
    calculatedHouseLongtermLoanAmt15Under = 0
    calculatedHouseLongtermLoanAmt15to29 = 0
    calculatedHouseLongtermLoanAmt30Over = 0 
    calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
    calculatedHouseEtcLoan = 0
  end if
  calculatedSumAmt =  calculatedSumAmt + calculatedHouseOfferTotalSavings
end if


//저축 마련 저축 소득공제 - 근로자주택마련저축
if houseWorkersSave > 0 and calculatedSumAmt < maxLimitAmt then
  calculatedHouseWorkersSave = min( truncate( houseWorkersSave * 0.4 ,0) , limit720000)

  if calculatedSumAmt + calculatedHouseWorkersSave > maxLimitAmt then

    calculatedHouseWorkersSave = maxLimitAmt - calculatedSumAmt
    calculatedHouseLongtermLoanAmt15Under = 0
    calculatedHouseLongtermLoanAmt15to29 = 0
    calculatedHouseLongtermLoanAmt30Over = 0 
    calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
    calculatedHouseEtcLoan = 0
  end if
  calculatedSumAmt =  calculatedSumAmt + calculatedHouseWorkersSave
end if


//(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년미만 한도계산 
if houseLongtermLoanAmt15Under > 0 and calculatedSumAmt < maxLimitAmt then
  calculatedHouseLongtermLoanAmt15Under = min( houseLongtermLoanAmt15Under , limit6000000 )

  if  calculatedSumAmt + calculatedHouseLongtermLoanAmt15Under > maxLimitAmt then

    calculatedHouseLongtermLoanAmt15Under = maxLimitAmt - calculatedSumAmt
    calculatedHouseLongtermLoanAmt15to29 = 0
    calculatedHouseLongtermLoanAmt30Over = 0 
    calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
    calculatedHouseEtcLoan = 0
  end if
  calculatedSumAmt =  calculatedSumAmt + calculatedHouseLongtermLoanAmt15Under
end if
 
//(2011년 이전 차입분) 장기주택저당차입금이자상환액_15년~29년 한도계산 
if houseLongtermLoanAmt15to29  > 0  and calculatedSumAmt < maxLimitAmt then

  calculatedHouseLongtermLoanAmt15to29 = min(houseLongtermLoanAmt15to29, limit10000000)
  if  calculatedSumAmt +  calculatedHouseLongtermLoanAmt15to29 > maxLimitAmt then
    calculatedHouseLongtermLoanAmt15to29 = maxLimitAmt -  calculatedSumAmt
    calculatedHouseLongtermLoanAmt30Over = 0 
    calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
    calculatedHouseEtcLoan = 0
  end if
  calculatedSumAmt = calculatedSumAmt + calculatedHouseLongtermLoanAmt15to29
end if

//(2011년 이전 차입분) 장기주택저당차입금이자상환액_30년이상 한도계산
if houseLongtermLoanAmt30Over  > 0 and calculatedSumAmt < maxLimitAmt  then

  calculatedHouseLongtermLoanAmt30Over = min(houseLongtermLoanAmt30Over, limit15000000)
  if  calculatedSumAmt +  calculatedHouseLongtermLoanAmt30Over > maxLimitAmt then
    calculatedHouseLongtermLoanAmt30Over = maxLimitAmt -  calculatedSumAmt
    calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = 0
    calculatedHouseEtcLoan = 0
  end if 
  calculatedSumAmt = calculatedSumAmt + calculatedHouseLongtermLoanAmt30Over
end if

//(2012년 이후 차입분 15년 이상) 고정금리비거치식 상환대출
if houseFixedInterestRateNonDeferredRepaymentLoan  > 0 and calculatedSumAmt < maxLimitAmt  then

  calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = min(houseFixedInterestRateNonDeferredRepaymentLoan , limit15000000)
  if  calculatedSumAmt +  calculatedHouseFixedInterestRateNonDeferredRepaymentLoan > maxLimitAmt then
  
    calculatedHouseFixedInterestRateNonDeferredRepaymentLoan = maxLimitAmt - calculatedSumAmt
    calculatedHouseEtcLoan = 0    
  end if
  calculatedSumAmt = calculatedSumAmt + calculatedHouseFixedInterestRateNonDeferredRepaymentLoan
end if


//(2012년 이후 차입분 15년 이상) 기타대출
if houseEtcLoan  > 0  and calculatedSumAmt < maxLimitAmt then
  calculatedHouseEtcLoan = min( houseEtcLoan , limit5000000)
  if  calculatedSumAmt +  calculatedHouseEtcLoan > maxLimitAmt then
    calculatedHouseEtcLoan = maxLimitAmt -  calculatedSumAmt
  end if
  calculatedSumAmt = calculatedSumAmt + calculatedHouseEtcLoan
end if


//결과 매핑 
ads_exact.object.house_fund_save1_deduc[idx]  = wf_decimal_nvl(calculatedhouseOfferSavings)
ads_exact.object.house_fund_save2_deduc[idx]  = wf_decimal_nvl(calculatedhouseOfferTotalSavings)

ads_exact.object.house_fund_repay_deduc[idx]  = wf_decimal_nvl(calculatedHouseRentLoanPrincipalRepaymentAmtLoanOrganization)
ads_exact.object.house_fund_repay_liver_deduc[idx]  = wf_decimal_nvl(calculatedHouseRentLoanPrincipalRepaymentAmtLiver)
ads_exact.object.monthly_rent_deduc[idx]      = wf_decimal_nvl(calculatedHouseMonthlyRentAmt)
ads_exact.object.house_fund_save_int_deduc[idx]    = wf_decimal_nvl(calculatedHouseLongtermLoanAmt15Under)
ads_exact.object.house_fund_save_int_15_deduc[idx] = wf_decimal_nvl(calculatedHouseLongtermLoanAmt15to29)
ads_exact.object.house_fund_save_int_30_deduc[idx] = wf_decimal_nvl(calculatedHouseLongtermLoanAmt30Over)
ads_exact.object.FIXED_RATE_REPAY_LOAN[idx]   = wf_decimal_nvl(calculatedHouseFixedInterestRateNonDeferredRepaymentLoan)
ads_exact.object.ETC_REPAY_LOAN[idx]      = wf_decimal_nvl(calculatedHouseEtcLoan)
ads_exact.object.WORKER_HOUSE_SAVING_AMT[idx] = wf_decimal_nvl(calculatedhouseWorkersSave)


//return calculatedSumAmt // 주택공제 금액 
