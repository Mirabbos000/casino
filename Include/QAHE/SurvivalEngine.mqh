#ifndef __QAHE_SURVIVAL_MQH__
#define __QAHE_SURVIVAL_MQH__

#include "Types.mqh"
#include "Utilities.mqh"

class CSurvivalEngine
  {
public:
   double RiskOfRuin(double winRate,double payoff,double riskPct)
     {
      double edge=winRate-(1.0-winRate)/MathMax(payoff,0.01);
      double pressure=Normalize01(riskPct,0.25,2.0);
      return Clamp((0.5-edge)*pressure+0.25,0.0,1.0);
     }
   bool PanicMode(VolatilityRegime regime,double entropy,double ddPct)
     { return (regime==VR_PANIC)||(entropy>0.92)||(ddPct>6.0); }
  };

#endif
