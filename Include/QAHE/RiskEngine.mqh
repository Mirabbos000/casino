#ifndef __QAHE_RISK_MQH__
#define __QAHE_RISK_MQH__

#include "Types.mqh"
#include "Utilities.mqh"

class CRiskEngine
  {
public:
   double ComputeLot(double equity,double riskPct,double atr,double volFactor,double kellyFrac)
     {
      double riskMoney=equity*(riskPct/100.0);
      double stopProxy=MathMax(atr*volFactor,10*_Point);
      return MathMax(0.0,(riskMoney/stopProxy)*kellyFrac);
     }
   bool ValidateProtections(const ExposureSnapshot &x,double dailyLossPct,double maxDailyLoss,double maxDD,double maxExp,int maxHedgeDepth)
     {
      if(dailyLossPct>=maxDailyLoss) return false;
      if(x.floatingDDPct>=maxDD) return false;
      if(x.totalLots>=maxExp) return false;
      if(x.hedgeDepth>=maxHedgeDepth) return false;
      return true;
     }
  };

#endif
