--鎧竜降臨
--
--"LUA BY REIKAI"
function c101103064.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,101103037,nil,c101103064.mfilter) 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101103064)
	e1:SetCondition(aux.exccon)
	e1:SetCost(c101103064.spcost)
	e1:SetTarget(c101103064.sptg)
	e1:SetOperation(c101103064.spop)
	c:RegisterEffect(e1)
end
function c101103064.mfilter(c)
	return c:IsCode(101103037)
end
function c101103064.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x10cf)
end
function c101103064.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:GetLevel()>0
end
function c101103064.spzfilter(g,tp)
	if Duel.GetMZoneCount(tp,g,tp)<=0 then return false end
	return g:GetSum(Card.GetLevel)>=4
end
function c101103064.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_HAND,0)
	local sg=g:Filter(c101103064.cfilter,nil)
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and sg:GetSum(Card.GetLevel)>=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=sg:SelectSubGroup(tp,c101103064.spzfilter,false,1,99,tp)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c101103064.spfilter(c,e,tp)
	return c:IsCode(101103037) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101103064.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101103064.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101103064.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not (c:IsRelateToEffect(e) and c:IsAbleToRemove() and c:IsLocation(LOCATION_GRAVE)) then return false end
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101103064.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end