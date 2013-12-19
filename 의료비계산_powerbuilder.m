//===========================================================================
// 의료비 공제 
//===========================================================================

decimal ll_medi_genera_minus_3percent = 0                  //의료비
decimal ll_med_gen = 0 
decimal ll_med_respt = 0 
decimal ll_med_obst     = 0  
decimal ll_3percent = 0 
decimal ll_self_ins_fee    = 0             //본인의료비 공제 


                                    



//KYS  ids_ajou_medi_deduc 사용안함 PY503 0의 ACC_REDUCTION_AMT 사용 
//2009 KYS genrl_ins_fee 일반의료비 

//1 본인의료비 + 진료비감액(이 병원만 해당)
ll_self_ins_fee =   ads_incm_deduc.object.self_ins_fee[1] +  ads_incm_deduc.object.acc_reduction_amt[1]
//2 65세 의료비
ll_med_respt     =  ads_incm_deduc.object.respt_ins_fee[1]                  //경로의료비
//3 장애인 의료비
ll_med_obst      =  ads_incm_deduc.object.obst_ins_fee[1]                   //장애의료비 
//4 그밖의 의료비
ll_med_gen       =  ads_incm_deduc.object.genrl_ins_fee[1]                 //일반의료비 = 일반 + 의료원 진료비 감액  부양가족의  합계액 


//#최적화
IF (ll_med_gen + ll_med_respt + ll_med_obst + ll_self_ins_fee)  <= 0 THEN
    ads_exact.object.medi_fee_deduc[idx] = 0
	 ads_exact.object.medi_disabled_fee_deduc[idx] = 0
    return 0
END IF  


//5 총급여의 3%
decimal ldc_wincome
ldc_wincome = ads_exact.object.wincome[idx] 
ll_3percent     = truncate((ldc_wincome * 0.03),0)                          //급여액 3%
//ads_exact.object.medi_fee_deduc_limit_amt[idx] = wf_nvl_decimal(ll_3percent)       //공제한도금액3%가 들어가야되겠군...




//본인 65세 이상, 장애인 제외 나머지 합계



ll_medi_genera_minus_3percent   = (  ll_med_gen - ll_3percent ) //일반의료비 - 과세급여3%
//ll_etc_medi_limit =  min(ll_medi_genera_minus_3percent , idc_limit_amt[210] )

/*6 그밖의 공제대상자 의료비공제금액 4-5
 - (④-⑤) < 0인 경우 0으로
   표시
 - (④-⑤) ≥ 0인 경우
   min[(④-⑤), 700만원]
*/	
decimal ll_etc_medi_deduc
if ll_medi_genera_minus_3percent < 0 then
	ll_etc_medi_deduc = 0
else
	ll_etc_medi_deduc = min ( ll_medi_genera_minus_3percent , idc_limit_amt[210] )
end if


//7  1,2,3 지출한 의료비 합계급액     
decimal ll_medi_deduc_sum
ll_medi_deduc_sum = ll_med_respt + ll_med_obst + ll_self_ins_fee


/*8 1,2,3 지출한 의료비 공제금액 
 - (④-⑤) < 0인 경우
   max{[(①+②+③) - (⑤-④)], 0} 
- (④-⑤) ≥ 0인 경우 (①+②+③)
*/
decimal ll_medi_deduc_sum_deduc
if ll_medi_genera_minus_3percent < 0 then
	ll_medi_deduc_sum_deduc = max ( ( ll_medi_deduc_sum ) - ( ll_3percent - ll_med_gen ) , 0 ) 
else
	ll_medi_deduc_sum_deduc = ll_medi_deduc_sum
end if

//9 의료비 공제금액 => 6+8
decimal ll_medi_deduc_amt
ll_medi_deduc_amt = ll_etc_medi_deduc + ll_medi_deduc_sum_deduc

//10 장애인 의료비=> min(9,3)
decimal ll_disable_medi_amt 
ll_disable_medi_amt = min ( ll_medi_deduc_amt , ll_med_obst )
//11 기타 의료비 ( 9-10) 
decimal ll_etc_medi_amt
ll_etc_medi_amt = ll_medi_deduc_amt - ll_disable_medi_amt

//장애인
ads_exact.object.medi_disabled_fee_deduc[idx] = ll_disable_medi_amt
//기타 
ads_exact.object.medi_fee_deduc[idx] = ll_etc_medi_amt

return 1