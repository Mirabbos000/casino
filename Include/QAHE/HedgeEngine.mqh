#ifndef __QAHE_HEDGE_MQH__
#define __QAHE_HEDGE_MQH__

#include "Utilities.mqh"

class CHedgeEngine
  {
public:
   double HedgeRatio(double ddPct,double entropy,double baseRatio,double maxRatio)
     {
      double pressure=0.6*Normalize01(ddPct,1.0,8.0)+0.4*entropy;
      return Clamp(baseRatio+pressure*(maxRatio-baseRatio),baseRatio,maxRatio);
     }
   bool ShouldHedge(double ddPct,double entropy,bool panic){ return (ddPct>2.0 && entropy<0.9) || panic; }
   bool ShouldUnwind(double ddPct,double entropy){ return ddPct<1.0 && entropy<0.6; }
  };

#endif
