#ifndef __QAHE_PROB_MQH__
#define __QAHE_PROB_MQH__

#include "Utilities.mqh"
#include "Types.mqh"

class CProbabilityEngine
  {
private:
   double wVol,wEnt,wLiq,wTrend,wZone;
public:
   void Configure(double a,double b,double c,double d,double e)
     {
      double s=a+b+c+d+e;
      if(s<=0.0) s=1.0;
      wVol=a/s; wEnt=b/s; wLiq=c/s; wTrend=d/s; wZone=e/s;
     }
   double Score(const ProbabilityFeatures &f)
     {
      double entropyQuality=1.0-f.entropy;
      double raw=wVol*f.volatility+wEnt*entropyQuality+wLiq*f.liquidity+wTrend*f.trend+wZone*f.zones;
      raw=0.9*raw+0.1*f.momentum;
      return Clamp(raw,0.0,1.0);
     }
  };

#endif
