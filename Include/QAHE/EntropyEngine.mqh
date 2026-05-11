#ifndef __QAHE_ENTROPY_MQH__
#define __QAHE_ENTROPY_MQH__

#include "Utilities.mqh"

class CEntropyEngine
  {
public:
   double Compute(int lookback)
     {
      int flips=0;
      double momentumVar=0.0;
      for(int i=1;i<lookback;i++)
        {
         double c0=iClose(_Symbol,_Period,i-1),o0=iOpen(_Symbol,_Period,i-1);
         double c1=iClose(_Symbol,_Period,i),o1=iOpen(_Symbol,_Period,i);
         int d0=(c0>=o0)?1:-1;
         int d1=(c1>=o1)?1:-1;
         if(d0!=d1) flips++;
         momentumVar+=MathAbs((c0-o0)-(c1-o1));
        }
      double dirEntropy=SafeDiv((double)flips,(double)(lookback-1),0.0);
      double momEntropy=Normalize01(momentumVar/lookback,0.0,20.0*_Point);
      return Clamp(0.65*dirEntropy+0.35*momEntropy,0.0,1.0);
     }
  };

#endif
