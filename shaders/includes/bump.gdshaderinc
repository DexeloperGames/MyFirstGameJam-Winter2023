vec3 bump(float height, float dist, float strength, bool invert, vec3 surf_pos, vec3 surf_norm){
	
	vec3 vSigmaS = dFdx(surf_pos);
	vec3 vSigmaT = dFdy(surf_pos);
	vec3 vN = normalize(surf_norm);
	dist = invert?-dist:dist;
	
	vec3 vR1 = cross(vSigmaT, vN);
	vec3 vR2 = cross(vN, vSigmaS);
	
	float fDet = dot(vSigmaS, vR1);
	
	float dBs = dFdx(height);
	float dBt = dFdy(height);
	
	vec3 vSurfGrad = sign(fDet)*(dBs*vR1+dBt*vR2)*dist;
	vec3 new_norm = normalize(mix(surf_norm, abs(fDet)*vN-vSurfGrad,strength));
	return new_norm;
}