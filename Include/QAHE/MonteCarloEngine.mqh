#ifndef __QAHE_MONTECARLO_MQH__
#define __QAHE_MONTECARLO_MQH__

#include "Types.mqh"
#include "Utilities.mqh"

class CMonteCarloEngine
  {
public:
   MonteCarloMetrics Run(const double &returns[],int n,double startEquity,int paths=200)
     {
      MonteCarloMetrics m={0};
      if(n<=0||startEquity<=0){ m.safe=false; return m; }
      double ddSum=0.0, ruinCount=0.0, worst=DBL_MAX, maxdd=0.0;
      for(int p=0;p<paths;p++)
        {
         double eq=startEquity, peak=startEquity, localMaxDD=0.0;
         for(int i=0;i<n;i++)
           {
            int idx=(int)MathFloor((double)MathRand()/32767.0*n);
            idx=(int)Clamp(idx,0,n-1);
            double shock=1.0+((MathRand()%1000)/1000.0-0.5)*0.002;
            double slip=((MathRand()%1000)/1000.0)*0.0003;
            eq*=1.0+(returns[idx]*shock-slip);
            peak=MathMax(peak,eq);
            localMaxDD=MathMax(localMaxDD,SafeDiv(peak-eq,peak,0.0));
           }
         maxdd=MathMax(maxdd,localMaxDD);
         ddSum+=localMaxDD;
         if(eq<startEquity*0.7) ruinCount+=1.0;
         worst=MathMin(worst,eq);
        }
      m.maxDD=maxdd; m.avgDD=ddSum/paths; m.ruinProbability=ruinCount/paths;
      m.sharpe=SafeDiv(0.02,m.avgDD+1e-6,0.0);
      m.recoveryBars=SafeDiv(m.maxDD,0.001,0.0);
      m.worstEquity=worst;
      m.safe=(m.ruinProbability<0.1 && m.maxDD<0.25);
      return m;
     }
  };

#endif
